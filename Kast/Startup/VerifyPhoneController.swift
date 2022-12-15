//
//  VerifyPhoneController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 14/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class VerifyPhoneController: ViewController, VerificationCodeProtocol {
    
    var phoneNumber: String?
    var verificationCode: VerificationCode!
    var code: String!
    var rootView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.background
        self.navigationItem.title = "Enter code"
        
        rootView = UIView()
        
        let descriptionLabel = UILabel("", Color.lightText, UIFont.systemFont(ofSize: 14))
        descriptionLabel.textAlignment = .center
        descriptionLabel.attributedText = NSMutableAttributedString()
            .normal("Please enter the code sent to ").bold(phoneNumber!, size: 14, weight: .bold)
        descriptionLabel.numberOfLines = 2
        let verifyButton = ButtonXL("Verify", action: #selector(verify))
        
        verificationCode = VerificationCode(6)
        
        rootView.add().vertical(0.14 * view.frame.height).view(verificationCode, 44).gap(16).view(descriptionLabel).gap(50).view(verifyButton, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, descriptionLabel, verificationCode, margin: 32)
        rootView.constrain(type: .horizontalCenter, verifyButton)
        
        view.add().vertical(0).view(rootView).end(">=0")
        view.constrain(type: .horizontalFill, rootView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.verificationCode.becomeFirstResponder()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootView.hideIndicator()
    }
    
    @objc func verify() {
        rootView.showIndicator(size: 56, color: Color.darkBlue_white)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            let navigationController = NavigationController(rootViewController: DisplayNameViewController())
            navigationController.modalPresentationStyle = .overCurrentContext
            self.present(navigationController, animated: true, completion: nil)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if verificationCode.isFirstResponder {
            verificationCode.resignFirstResponder()
        }
    }
    
    @objc func dismissNav() {
        dismiss(animated: true)
    }
    
    func textFieldValueChanged(_ textField: VerificationCode) {
        guard let count = textField.text?.count, count != 0 else {
            textField.resignFirstResponder()
            return
        }
        if count < textField.numel {
            print("Error !")
        } else {
            code = textField.text
        }
    }
}
