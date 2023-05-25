//
//  QuestionViewCell.swift
//  febys
//
//  Created by Faisal Shahzad on 28/09/2021.
//

import UIKit

protocol QuestionDelegate {
    func didTapUpVote(threadId: String?, isVoted: Bool?)
    func didTapDownVote(threadId: String?, isVoted: Bool?)
    func didTapReply(threadId: String?)
}

class QuestionViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var noReplyView: UIView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var replyButton: FebysButton!
    @IBOutlet weak var likeButton: FebysButton!
    @IBOutlet weak var dislikeButton: FebysButton!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!

    //MARK: Properties
    var consumerId: String?
    var thread: QnAThread?
//    var threadId: String?
    var delegate: QuestionDelegate?
    var upVotes = 0
    var downVotes = 0

    //MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        if let id = UserInfo.fetch()?.consumerInfo?.id {
            self.consumerId = "\(id)"
        }
        setupButtonAction()
    }
    
    //MARK: IBActions
    func setupButtonAction() {
        replyButton.didTap = { [weak self] in
            if User.fetch() != nil {
                self?.delegate?.didTapReply(threadId: self?.thread?.id)
            } else { RedirectionManager.shared.goToLogin() }
        }
        
        likeButton.didTap = { [weak self] in
            if User.fetch() != nil {
                self?.delegate?.didTapUpVote(threadId: self?.thread?.id,
                                             isVoted: self!.isUpVoted())
                
                self?.updateVoteCount(self!.likeButton,
                                      isVoted: self!.isUpVoted(),
                                      count: &self!.upVotes,
                                      votes: &(self!.thread!.upVotes)!)
                
                if self!.isDownVoted() {
                    self?.updateVoteCount(self!.dislikeButton,
                                          isVoted: self!.isDownVoted(),
                                          count: &self!.downVotes,
                                          votes: &(self!.thread!.downVotes)!)
                }
                
            } else {
                RedirectionManager.shared.goToLogin()
            }
        }
        
        dislikeButton.didTap = { [weak self] in
            if User.fetch() != nil {
                self?.delegate?.didTapDownVote(threadId: self?.thread?.id,
                                               isVoted: self!.isDownVoted())
                
                self?.updateVoteCount(self!.dislikeButton,
                                      isVoted: self!.isDownVoted(),
                                      count: &self!.downVotes,
                                      votes: &(self!.thread!.downVotes)!)
                
                if self!.isUpVoted() {
                    self?.updateVoteCount(self!.likeButton,
                                          isVoted: self!.isUpVoted(),
                                          count: &self!.upVotes,
                                          votes: &(self!.thread!.upVotes)!)
                }
            } else {
                RedirectionManager.shared.goToLogin()
            }
        }
    }
    
    //MARK: Helper
    private func configureStackView(with answers: [ChatModel]) {
        stackView.removeAllArrangedSubviews()
        
        if answers.count >= 1 {
            showNoReplyLabel(false)
            for answer in answers {
                addItem(in: stackView, with: answer)
            }
        } else {
            showNoReplyLabel(true)
        }
    }
    
    private func setVoteCountOf(_ button: FebysButton, with count: Int) {
        button.setTitle("\(count)", for: .normal)
        button.setTitle("\(count)", for: .selected)
    }
    
    private func updateVoteCount(_ button: FebysButton, isVoted: Bool, count: inout Int, votes: inout [String]) {
        if isVoted {
            if let i = votes.firstIndex(of: consumerId ?? "") {
                button.isSelected = false
                votes.remove(at: i)
                (count > 0) ? (count -= 1) : (count = 0)
            }
        } else {
            button.isSelected = true
            votes.append(consumerId ?? "")
            count += 1
        }
        self.setVoteCountOf(button, with: count)
    }
    
    private func isUpVoted() -> Bool {
        if let upVotes = thread?.upVotes {
            if upVotes.contains(self.consumerId ?? "") { return true }
            else { return false }
        }
        return false
    }
    
    private func isDownVoted() -> Bool {
        if let downVotes = thread?.downVotes {
            if downVotes.contains(self.consumerId ?? "") { return true }
            else { return false }
        }
        return false
    }
    
    private func showNoReplyLabel(_ isHidden: Bool) {
        if isHidden {
            noReplyView.isHidden = false
            stackView.isHidden = true
        } else {
            noReplyView.isHidden = true
            stackView.isHidden = false
        }
    }
    
    private func addItem(in stackView: UIStackView, with answers: ChatModel) {
        let answerCell: AnswersViewCell = UIView.fromNib()
        answerCell.configure(answers)
        stackView.addArrangedSubview(answerCell)
    }
    
    //MARK: Configure
    func configure(_ qna: QnAThread?) {
        self.thread = qna
        self.upVotes = qna?.upVotes?.count ?? 0
        self.downVotes = qna?.downVotes?.count ?? 0
        
        self.likeButton.isSelected = isUpVoted()
        self.dislikeButton.isSelected = isDownVoted()
        
        if let q = qna?.chat?.first { questionLabel.text = q.message }
        self.setVoteCountOf(likeButton, with: upVotes)
        self.setVoteCountOf(dislikeButton, with: downVotes)

        var chats = qna?.chat
        chats?.removeFirst()
        configureStackView(with: chats ?? [])
    }
}


