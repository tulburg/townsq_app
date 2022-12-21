//
//  LoginViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 13/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
	
	var emailInput: UITextField!
	var passwordInput: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.navigationItem.title = "Login"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(dismissNav))
		self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back")
		self.navigationItem.leftBarButtonItem?.tintColor = Color.navigationItem
		
		let backButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
		backButtonItem.tintColor = Color.navigationItem
		self.navigationItem.backBarButtonItem = backButtonItem
		
		
		let loginLabel = UILabel("Enter your account details", Color.formTitle, UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold))
		let loginDesc = UILabel("Please enter the email and password for your account", Color.formDescription, UIFont.systemFont(ofSize: 16))
		loginDesc.numberOfLines = 2
		self.emailInput = UITextField("Email address")
		emailInput.textContentType = .emailAddress
		emailInput.delegate = self
		self.passwordInput = UITextField("Password")
		passwordInput.textContentType = .password
		passwordInput.isSecureTextEntry = true
		passwordInput.delegate = self
		let button = UIButton("Login", font: UIFont.systemFont(ofSize: 16), image: UIImage(named: "arrow_right"))
		button.rightImage()
		
		self.view.backgroundColor = Color.background
		self.view.addSubviews(views: loginLabel, loginDesc, emailInput, passwordInput, button)
		self.view.constrain(type: .horizontalFill, loginLabel, loginDesc, emailInput, passwordInput, margin: 24)
		self.view.addConstraints(format: "V:|-120-[v0(24)]-8-[v1(48)]-24-[v2(40)]-24-[v3(40)]-32-[v4(40)]-(>=0)-|", views: loginLabel, loginDesc, emailInput, passwordInput, button)
		self.view.addConstraints(format: "H:|-(>=0)-[v0(120)]-24-|", views: button)
		
		
		

	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if self.emailInput.isFirstResponder  {
			self.emailInput.resignFirstResponder()
		}
		if self.passwordInput.isFirstResponder {
			self.passwordInput.resignFirstResponder()
		}
		return true
	}
	
	@objc func dismissNav() {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
}
