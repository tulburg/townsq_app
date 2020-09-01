//
//  WelcomeViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 10/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
	
	var nav: UINavigationController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = Color.background
		
		let background = UIImageView(image: UIImage(named: "background"))
		self.view.addSubview(background)
		background.contentMode = .scaleAspectFill
		background.alpha = 0.13
		self.view.addConstraints(format: "V:|-(-100)-[v0]-(-120)-|", views: background)
		self.view.addConstraints(format: "H:|-(-140)-[v0]-(-470)-|", views: background)
		
		let logo = UIImageView(image: UIImage(named: "logo"))
		logo.contentMode = .scaleAspectFit
		
		let appleButton = UIButton()
		appleButton.setImage(UIImage(named: "with_apple"), for: .normal)
		appleButton.contentMode = .scaleAspectFit
		
		let emailButton = UILabel("", Color.blueLabel, UIFont.systemFont(ofSize: 18))
		emailButton.attributedText = NSMutableAttributedString().normal("signup with ").boldUnderline("email", size: 18)
		emailButton.textAlignment = .center
		emailButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSignup)))
		emailButton.isUserInteractionEnabled = true
	  	let separatorContainer = UIView()
		separatorContainer.backgroundColor = UIColor.clear
		let separator = UIView()
		separator.backgroundColor = Color.separator
		let separatorLabel = UILabel("or", Color.darkBlue, UIFont.systemFont(ofSize: 18))
		separatorLabel.backgroundColor = Color.separatorBackground
		separatorContainer.addSubviews(views: separator, separatorLabel)
		separatorContainer.addConstraints(format: "V:|-(>=0)-[v0(1)]-(>=0)-|", views: separator)
		separatorContainer.constrain(type: .horizontalFill, separator)
		separator.centerYAnchor.constraint(equalTo: separatorContainer.centerYAnchor).isActive = true
		separatorContainer.addConstraints(format: "H:|-(>=0)-[v0(30)]-(>=0)-|", views: separatorLabel)
		separatorContainer.addConstraints(format: "V:|-(>=0)-[v0(20)]-(>=0)-|", views: separatorLabel)
		separatorLabel.centerYAnchor.constraint(equalTo: separatorContainer.centerYAnchor).isActive = true
		separatorLabel.centerXAnchor.constraint(equalTo: separatorContainer.centerXAnchor).isActive = true
		separatorLabel.textAlignment = .center
		let loginButton = UIButton("Login", font: UIFont.systemFont(ofSize: 18), image: UIImage(named: "arrow_right"))
		loginButton.rightImage()
		loginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
		loginButton.addTarget(self, action: #selector(openLogin), for: .touchUpInside)
		
		let bottomContainer = UIView()
		bottomContainer.addSubviews(views: appleButton, emailButton, separatorContainer, loginButton)
		bottomContainer.addConstraints(format: "V:|-0-[v0(44)]-(>=24,<=32)-[v1(24)]-38-[v2(24)]-38-[v3(44)]-(>=40)-|", views: appleButton, emailButton, separatorContainer, loginButton)
		
		bottomContainer.addConstraints(format: "H:|-(>=0)-[v0(>=160,<=260)]-(>=0)-|", views: appleButton)
		appleButton.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor).isActive = true
		bottomContainer.addConstraints(format: "H:|-(>=0)-[v0(160)]-(>=0)-|", views: emailButton)
		emailButton.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor).isActive = true
		bottomContainer.addConstraints(format: "H:|-(>=0)-[v0(140)]-(>=0)-|", views: separatorContainer)
		separatorContainer.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor).isActive = true
		bottomContainer.addConstraints(format: "H:|-(>=0)-[v0(130)]-(>=0)-|", views: loginButton)
		loginButton.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor).isActive = true
		
		self.view.addSubviews(views: logo, bottomContainer)
		self.view.addConstraint(NSLayoutConstraint(item: logo, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: -(self.view.frame.height / 6)))
		self.view.addConstraints(format: "H:|-(>=0)-[v0(220)]-(>=0)-|", views: logo)
		logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		self.view.constrain(type: .horizontalFill, bottomContainer)
		self.view.addConstraint(NSLayoutConstraint(item: bottomContainer, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 40))
		bottomContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		
	}
	
	@objc func openLogin() {
		self.nav = NavigationController(rootViewController: LoginViewController())
		self.nav.modalPresentationStyle = .overCurrentContext
		self.present(self.nav, animated: true, completion: nil)
	}
	
	@objc func openSignup() {
		let navigationController = NavigationController(rootViewController: SignupViewController())
		navigationController.modalPresentationStyle = .overCurrentContext
		self.present(navigationController, animated: true, completion: nil)
	}

	@objc func dismissNav() {
		self.nav.dismiss(animated: true, completion: nil)
	}
}
