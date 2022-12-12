//
//  FirstViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
	
	var textView: UITextView!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
		let tabImage = UIImage(named: "edit")
		tabImage?.withTintColor(Color.editTabLight, renderingMode: .alwaysTemplate)
		self.tabBarItem = UITabBarItem(title: "", image: tabImage, tag: 0)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		self.view.backgroundColor = Color.background

		textView = UITextView()
		textView.isEditable = true
		textView.textColor = UIColor.gray
		textView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
		textView.font = UIFont.systemFont(ofSize: 18)
		textView.backgroundColor = Color.background
		let border = UIView()
		border.backgroundColor = Color.separator
		
		let buttonContainer = UIView()
		let addButton = UIButton()
		addButton.setImage(UIImage(named: "add"), for: .normal)
		let sendButton = UIButton()
		sendButton.setImage(UIImage(named: "send"), for: .normal)
		sendButton.setTitle("Post", for: .normal)
		sendButton.setTitleColor(Color.cyan, for: .normal)
		sendButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
		sendButton.layer.borderWidth = 2
		sendButton.layer.borderColor = Color.cyan.cgColor
		sendButton.layer.cornerRadius = 9
		sendButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		sendButton.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		sendButton.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		buttonContainer.addSubviews(views: addButton, sendButton)
		buttonContainer.addConstraints(format: "H:|-(>=0)-[v0(30)]-16-[v1(80)]-0-|", views: addButton, sendButton)
		buttonContainer.addConstraints(format: "V:|-(>=0)-[v0(30)]-(>=0)-|", views: addButton)
		buttonContainer.addConstraints(format: "V:|-(>=0)-[v0(30)]-(>=0)-|", views: sendButton)
		addButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
		sendButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor).isActive = true
		
		self.view.addSubviews(views: textView, border, buttonContainer)
		self.view.addConstraints(format: "V:|-84-[v0(80)]-0-[v1(1)]-16-[v2(40)]-(>=0)-|", views: textView, border, buttonContainer)
		self.view.constrain(type: .horizontalFill, buttonContainer, textView, margin: 16)
		self.view.constrain(type: .horizontalFill, border)
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "New broadcast"
    }


}

