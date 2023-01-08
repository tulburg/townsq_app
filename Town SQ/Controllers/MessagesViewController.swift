//
//  MessagesViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit
import NotificationCenter

class MessagesViewController: ViewController, SocketDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
	
	var tableView: UITableView!
	var messageField: UITextView!
    var messageContainer: UIView!
    var sendButton: UIImageView!
    var tableContainer: UIView!
	
	var messageContainerBottomConstraint: NSLayoutConstraint!
	var titleContainerHeightConstraint: NSLayoutConstraint!
	var messageFieldHeightConstraint: NSLayoutConstraint!
    var messageCellHeightConstraint: NSLayoutConstraint!
	
	var messageFieldHeight: CGFloat = 0
    var broadcast: Broadcast!
    var comments: [Comment] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        if broadcast.active == nil {
            Socket.shared.joinBroadcast(broadcast)
            broadcast.active = BroadcastType.Active.rawValue
            broadcast.joined = Date()
            DB.shared.save()
        }
        broadcast.comments?.array.forEach { comment in
            comments.append((comment as? Comment)!)
        }
        comments = comments.sorted{
            return $0.created! > $1.created!
        }.sorted{
            return ($0.vote + $0.user_vote) > ($1.vote + $1.user_vote)
        }
        
        navigationItem.title = "Broadcast"
		
		self.navigationItem.backBarButtonItem?.setBackButtonBackgroundVerticalPositionAdjustment(20, for: .default)
	
		let backButton = UIBarButtonItem()
		backButton.title = ""
		backButton.image = UIImage()
		self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: .none)
		
		self.view.backgroundColor = Color.background
		
		tableContainer = UIView()
		tableContainer.backgroundColor = Color.darkBlue
		
		tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 72
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		tableView.separatorStyle = .none
		tableView.backgroundColor = Color.background
		tableView.keyboardDismissMode = .onDrag
        tableView.register(MessageCell.self, forCellReuseIdentifier: "message_cell")
        tableView.register(OwnMessageCell.self, forCellReuseIdentifier: "own_message_cell")
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feed_cell_as_header")
        tableView.register(FeedCell.self, forCellReuseIdentifier: "feed_cell_as_header_with_media")
		
		messageField = UITextView()
		messageField.text = "Message here"
        messageField.backgroundColor = UIColor.clear
		messageField.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -2)
        messageField.textColor = Color.lightText
        messageField.font = UIFont.systemFont(ofSize: 18)
		messageField.delegate = self
        messageField.textAlignment = .natural
        messageField.showsVerticalScrollIndicator = false
		
		tableContainer.addSubview(tableView)
		tableContainer.constrain(type: .horizontalFill, tableView)
		tableContainer.addConstraints(format: "V:|-0-[v0]-0-|", views: tableView)
        messageContainer = UIView()
        let borderBottom = UIView()
        borderBottom.backgroundColor = UIColor.clear // Color.separator
        let buttonImage = UIImage(systemName: "arrow.up.circle.fill")?.withTintColor(Color.darkBlue_white, renderingMode: .alwaysOriginal)
        sendButton = UIImageView(image: buttonImage)
        sendButton.isUserInteractionEnabled = true
        sendButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(postComment)))
        
        let messageWrap = UIView()
        messageWrap.layer.cornerRadius = 20
        messageWrap.backgroundColor = Color.backgroundDark
        messageWrap.add().horizontal(8).view(messageField).gap(0).view(sendButton, 36).end(4)
        messageWrap.add().vertical(0).view(messageField, ">=35").end(0)
        messageWrap.add().vertical(">=0").view(sendButton, 35).end(2)
        let borderTop = UIView()
        borderTop.backgroundColor = Color.separator
        messageContainer.add().vertical(">=0").view(borderTop, 1).gap(6).view(messageWrap, ">=40").end(4)
        messageContainer.constrain(type: .horizontalFill, messageWrap, margin: 16)
        messageContainer.constrain(type: .horizontalFill, borderTop)
        messageContainer.backgroundColor = Color.background
        
        view.add().vertical(0).view(tableContainer).gap(0).view(messageContainer, 52).end(safeAreaInset!.bottom)
        view.constrain(type: .horizontalFill, tableContainer, messageContainer)
        
        for c in self.view.constraints where c.firstAttribute == .bottom && c.secondItem as? UIView == messageContainer {
            messageContainerBottomConstraint = c
        }
        
        for c in messageWrap.constraints where c.firstAttribute == .height && c.firstItem as? UIView == messageField {
            messageFieldHeightConstraint = c
        }
        
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Socket.shared.registerDelegate(self)
        
        Socket.shared.markUnread(broadcast)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: .none)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: .none)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: .none)
        
        Socket.shared.unregisterDelegate(self)
    }
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return comments.count + 1
	}
    var messageCell: UITableViewCell!
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            var headerCell: FeedCell!
            if broadcast.media != nil && broadcast.media_type != nil {
                headerCell = tableView.dequeueReusableCell(withIdentifier: "feed_cell_as_header_with_media") as? FeedCell
            }else {
                headerCell = tableView.dequeueReusableCell(withIdentifier: "feed_cell_as_header") as? FeedCell
            }
            headerCell?.setup(broadcast)
            return headerCell!
        }
        let comment = comments[indexPath.row - 1]
