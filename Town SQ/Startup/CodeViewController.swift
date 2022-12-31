//
//  VerifyPhoneController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 14/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class CodeViewController: ViewController, VerificationCodeProtocol {
    
    var phoneNumber: String?
    var verificationCode: VerificationCode!
    var code: String!
    var rootView: UIView!
    
    var fromDemo: Bool?
    var fromInvite: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Color.background
        self.navigationItem.title = fromDemo == nil ? "Enter code" : ""
        
        rootView = UIView()
        
//        let descriptionLabel = UILabel("", Color.lightText, UIFont.systemFont(ofSize: 14))
//        descriptionLabel.textAlignment = .center
        message.attributedText = fromDemo != nil ? NSMutableAttributedString().normal("Enter your invitation code") : NSMutableAttributedString().normal("Please enter the code sent to ").bold(phoneNumber!, size: 14, weight: .bold)
        message.numberOfLines = 2
        message.isHidden = false
        message.textAlignment = .center
//        let verifyButton = ButtonXL("Verify", action: #selector(verify))
        
        let title = Title(text: fromDemo != nil ? "Invite code" : "Verification code")
        title.textAlignment = .center
        
        verificationCode = VerificationCode(6)
        verificationCode.textColor = Color.black_white
        verificationCode.delegate = self
        
        rootView.add().vertical(0.15 * view.frame.height).view(title).gap(64).view(verificationCode, 44).gap(16).view(message).end(">=0")
        rootView.constrain(type: .horizontalFill, message, title, verificationCode, margin: 32)
//        rootView.constrain(type: .horizontalCenter, verifyButton)
        
        view.add().vertical(0).view(rootView).end(">=0")
        view.constrain(type: .horizontalFill, rootView)
        
        print(DB.shared.find(.User, predicate: nil))
        
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
        navigationController?.dismiss(animated: true)
        if path == .ClaimUsername {
//            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func textFieldValueChanged(_ textField: VerificationCode) {
        guard let count = textField.text?.count, count != 0 else {
            textField.resignFirstResponder()
            return
        }
        if count == textField.numel {
            code = textField.text
            if path == .InviteCode {
                view.showIndicator(size: .large, color: Color.darkBlue_white)
                Api.main.verifyInviteCode(code) { data, error in
                    DispatchQueue.main.async { self.view.hideIndicator() }
                    if error != nil {
                        print(error as Any)
                    }else {
                        let response = Response<AnyObject>((data?.toDictionary())! as NSDictionary)
                        if response.code == 200 {
                            Progress.state = .InviteCodeVerified
                            DispatchQueue.main.async { [self] in
                                UserDefaults.standard.set(code, forKey: Constants.inviteCode)
                                let controller = SignupViewController()
                                controller.path = .InviteCode
                                let navigationController = NavigationController(rootViewController: controller)
                                navigationController.modalPresentationStyle = .overCurrentContext
                                navigationController.hideTopBar()
                                self.navigationController?.dismiss(animated: false)
                                self.present(navigationController, animated: true)
                            }
                        }else {
                            print(response)
                            if response.code == 403 {
                                if let errorMessage = response.error {
                                    DispatchQueue.main.async {
                                        self.showError(errorMessage, delay: Constants.defaultMessageDelay)
                                    }
                                }else {
                                    print(response)
                                }
                            }
                        }
                    }
                }
            }else if path == .ClaimUsername {
                view.showIndicator(size: .large, color: Color.darkBlue_white)
                Api.main.verifyCode(code, phoneNumber!, nil) { data, error in
                    DispatchQueue.main.async { self.view.hideIndicator() }
                    if error != nil  {
                        print("Error \(error.debugDescription)")
                    }else {
                        let response = Response<AnyObject>((data?.toDictionary())! as NSDictionary)
                        if response.code == 200 {
                            DispatchQueue.main.async {
                                let controller = ClaimUsernameController()
                                let navigationController = NavigationController(rootViewController: controller)
                                navigationController.modalPresentationStyle = .overCurrentContext
                                navigationController.hideTopBar()
                                controller.root = self
                                controller.path = .ClaimUsername
                                self.navigationController?.popToRootViewController(animated: false)
                                self.present(navigationController, animated: true)
                            }
                        }else {
                            if response.code == 403 {
                                if let errorMessage = response.error {
                                    self.showError(errorMessage, delay: Constants.defaultMessageDelay)
                                }else {
                                    print(response)
                                }
                            }
                        }
                    }
                }
            } else {
                view.showIndicator(size: .large, color: Color.darkBlue_white)
                let inviteCode = UserDefaults.standard.string(forKey: Constants.inviteCode)
                Api.main.verifyCode(code, phoneNumber!, inviteCode) { data, error in
                    DispatchQueue.main.async { self.view.hideIndicator() }
                    if error != nil  {
                        print("Error \(error.debugDescription)")
                    }else {
                        let response = Response<AnyObject>((data?.toDictionary())! as NSDictionary)
                        if response.code == 200 {
                            Progress.state = .PhoneVerified
                            DB.shared.insert(.User, keyValue: ["phone": self.phoneNumber as Any, "primary": true])
                            UserDefaults.standard.set(response.data as! String, forKey: Constants.authToken)
                            DispatchQueue.main.async {
                                let controller = DisplayNameViewController()
                                let navigationController = NavigationController(rootViewController: controller)
                                navigationController.modalPresentationStyle = .overCurrentContext
                                navigationController.hideTopBar()
                                self.present(navigationController, animated: true)
                            }
                        }else {
                            if response.code == 403 {
                                DispatchQueue.main.async {
                                    if let errorMessage = response.error {
                                        self.showError(errorMessage, delay: Constants.defaultMessageDelay)
                                    }else {
                                        print(response)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
