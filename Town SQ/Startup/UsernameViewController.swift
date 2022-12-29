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
        self.navigationItem.title = "Username"
        
        rootView = UIView()
        
        usernameField = UITextField("Username")
        usernameField.keyboardType = .alphabet
        usernameField.autocapitalizationType = .none
        usernameField.autocorrectionType = .no
        usernameField.textContentType = .username
        usernameField.font = UIFont.systemFont(ofSize: 20)
        let descriptionLabel = UILabel("Choose your username", Color.lightText, UIFont.systemFont(ofSize: 14))
        descriptionLabel.numberOfLines = 2
        let button = ButtonXL("Next", action: #selector(save))
        
        rootView.add().vertical(0.14 * view.frame.height).view(usernameField, 44).gap(8).view(descriptionLabel).gap(50).view(button, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, usernameField, margin: 32)
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
        title = "Username"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootView.hideIndicator()
        title = ""
    }
    
    @objc func save() {
        rootView.showIndicator(size: .large, color: Color.darkBlue_white)
        if let username = usernameField.text {
            Api.main.verifyUsername(username) { data, error in
                DispatchQueue.main.async { self.rootView.hideIndicator() }
                let verifyResponse = Response<AnyObject>((data?.toDictionary())! as NSDictionary)
                print(verifyResponse)
//                if verifyResponse.code == 200 {
//
//                }
                
            }
            
//            Api.main.setProfile("username", username) { data, error in
//                DispatchQueue.main.async { self.rootView.hideIndicator() }
//                if error == nil {
//                    let response = Response<AnyObject>((data?.toDictionary())! as NSDictionary)
//                    if response.code == 200 {
//                        Progress.state = .UsernameSet
//                        DispatchQueue.main.async {
//                            let controller = DOBViewController()
//                            self.navigationController?.pushViewController(controller, animated: true)
//                        }
//                    }else {
//                        DispatchQueue.main.async { [self] in
//                            if let errorMessage = response.error {
//                                showError(errorMessage, delay: Constants.defaultMessageDelay)
//                            }
//                        }
//                    }
//                } else {
//                    print(error.debugDescription)
//                }
//            }
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

