//
//  DisplayNameViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 14/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class DisplayNameViewController: UIViewController, UITextFieldDelegate {
	
	var nameField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Color.background
		self.navigationItem.title = "Display name"
		
		let backButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
		backButtonItem.tintColor = Color.navigationItem
		self.navigationItem.backBarButtonItem = backButtonItem
		
		self.navigationItem.leftBarButtonItem?.tintColor = Color.navigationItem
		
		let title = UILabel("Choose your account name", Color.formTitle, UIFont.systemFont(ofSize: 18, weight: .bold))
		let description = UILabel("Please choose a name that will be displayed on your account", Color.formDescription, UIFont.systemFont(ofSize: 16))
		description.numberOfLines = 2
		nameField = UITextField("Display name")
		nameField.delegate = self
		nameField.textContentType = .name
		let button = UIButton("Next", font: UIFont.systemFont(ofSize: 16), image: UIImage(named: "arrow_right"))
		button.rightImage()
		button.addTarget(self, action: #selector(submit), for: .touchUpInside)
		self.view.addSubviews(views: title, description, nameField, button)
		self.view.constrain(type: .horizontalFill, title, description, nameField, margin: 24)
		self.view.addConstraints(format: "H:|-(>=0)-[v0(120)]-24-|", views: button)
		self.view.addConstraints(format: "V:|-120-[v0(24)]-8-[v1(48)]-24-[v2(40)]-32-[v3(40)]-(>=0)-|", views: title, description, nameField, button)
	
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if nameField.isFirstResponder { nameField.resignFirstResponder() }
		return true
	}
	
	@objc func pop() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func submit() {
		self.navigationController?.pushViewController(DOBViewController(), animated: true)
	}
}
