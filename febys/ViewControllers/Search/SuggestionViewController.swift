//
//  SuggestionViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 22/07/2022.
//

import UIKit

class SuggestionViewController: BaseViewController {

    //MARK: OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: FebysTextField!
    @IBOutlet weak var searchButton: FebysButton!
    @IBOutlet weak var clearSearchButton: FebysButton!
        
    //MARK: PROPERTIES
    private var debouncer: Debouncer!
    private var searchStr = "" { didSet { debouncer.call() } }
    var suggestions: SuggestionsResponse?
    var totalRows = 0
    var pageNo = 1
    var pageSize = 15
    var isSearched = false


    //MARK: LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.becomeFirstResponder()

        configureTableView()
        setupActionButtons()
        listenSearchTextChanges()

        debouncer = Debouncer.init(delay: 0.3, callback: performNetworkCall)
        hideClearButton(searchTextField.text?.isEmpty ?? true)
        searchTextField.addTarget(self,
                                  action: #selector(self.textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    //MARK: METHODS
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SuggestionTableViewCell.className)
        tableView.registerHeaderFooter(EmptyListHeaderView.className)
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func listenSearchTextChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(searchTextChanged), name: .textFieldChanged, object: nil)
    }
    
    @objc func searchTextChanged(_ notificaiton: Notification) {
        if let textField = notificaiton.object as? UITextField,
           let text = textField.text {
            if !text.isEmpty && text != searchStr {
                suggestions = nil
                pageNo = 1
                searchStr = text
            }
        }
    }
    
    //MARK: IBACTIONS
    func setupActionButtons() {
        searchButton.didTap = { [weak self] in
            self?.goToProductList(title: "Search Results", filterType: .searchProduct(searchStr: self?.searchTextField.text ?? ""), AllProductsRepository(self?.searchTextField.text ?? ""))
        }
        
        clearSearchButton.didTap = { [self] in
            self.searchStr = ""
            self.searchTextField.text = nil
            self.suggestions = nil
            self.isSearched = false
            self.hideClearButton(searchTextField.text?.isEmpty ?? true)
            self.reloadTableData()
        }
    }
    
    //MARK: Hide Button
    func hideClearButton(_ isHidden: Bool){
        self.clearSearchButton.isHidden = isHidden ? true : false
    }
    
    //MARK: NAVIGATION
    func goToProductList(title: String, filterType: FilterType, _ repo: ProductRepository){
        let vc = UIStoryboard.getVC(from: .Product, ProductListViewController.className) as! ProductListViewController
        vc.titleName = title
        vc.filterType = filterType
        vc.repo = repo
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func goToProductDetail(_ productId: String, skuId: String){
        let vc = UIStoryboard.getVC(from: .Product, ProductDetailViewController.className) as! ProductDetailViewController
        vc.productId = productId
        vc.preferredSkuId = skuId
        self.tabBarController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: TextFieldDelgate
extension SuggestionViewController: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.hideClearButton(searchTextField.text?.isEmpty ?? true)
        if let isEmpty = searchTextField.text?.isEmpty, isEmpty {
            self.searchStr = ""
            self.isSearched = false
            self.suggestions = nil
            self.cancelPreviousNetworkCall()
            self.reloadTableData()
        } else {
            NotificationCenter.default.post(name: .textFieldChanged, object: textField)
        }
    }
}

//MARK: UITableView
extension SuggestionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions?.listing?.search?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (suggestions?.listing?.search?.count ?? 0) < 1 {
            return tableView.frame.height - 100
        } else {
            return .leastNormalMagnitude
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (suggestions?.listing?.search?.count ?? 0) < 1 {
            let image = isSearched ? "EmptyViewIcon" : "search_empty"
            let title = isSearched ? "Oops!" : "Search"
            let description = isSearched
            ? "Sorry, it seems that the product you are looking for does not exist."
            : "Please type any keyword in the top search bar"

            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EmptyListHeaderView.className) as! EmptyListHeaderView
            header.configure(icon: image, title: title, description: description)
            return header
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionTableViewCell.className, for: indexPath) as! SuggestionTableViewCell
        cell.configure(with: suggestions?.listing?.search?[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let count = suggestions?.listing?.search?.count,
            let totalPages = suggestions?.listing?.paginationInfo?.totalPages {
            if indexPath.row == count - 3 {
                if (pageNo + 1) <= totalPages {
                    pageNo += 1
                    performNetworkCall()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let product = suggestions?.listing?.search?[indexPath.row],
           let id = product.productId, let sku = product.skuId {
            self.goToProductDetail(id, skuId: sku)
        }
    }
    
}

//MARK: API CALLING
extension SuggestionViewController {
    
    private func cancelPreviousNetworkCall() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(fetchSuggestions), object: nil)
    }
    
    private func performNetworkCall() {
        cancelPreviousNetworkCall()
        if !searchStr.isEmpty {
            self.perform(#selector(fetchSuggestions), with: nil, afterDelay: 0)
        }
    }
    

    @objc func fetchSuggestions() {
        let params = [ParameterKeys.chunkSize: pageSize,
                      ParameterKeys.pageNo: pageNo] as [String : Any]
        
        let bodyParams = [ParameterKeys.searchStr: searchStr]
        
        
        SuggestionsService.shared.getProductSuggestions(params: params, body: bodyParams) { response in
            switch response {
            case .success(let suggestionResponse):
                self.totalRows = suggestionResponse.listing?.totalRows ?? 0
                if !self.searchStr.isEmpty {
                    if self.suggestions != nil && self.pageNo > 1 {
                        self.suggestions?.listing?.search?.append(contentsOf: suggestionResponse.listing?.search ?? [])
                    }else{
                        self.suggestions = suggestionResponse
                    }
                    
                    self.isSearched = true
                    self.reloadTableData()
                }
                
            case .failure(let error):
                self.isSearched = true
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            
            }
        }
    }
}
