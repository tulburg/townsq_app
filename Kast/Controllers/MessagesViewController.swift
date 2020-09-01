//
//  MessagesViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit
import NotificationCenter

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
	
	var tableView: UITableView!
	var messageField: UITextView!
	var messages: [Message] = []
	var titleContainer: UIView!
	
	var messageContainerTopConstraint: NSLayoutConstraint!
	var titleContainerHeightConstraint: NSLayoutConstraint!
	var messageFieldHeightConstraint: NSLayoutConstraint!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let text = "[{\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been going around about a guy that claims to have found big foot in his backyard.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Simone biles\", \"body\": \"There’s this story that has been.\"}, {\"id\": \"Something\", \"date\": \"12-01-2020\", \"sender\": \"Kim\", \"body\": \"There’s this story that has been. For some, somethings will never change\"}]"
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
		
		titleContainer = setupTitle(title: "There's this story that has been. For some, somethings will never change")
		self.view.addSubview(titleContainer)
		self.view.constrain(type: .horizontalFill, titleContainer)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: .none)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: .none)
		
		self.view.backgroundColor = Color.background
		
		let tableContainer = UIView()
		tableContainer.backgroundColor = Color.darkBlue
		
		tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		tableView.separatorStyle = .none
		tableView.backgroundColor = Color.background
		tableView.keyboardDismissMode = .onDrag
		
		messageField = UITextView()
		messageField.text = "Message here"
		messageField.translatesAutoresizingMaskIntoConstraints = true
		messageField.sizeToFit()
		messageField.isScrollEnabled = false
		messageField.layer.borderWidth = 2
		messageField.layer.borderColor = Color.purple.cgColor
		messageField.textColor = Color.textDark
		messageField.font = UIFont.systemFont(ofSize: 18)
		messageField.delegate = self
		
		tableContainer.addSubview(tableView)
		tableContainer.constrain(type: .horizontalFill, tableView)
		tableContainer.addConstraints(format: "V:|-0-[v0]-0-|", views: tableView)
			
		self.view.addSubviews(views: tableContainer)
		self.view.constrain(type: .horizontalFill, tableContainer)
		self.view.addConstraints(format: "H:|-0-[v0(\(self.view.frame.width))]-0-|", views: titleContainer)
		self.view.addConstraints(format: "V:|-0-[v0(120)]-0-[v1]-0-|", views: titleContainer, tableContainer)
		

		let messageContainer = UIView()
		messageContainer.backgroundColor = Color.background
		let borderBottom = UIView()
		borderBottom.backgroundColor = UIColor.clear // Color.separator
		messageContainer.addSubviews(views: messageField, borderBottom)
		messageContainer.addConstraints(format: "V:|-0-[v0(>=40)]-8-[v1(1)]-1-|", views: messageField, borderBottom)
		messageContainer.constrain(type: .horizontalFill, messageField, margin: 16)
		messageContainer.constrain(type: .horizontalFill, borderBottom)
		messageContainer.backgroundColor = Color.background
		self.view.addSubview(messageContainer)
		self.view.constrain(type: .horizontalFill, messageContainer)
		self.view.addConstraints(format: "V:|-(>=0)-[v0(>=50)]-44-|", views: messageContainer)
//		messageContainer.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
		
		for c in self.view.constraints where c.firstAttribute == .bottom && c.secondItem as? UIView == messageContainer {
			messageContainerTopConstraint = c
		}
		for c in self.view.constraints where c.firstItem as? UIView == titleContainer && c.firstAttribute == .height {
			titleContainerHeightConstraint = c
		}
		for c in messageContainer.constraints where c.firstAttribute == .height && c.firstItem as? UIView == messageField {
			messageFieldHeightConstraint = c
		}
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		self.navigationController?.presentTransparentNavigationBar()
		let appearance = UINavigationBarAppearance()
		appearance.configureWithTransparentBackground()
		appearance.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
		appearance.backgroundImage = UIImage()
		appearance.shadowImage = UIImage()
		self.navigationController?.navigationBar.standardAppearance = appearance
		self.navigationController?.navigationBar.compactAppearance = appearance
		self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
		self.navigationController?.navigationBar.isTranslucent = true
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.changeBackgroundColor(Color.background)
	}
	
	func setupTitle(title: String) -> UIView {
		let container = UIView()
		container.backgroundColor = Color.darkBlue
		let imageView = UIImageView()
		imageView.image = UIImage(named: "bar")?.resize(CGSize(width: self.view.frame.width, height: 3))
		imageView.contentMode = .scaleToFill
		container.addSubview(imageView)
		container.addConstraints(format: "V:|-(>=0)-[v0(3)]-0-|", views: imageView)
		container.constrain(type: .horizontalFill, imageView)
		
		let textContainer = UIView()
		let title = UILabel(title, UIColor.white, UIFont.boldSystemFont(ofSize: 18))
		title.numberOfLines = 5
		let expoButton = UIButton()
		expoButton.setImage(UIImage(named: "back"), for: .normal)
		expoButton.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.32)
		expoButton.layer.cornerRadius = 12
		expoButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) * 1.5)
		textContainer.addSubviews(views: title)
		textContainer.addConstraints(format: "V:|-8-[v0(>=16)]-(>=0)-|", views: title)
		textContainer.constrain(type: .horizontalFill, title)
		
		container.addSubviews(views: textContainer, expoButton)
		container.addConstraints(format: "H:|-40-[v0]-8-[v1(40)]-16-|", views: textContainer, expoButton)
		container.addConstraints(format: "V:|-44-[v0(>=50)]-0-|", views: textContainer)
		container.addConstraints(format: "V:|-52-[v0(40)]-(>=0)-|", views: expoButton)
		return container
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return messages.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = UITableViewCell()
		let message = messages[indexPath.row]
		if(message.sender == "Kim") {
			cell = OwnMessageCell(message)
		}else {
			cell = MessageCell(message)
		}
		return cell
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		if let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
			if messageContainerTopConstraint != nil {
				messageContainerTopConstraint.constant = (kFrame.height)
			}
			UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
				self.view.layoutIfNeeded()
			}, completion: { _ in
				self.tableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
			})
		}
		
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		if messageContainerTopConstraint != nil {
			messageContainerTopConstraint.constant = 44
		}
		UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.text = ""
	}
	
	func textViewDidChange(_ textView: UITextView) {
		let fixedWidth = textView.frame.size.width
		textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
		let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//		var newFrame = textView.frame
//		newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		messageFieldHeightConstraint.constant = newSize.height
		UIView.animate(withDuration: 0.2, animations: {
			self.messageField.superview?.layoutIfNeeded()
		})
	}
}
