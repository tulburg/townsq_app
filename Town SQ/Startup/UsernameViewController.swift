//
//  UsernameViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 15/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class UsernameViewController: ViewController, UITextFieldDelegate {
    
    var usernameField: UITextField!
    var rootView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.background
        
        rootView = UIView()
        
        let title = Title(text: "Username")
        
        usernameField = UITextField("Username")
        usernameField.keyboardType = .alphabet
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.textContentType = .username
        usernameField.font = UIFont.systemFont(ofSize: 20)
        usernameField.text = user?.username
        let descriptionLabel = UILabel("Choose your username", Color.lightText, UIFont.systemFont(ofSize: 14))
        descriptionLabel.numberOfLines = 2
        let button = ButtonXL("Next", action: #selector(save))
        
        rootView.add().vertical(0.15 * view.frame.height).view(title).gap(8).view(message).gap(64).view(usernameField, 44).gap(8).view(descriptionLabel).gap(50).view(button, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, usernameField, title, message, margin: 32)
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
        rootView.hideIndicator()
    }
    
    @objc func save() {
        rootView.showIndicator(size: .large, color: Color.darkBlue_white)
        if let username = usernameField.text {
            Api.main.verifyUsername(username) { data, error in
                DispatchQueue.main.async { self.rootView.hideIndicator() }
                let verifyResponse = Response<DataType.None>((data?.toDictionary())! as NSDictionary)
                if verifyResponse.code == 200 {
                    Progress.state = .UsernameSet
                    DispatchQueue.main.async {
                        DB.shared.update(.User, predicate: NSPredicate(format: "primary = %@", NSNumber(booleanLiteral:  true)), keyValue: ["username": username])
                        let controller = DOBViewController()
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                } else if verifyResponse.code == 400 {
                    DispatchQueue.main.async { [self] in
                        showError("Username is invalid, please try again", delay: Constants.defaultMessageDelay)
                    }
                } else {
                    DispatchQueue.main.async { [self] in
                        if let errorMessage = verifyResponse.error {
                            showError(errorMessage, delay: Constants.defaultMessageDelay)
                        }
                    }
                }
            }
        }
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

