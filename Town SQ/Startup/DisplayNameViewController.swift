//
//  DisplayNameViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 14/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class DisplayNameViewController: ViewController, UITextFieldDelegate {
	
	var nameField: UITextField!
    var rootView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.view.backgroundColor = Color.background
        self.navigationItem.title = "Display name"
        
        rootView = UIView()
        
        nameField = UITextField("Display name")
        nameField.textContentType = .name
        nameField.font = UIFont.systemFont(ofSize: 20)
        let descriptionLabel = UILabel("Choose a name that will be displayed on your account", Color.lightText, UIFont.systemFont(ofSize: 14))
        descriptionLabel.numberOfLines = 2
        let verifyButton = ButtonXL("Next", action: #selector(save))
        
        rootView.add().vertical(0.14 * view.frame.height).view(nameField, 44).gap(8).view(descriptionLabel).gap(50).view(verifyButton, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, nameField, margin: 32)
        rootView.add().horizontal(32).view(descriptionLabel).end(56)
        rootView.constrain(type: .horizontalCenter, verifyButton)
        
        view.add().vertical(0).view(rootView).end(">=0")
        view.constrain(type: .horizontalFill, rootView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.nameField.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Display name"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootView.hideIndicator()
        title = ""
    }
    
    @objc func save() {
        rootView.showIndicator(size: .large, color: Color.darkBlue_white)
        if let name = nameField.text {
            Api.main.setProfile("name", name) { data, error in
                DispatchQueue.main.async { self.rootView.hideIndicator() }
                if error == nil {
                    let response = Response<AnyObject>((data?.toDictionary())! as NSDictionary)
                    if response.code == 200 {
                        Progress.state = .DisplayNameSet
                        DispatchQueue.main.async {
                            let controller = UsernameViewController()
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                    }else {
                        DispatchQueue.main.async { [self] in
                            if let errorMessage = response.error {
                                showError(errorMessage, delay: Constants.defaultMessageDelay)
                            }
                        }
                    }
                } else {
                    print(error.debugDescription)
                }
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if nameField.isFirstResponder {
            nameField.resignFirstResponder()
        }
    }
    
    @objc func dismissNav() {
        dismiss(animated: true)
    }
}
