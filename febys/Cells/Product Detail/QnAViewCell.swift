//
//  QnAViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 04/11/2021.
//

import UIKit

protocol QnACellDelegate {
    func didTapSeeMore(productId: String, threads: [QnAThread])
}

class QnAViewCell: UIView {
    
    //MARK: IBOutlets
    @IBOutlet weak var questionStackView: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var noQuestionView: UIView!
    @IBOutlet weak var seeMoreButton: FebysButton!
    @IBOutlet weak var askQustionButton: FebysButton!

    //MARK: Variables
    var delegate: QnACellDelegate?
    var product: Product?
    
    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupButtonActions()
    }
    
    //MARK: SetupButtons
    func setupButtonActions() {
        seeMoreButton.didTap = { [weak self] in
            self?.goToQuestionAnswerListing(productId: self?.product?.id ?? "", threads: self?.product?.questionAnswers ?? [])
        }
        
        askQustionButton.didTap = { [weak self] in
            if User.fetch() != nil {
                self?.presentAskQuestion(productId: self?.product?.id ?? "", threadId: nil)
            } else {
                RedirectionManager.shared.goToLogin()
            }
        }
    }
    
    //MARK: Configure
    func configure(_ product: Product?) {
        self.product = product
//        _ = self.product?.questionAnswers?.reverse()
        if self.product?.questionAnswers?.count == 0 {
            showNoQustionView(true)
        } else {
            showNoQustionView(false)
            if (self.product?.questionAnswers?.count ?? 0) > 3 {
                showSeeMoreButton(false)
                configureStackView(with: self.product?.questionAnswers, isMore: true)
            } else {
                showSeeMoreButton(true)
                configureStackView(with: self.product?.questionAnswers, isMore: false)

            }
        }
    }
    
    //MARK: Helpers
    private func showSeeMoreButton(_ isHidden: Bool) {
        if isHidden { seeMoreButton.isHidden = true }
        else { seeMoreButton.isHidden = false }
    }
    
    private func showNoQustionView(_ isHidden: Bool) {
        if isHidden {
            stackView.isHidden = true
            noQuestionView.isHidden = false
        } else {
            stackView.isHidden = false
            noQuestionView.isHidden = true
        }
    }
    
    private func configureStackView(with questions: [QnAThread]?, isMore: Bool) {
        questionStackView.removeAllArrangedSubviews()
        
        if let questions = questions {
            if isMore {
                for (index, threads) in questions.enumerated() {
                    if index < 3 {
                        addItem(in: questionStackView, with: threads)
                    }
                }
            } else {
                for threads in questions {
                    addItem(in: questionStackView, with: threads)
                }
            }
        }
    }
    
    private func addItem(in stackView: UIStackView, with question: QnAThread) {
        let questionCell: QuestionViewCell = UIView.fromNib()
        questionCell.configure(question)
        questionCell.delegate = self
        stackView.addArrangedSubview(questionCell)
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
    
    func goToQuestionAnswerListing(productId: String, threads: [QnAThread]) {
        let vc = UIStoryboard.getVC(from: .Product, QuestionsAnswersViewController.className) as! QuestionsAnswersViewController
        vc.delegate = self
        vc.productId = productId
        vc.qaThreads = threads
        vc.modalPresentationStyle = .fullScreen

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
extension QnAViewCell: AskQuestionDelegate {
    func responseCallBack(threads: [QnAThread]?) {
        self.product?.questionAnswers = threads
        self.configure(self.product)
    }
}

//MARK: Question Delegate
extension QnAViewCell: QuestionDelegate {
    func didTapUpVote(threadId: String?, isVoted: Bool?) {
        if let productId = self.product?.id,
            let threadId = threadId, let voted = isVoted {
            self.upVoteQuestion(of: productId, where: threadId, didRevoke: voted)
        }
    }
    
    func didTapDownVote(threadId: String?, isVoted: Bool?) {
        if let productId = self.product?.id,
            let threadId = threadId, let voted = isVoted {
            self.downVoteQuestion(of: productId, where: threadId, didRevoke: voted)
        }
    }
    
    func didTapReply(threadId: String?) {
        if let productId = self.product?.id, let threadId = threadId {
            self.presentAskQuestion(productId: productId, threadId: threadId)
        }
    }
}
