//
//  ClaimUsernameController.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 21/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ClaimUsernameController: ViewController, UITextFieldDelegate {
    
    var usernameField: UITextField!
    var rootView: UIView!
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.background
        
        rootView = UIView()
        self.navigationItem.hidesBackButton = false
        
        usernameField = UITextField("Username")
        usernameField.keyboardType = .alphabet
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.textContentType = .username
        usernameField.font = UIFont.systemFont(ofSize: 20)
        let descriptionLabel = UILabel("Enter a unique username", Color.lightText, UIFont.systemFont(ofSize: 14))
        descriptionLabel.numberOfLines = 2
        button = ButtonXL("Next", action: #selector(verify))
        let title = Title(text: "Claim your username")
        rootView.add().vertical(0.14 * view.frame.height).view(title).gap(64).view(usernameField, 44).gap(8).view(descriptionLabel).gap(50).view(button, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, usernameField, title, margin: 32)
        rootView.add().horizontal(32).view(descriptionLabel).end(56)
        rootView.constrain(type: .horizontalCenter, button)
        
        view.add().vertical(0).view(rootView).end(">=0")
        view.constrain(type: .horizontalFill, rootView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.usernameField.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.hideIndicator()
    }
    
    @objc func verify() {
        view.showIndicator(size: .large, color: Color.darkBlue_white)
        let controller = SuccessViewController(
            title: "Your username (@tulburg) is reserved!",
            subtitle: "We will notify you when you can login to your account"
        )
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .coverVertical
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.navigationController?.present(controller, animated: true)
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if usernameField.isFirstResponder {
            usernameField.resignFirstResponder()
        }
    }
    
    @objc func dismissNav() {
        dismiss(animated: true)
    }
}


