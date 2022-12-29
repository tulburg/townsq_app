//
//  DemoWelcomeController.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 21/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class DemoWelcomeController: ViewController {
    
    var nav: NavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Color.create(0xFFFFFF, dark: 0x303030)
        
        let background = UIImageView(image: UIImage(named: "bckg"))
        self.view.addSubview(background)
        background.contentMode = .scaleAspectFit
        view.constrain(type: .verticalFill, background)
        view.constrain(type: .horizontalFill, background)
        
        let logo = UIImageView(image: UIImage(named: "logo"))
        logo.contentMode = .scaleAspectFit
        let title = UIImageView(image: UIImage(named: "name")?.withTintColor(Color.darkBlue_white, renderingMode: .alwaysOriginal))
        title.contentMode = .scaleAspectFit
        
        let logoContainer = UIView()
        logoContainer.addSubviews(views: logo, title)
        logoContainer.addConstraints(format: "V:|-0-[v0]-(-24)-[v1]-(>=0)-|", views: logo, title)
        logoContainer.constrain(type: .horizontalCenter, logo, title)
        
        let createButton = ButtonXL("Claim your username", action: #selector(claimUsername))
        let loginButton = ClearButton("I have invite code", action: #selector(useInviteCode))
        
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
    
    @objc func useInviteCode() {
        dismiss(animated: true)
        let controller = CodeViewController()
        controller.fromDemo = true
        controller.path = .InviteCode
        title = ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func claimUsername() {
        dismiss(animated: true)
        let controller = SignupViewController()
        controller.fromDemo = true
        controller.path = .ClaimUsername
        title = ""
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func dismissNav() {
        self.nav.dismiss(animated: true, completion: nil)
    }
}

