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
        let descriptionLabel = UILabel("Choose a name that will be displayed on your account", Color.lightText, UIFont.systemFont(ofSize: 14))
        descriptionLabel.numberOfLines = 2
        let verifyButton = ButtonXL("Next", action: #selector(verify))
        
        rootView.add().vertical(0.14 * view.frame.height).view(nameField, 44).gap(8).view(descriptionLabel).gap(50).view(verifyButton, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, nameField, margin: 32)
        rootView.add().horizontal(32).view(descriptionLabel).end(56)
        rootView.constrain(type: .horizontalCenter, verifyButton)
        
        view.add().vertical(0).view(rootView).end(">=0")
        view.constrain(type: .horizontalFill, rootView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootView.hideIndicator()
    }
    
    @objc func verify() {
        rootView.showIndicator(size: 56, color: Color.darkBlue_white)
        let controller = DOBViewController()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.navigationController?.pushViewController(controller, animated: true)
        })
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
