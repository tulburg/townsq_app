//
//  WelcomeViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 10/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class WelcomeViewController: ViewController {
	
	var nav: UINavigationController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = Color.background
		
		let background = UIImageView(image: UIImage(named: "bckg"))
		self.view.addSubview(background)
		background.contentMode = .scaleAspectFit
        view.constrain(type: .verticalFill, background)
        view.constrain(type: .horizontalFill, background)
		
		let logo = UIImageView(image: UIImage(named: "logo"))
		logo.contentMode = .scaleAspectFit
        let title = UIImageView(image: UIImage(named: "name"))
        title.contentMode = .scaleAspectFit
        
        let logoContainer = UIView()
        logoContainer.addSubviews(views: logo, title)
        logoContainer.addConstraints(format: "V:|-0-[v0]-(-24)-[v1]-(>=0)-|", views: logo, title)
        logoContainer.constrain(type: .horizontalCenter, logo, title)
        
        let createButton = ButtonXL("Create new account", action: #selector(openSignup))
        let loginButton = ClearButton("Login", action: #selector(openLogin))
        
        let buttonContainer = UIView()
        buttonContainer.addSubviews(views: createButton, loginButton)
        buttonContainer.constrain(type: .horizontalCenter, createButton, loginButton)
        buttonContainer.addConstraints(format: "V:|-0-[v0(44)]-16-[v1]-0-|", views: createButton, loginButton)
        
        let wrap = UIView()
        wrap.add().vertical(0).view(logoContainer).gap(40).view(buttonContainer).end(0.12 * view.frame.height)
        wrap.constrain(type: .horizontalCenter, logoContainer, buttonContainer)
        
        view.addSubviews(views: wrap)
        view.constrain(type: .horizontalCenter, wrap)
        view.addConstraints(format: "V:|-(\(0.25 * view.frame.height))-[v0]-0-|", views: wrap)
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
