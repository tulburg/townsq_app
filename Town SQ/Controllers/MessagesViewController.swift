//
//  MessagesViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit
import NotificationCenter

class MessagesViewController: ViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
	
	var tableView: UITableView!
	var messageField: UITextView!
	var messages: [Message] = []
    var messageContainer: UIView!
    var sendButton: UIImageView!
	
	var messageContainerBottomConstraint: NSLayoutConstraint!
	var titleContainerHeightConstraint: NSLayoutConstraint!
	var messageFieldHeightConstraint: NSLayoutConstraint!
    var messageCellHeightConstraint: NSLayoutConstraint!
	
	var messageFieldHeight: CGFloat = 0
    var broadcast: Broadcast!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        Socket.shared.start()
        navigationItem.title = "Broadcast"
        
		let text = "[{\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been going around about a guy that claims to have found big foot in his backyard.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Kim\", \"body\": \"There’s this story that has been. For some, somethings will never change\"},{\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been going around about a guy that claims to have found big foot in his backyard.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Kim\", \"body\": \"There’s this story that has been. For some, somethings will never change\"},{\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been going around about a guy that claims to have found big foot in his backyard.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Kim\", \"body\": \"There’s this story that has been. For some, somethings will never change\"},{\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been going around about a guy that claims to have found big foot in his backyard.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Kim\", \"body\": \"There’s this story that has been. For some, somethings will never change\"}]"
		if let dicts = text.data(using: .utf8)?.toJsonArray() as? [NSDictionary] {
			dicts.forEach({ dict in
				messages.append(Message(dict))
			})
		}
		
		self.navigationItem.backBarButtonItem?.setBackButtonBackgroundVerticalPositionAdjustment(20, for: .default)
	
		let backButton = UIBarButtonItem()
		backButton.title = ""
		backButton.image = UIImage()
		self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: .none)
		
		self.view.backgroundColor = Color.background
		
		let tableContainer = UIView()
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
        
        view.add().vertical(0).view(tableContainer).end(0)
		view.constrain(type: .horizontalFill, tableContainer)
        
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count + 2
	}
    var messageCell: UITableViewCell!
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return FeedCell(broadcast, 0, asHeader: true)
        }
        if indexPath.row == 1 {
            messageCell = UITableViewCell()
            let messageContainer = messageCell.contentView
            let borderBottom = UIView()
            borderBottom.backgroundColor = UIColor.clear // Color.separator
            let buttonImage = UIImage(systemName: "arrow.up.circle.fill")?.withTintColor(Color.darkBlue_white, renderingMode: .alwaysOriginal)
            sendButton = UIImageView(image: buttonImage)
            
            let messageWrap = UIView()
            messageWrap.layer.cornerRadius = 20
            messageWrap.backgroundColor = Color.backgroundDark
            messageWrap.add().horizontal(8).view(messageField).gap(0).view(sendButton, 36).end(4)
            messageWrap.add().vertical(0).view(messageField, ">=35").end(0)
            messageWrap.add().vertical(">=0").view(sendButton, 35).end(2)
            messageContainer.add().vertical(16).view(messageWrap, ">=40").end(16)
            messageContainer.constrain(type: .horizontalFill, messageWrap, margin: 16)
            messageContainer.backgroundColor = Color.background
            
            for c in messageCell.contentView.constraints where c.firstAttribute == .height {
                messageFieldHeightConstraint = c
            }
            messageContainer.debugLines()
            return messageCell
        }
        let message = messages[indexPath.row - 2]
		if(message.sender == "Kim") {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "own_message_cell", for: indexPath) as? OwnMessageCell)!
            cell.build(message)
            return cell
		}else {
            let cell = (tableView.dequeueReusableCell(withIdentifier: "message_cell", for: indexPath) as? MessageCell)!
            cell.build(message)
            return cell
		}
	}
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 1 {
//            return 72
//        }
        return UITableView.automaticDimension
    }
	
	@objc func keyboardWillShow(notification: NSNotification) {
        for c in messageCell.contentView.constraints where c.firstAttribute == .height && (c.firstItem as? UIView) == messageCell.contentView {
//            c.isActive = false
            c.priority = .defaultLow
        }
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.text == "Message here" {
			textView.text = ""
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
        for c in messageCell.contentView.constraints where c.firstAttribute == .height && (c.firstItem as? UIView) == messageCell.contentView {
            c.constant = 240
        }
//        messageCell.updateConstraints()
        messageFieldHeightConstraint.constant = min(estimatedSize.height, 116)
        let o = messageCell.frame;
        messageCell.frame = CGRect(x: o.minX, y: o.minY, width: o.width, height: estimatedSize.height + 40)
        messageCell.setNeedsLayout()
        tableView.layoutIfNeeded()
        self.messageField.superview?.layoutIfNeeded()
	}
}
