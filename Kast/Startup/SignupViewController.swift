//
//  SignupViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 13/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit


class SignupViewController: UIViewController, UITextFieldDelegate {
	
	var emailField: UITextField!
	var passwordField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Color.background
		
		self.navigationItem.title = "Sign up"
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(dismissNav))
		self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back")
		self.navigationItem.leftBarButtonItem?.tintColor = Color.navigationItem
		
		let backButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
		backButtonItem.tintColor = Color.navigationItem
		self.navigationItem.backBarButtonItem = backButtonItem
		
		let signupTitle = UILabel("Create your account", Color.formTitle, UIFont.systemFont(ofSize: 18, weight: .bold))
		let signupDesc = UILabel("Please choose your email and password for your account ", Color.formDescription, UIFont.systemFont(ofSize: 16))
		signupDesc.numberOfLines = 2
		emailField = UITextField("Email address")
		emailField.delegate = self
		emailField.textContentType = .emailAddress
		passwordField = UITextField("Password")
		passwordField.delegate = self
		passwordField.textContentType = .password
		passwordField.isSecureTextEntry = true
		let signupButton = UIButton("Sign up", font: UIFont.systemFont(ofSize: 16), image: UIImage(named: "arrow_right"))
		signupButton.rightImage()
		signupButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
		
		self.view.addSubviews(views: signupTitle, signupDesc, emailField, passwordField, signupButton)
		self.view.constrain(type: .horizontalFill, signupTitle, signupDesc, emailField, passwordField, margin: 24)
		self.view.addConstraints(format: "H:|-(>=0)-[v0(140)]-24-|", views: signupButton)
		self.view.addConstraints(format: "V:|-120-[v0(24)]-8-[v1(48)]-24-[v2(40)]-24-[v3(40)]-32-[v4(40)]-(>=0)-|", views: signupTitle, signupDesc, emailField, passwordField, signupButton)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if emailField.isFirstResponder { emailField.resignFirstResponder() }
		if passwordField.isFirstResponder { emailField.resignFirstResponder() }
	  
		return true
	}
	
	@objc func dismissNav() {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
	@objc func submit() {
		
		self.navigationController?.pushViewController(DisplayNameViewController(), animated: true)
	}
	
	
}