//        if(comment.user?.id == user?.id) {
//            let cell = (tableView.dequeueReusableCell(withIdentifier: "own_message_cell", for: indexPath) as? OwnMessageCell)!
//            cell.build(comment)
//            return cell
//		}else {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "message_cell", for: indexPath) as? MessageCell)!
            cell.build(comment)
            if (indexPath.row - 1) == self.comments.count - 1 {
                cell.hideSeparator()
            }
            cell.onVoteChange = { vote in
                tableView.reloadRows(at: [indexPath], with: .none)
                
                Socket.shared.publishVote(comment, vote)
            }
            return cell
//		}
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
        if let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            if messageContainerBottomConstraint != nil {
                messageContainerBottomConstraint.constant = (kFrame.height + 4)
            }
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.view.layoutIfNeeded()
                self.tableView.scrollToRow(at: IndexPath(row: self.comments.count, section: 0), at: .bottom, animated: true)
            }, completion: { _ in
                
            })
        }
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
        if messageContainerBottomConstraint != nil {
            messageContainerBottomConstraint.constant = 44
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
	}
    
    @objc func postComment() {
        if let body = messageField.text {
            messageField.resignFirstResponder()
            messageField.text = "Message here"
            messageField.textColor = Color.lightText
            Socket.shared.publishComment(body, broadcast, nil, nil)
        }
    }
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.text == "Message here" {
            textView.text = nil
            textView.textColor = Color.black_white
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.count == 0 {
			textView.text = "Message here"
            textView.textColor = Color.lightText
		}
	}
	
	func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            self.view.constraints.forEach({ constraint in
                if constraint.firstAttribute == .height && (constraint.firstItem as? UIView) == messageContainer {
                    constraint.constant = 40 + 12
                }
            })
            messageFieldHeightConstraint.constant = 40
            self.messageField.superview?.layoutIfNeeded()
            return
        }
        
        let size = CGSize(width: textView.frame.size.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        if textView.contentSize.height > 116 { textView.isScrollEnabled = true; }
        else { textView.isScrollEnabled = false }
        if estimatedSize.height < 52 { return }
        self.view.constraints.forEach({ constraint in
            if constraint.firstAttribute == .height && (constraint.firstItem as? UIView) == messageContainer {
                constraint.constant = min(estimatedSize.height, 116) + 12
            }
        })
        tableView.scrollToRow(at: IndexPath(row: self.comments.count, section: 0), at: .bottom, animated: false)
        messageFieldHeightConstraint.constant = min(estimatedSize.height, 116)
        self.messageField.superview?.layoutIfNeeded()
	}
    
    func socket(didReceive event: Constants.Events, data: ResponseData) {
        if event == .GotComment {
            if let newComment = data as? DataType.NewComment {
                if newComment.broadcast_id == broadcast.id {
                    comments = []
                    broadcast.comments?.array.forEach { comment in
                        comments.append((comment as? Comment)!)
                    }
                    tableView.reloadData()
                }
            }
        }
        
        if event == .GotVote {
            if let comment = data as? DataType.NewVote {
                if broadcast.comments?.first(where: {
                    return ($0 as? Comment)?.id == comment.id
                }) != nil {
                    comments = []
                    broadcast.comments?.array.forEach { comment in
                        comments.append((comment as? Comment)!)
                    }
                    tableView.reloadData()
                }
            }
        }
        
        if event == .GotUser {
            if let broadcast = data as? DataType.BroadcastUpdate {
                if self.broadcast.id == broadcast.id {
                    tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                }
            }
        }
    }
}
