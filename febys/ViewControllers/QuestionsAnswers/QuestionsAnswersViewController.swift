//
//  QuestionsAnswersViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 09/11/2021.
//

import UIKit

class QuestionsAnswersViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var crossButton: FebysButton!
    
    //MARK: Properties
    var productId: String?
    var threadId: String?
    var qaThreads: [QnAThread]?
    var delegate: AskQuestionDelegate?

    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        crossButton.didTap = { [weak self] in
            guard let self = self else { return }
            self.delegate?.responseCallBack(threads: self.qaThreads)
            self.backButtonTapped(self.crossButton!)
        }
    }
    
    //MARK: Helpers
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmptyViewsTableViewCell.className)
        tableView.register(QuestionViewCell.className)
        
        if let id = threadId {
            let row = qaThreads?.firstIndex(where: {$0.id == id}) ?? 0
            let indexPath = IndexPath(row: row, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    //MARK: Navigation
    func presentAskQuestion(productId: String, threadId: String?) {
        let vc = UIStoryboard.getVC(from: .Product, AskQuestionViewController.className) as! AskQuestionViewController
        vc.delegate = self
        vc.productId = productId
        vc.threadId = threadId
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        RedirectionManager.shared.presentOnRoot(vc, animated: true, completion: nil)
    }
    
    //MARK: API Calling
    func upVoteQuestion(of productId: String, where threadId: String, didRevoke: Bool) {
        QuestionVotingService.shared.upVote(productId: productId, threadId: threadId, method: didRevoke ? .DELETE : .POST) { response in }
        
    }
    
    func downVoteQuestion(of productId: String, where threadId: String, didRevoke: Bool) {
        QuestionVotingService.shared.downVote(productId: productId, threadId: threadId, method: didRevoke ? .DELETE : .POST) { response in }
    }
}

//MARK: AskQuestion Delegate
extension QuestionsAnswersViewController: AskQuestionDelegate {
    func responseCallBack(threads: [QnAThread]?) {
        self.qaThreads = threads
        self.tableView.reloadData()
    }
}

//MARK: Question Delegate
extension QuestionsAnswersViewController: QuestionDelegate {
    func didTapUpVote(threadId: String?, isVoted: Bool?) {
        if let productId = self.productId,
           let threadId = threadId, let voted = isVoted {
            self.upVoteQuestion(of: productId, where: threadId, didRevoke: voted)
        }
    }
    
    func didTapDownVote(threadId: String?, isVoted: Bool?) {
        if let productId = self.productId,
           let threadId = threadId, let voted = isVoted {
            self.downVoteQuestion(of: productId, where: threadId, didRevoke: voted)
        }
    }
    
    func didTapReply(threadId: String?) {
        if let productId = self.productId, let threadId = threadId {
            self.presentAskQuestion(productId: productId, threadId: threadId)
        }
    }
}

//MARK: UITabelView
extension QuestionsAnswersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if qaThreads?.count ?? 0 == 0{ return 1 } else {
            return qaThreads?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if qaThreads?.count ?? 0 == 0{
            return tableView.frame.height - 1
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if qaThreads?.count ?? 0 == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyViewsTableViewCell.className, for: indexPath) as! EmptyViewsTableViewCell
            cell.configure(title: Constants.EmptyScreenTitle, description: Constants.EmptyScreenQuestionsDescription)
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: QuestionViewCell.className, for: indexPath) as! QuestionViewCell
            
            cell.delegate = self
            cell.leadingConstraint.constant = 21.0
            cell.trailingConstraint.constant = 21.0
            cell.configure(qaThreads?[indexPath.row])
            return cell
            
        }
    }
}
