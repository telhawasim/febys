//
//  AskQuestionViewController.swift
//  febys
//
//  Created by Faisal Shahzad on 09/11/2021.
//

import UIKit

protocol AskQuestionDelegate {
    func responseCallBack(threads: [QnAThread]?)
}

class AskQuestionViewController: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var mainLabel: FebysLabel!
    @IBOutlet weak var subLabel: FebysLabel!
    @IBOutlet weak var questionTextField: UITextView!
    @IBOutlet weak var sendButton: FebysButton!
    
    //MARK: Properties
    var isReply: Bool = false
    var productId: String?
    var threadId: String?
    var delegate: AskQuestionDelegate?
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = threadId { self.isReply = true }
        else { self.isReply = false }
        
        self.configure()
        self.setupButtonActions()
    }
    
    //MARK: SetupButtons
    func setupButtonActions() {
        sendButton.didTap = { [weak self] in
            guard let self = self else {return}
            if self.validateTextFields() {
                self.askQuestion(productId: self.productId, threadId: self.threadId)
            }
        }
    }
    
    //MARK: Helper
    func configure() {
        if isReply {
            self.mainLabel.text = Constants.replyToQuestion
            self.subLabel.text = Constants.reply
        } else {
            self.mainLabel.text = Constants.askAboutQuestion
            self.subLabel.text = Constants.questions
        }
    }
    
    func validateTextFields() -> Bool {
        guard let question = questionTextField.text?.condensingWhitespace() else { return false }
        
        // CHECK VALIDATY
        var errorMessage : String?
        
        if question.isEmpty{
            isReply
            ? (errorMessage = Constants.answer)
            : (errorMessage = Constants.question)
            errorMessage! += " \(Constants.IsRequired)."
        }
        if  let errorMxg = errorMessage{
            self.showMessage(Constants.Error, errorMxg, onDismiss: nil)
            return false
        }
        return true
    }
    
    //MARK: API Calling
    func askQuestion(productId: String?, threadId: String? = nil) {
        var bodyParams = [ParameterKeys.message: questionTextField.text ?? "" ]
        if let id = threadId { bodyParams[ParameterKeys.id] = id }
        
        Loader.show()
        QNAService.shared.askQuestion(productId: productId ?? "", body: bodyParams) { response in
            Loader.dismiss()
            switch response {
            case .success(let threads):
                self.delegate?.responseCallBack(threads: threads.questionAnswers?.threads?.reversed())
                self.backButtonTapped(self)
                break
            case .failure(let error):
                self.showMessage(Constants.Error, error.localizedDescription, onDismiss: nil)
            }
        }
    }
}
