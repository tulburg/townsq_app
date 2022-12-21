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
    
    var fromDemo: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.background
        self.navigationItem.title = fromDemo == nil ? "Enter code" : ""
        
        rootView = UIView()
        
        let descriptionLabel = UILabel("", Color.lightText, UIFont.systemFont(ofSize: 14))
        descriptionLabel.textAlignment = .center
        descriptionLabel.attributedText = fromDemo != nil ? NSMutableAttributedString().normal("Enter your invitation code") : NSMutableAttributedString().normal("Please enter the code sent to ").bold(phoneNumber!, size: 14, weight: .bold)
        descriptionLabel.numberOfLines = 2
//        let verifyButton = ButtonXL("Verify", action: #selector(verify))
        
        let title = Title(text: fromDemo != nil ? "Invite code" : "Verification code")
        title.textAlignment = .center
        
        verificationCode = VerificationCode(6)
        verificationCode.textColor = Color.black_white
        verificationCode.delegate = self
        
        rootView.add().vertical(0.15 * view.frame.height).view(title).gap(64).view(verificationCode, 44).gap(16).view(descriptionLabel).end(">=0")
        rootView.constrain(type: .horizontalFill, descriptionLabel, title, verificationCode, margin: 32)
//        rootView.constrain(type: .horizontalCenter, verifyButton)
        
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
        view.hideIndicator()
    }
    
    @objc func verify() {
        view.showIndicator(size: .large, color: Color.darkBlue_white)
        if fromDemo != nil {
            title = ""
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let controller = SignupViewController()
//                controller.fromDemo = true
                let navigationController = NavigationController(rootViewController: controller)
                navigationController.modalPresentationStyle = .overCurrentContext
                navigationController.hideTopBar()
                self.navigationController?.present(navigationController, animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            })
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let navigationController = NavigationController(rootViewController: DisplayNameViewController())
                navigationController.modalPresentationStyle = .overCurrentContext
                self.present(navigationController, animated: true, completion: nil)
            })
        }
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
        if count == textField.numel {
            code = textField.text
            if fromDemo != nil {
                view.showIndicator(size: .large, color: Color.darkBlue_white)
                Api.main.verifyInviteCode(code) { data, error in
                    DispatchQueue.main.async { self.view.hideIndicator() }
                    if error != nil  {
                        print("Error \(error.debugDescription)")
                    }else {
                        let response = Response<AnyObject>((data?.toDictionary())! as NSDictionary)
                        print(response)
                        //                        DispatchQueue.main.async { self.verify() }
                    }
                }
            }
        }
    }
}
