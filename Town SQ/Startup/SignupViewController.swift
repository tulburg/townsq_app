//
//  SignupViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 13/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit


class SignupViewController: ViewController, UITextFieldDelegate, CountryPickerDelegate {
	
    var countryCode: UILabel!
    var country: UIView!
    var phone: UITextField!
    var phoneValue = "+1"
    var rootView: UIView!
    
    var fromDemo: Bool?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Color.background
        self.navigationItem.hidesBackButton = false
//		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: #selector(dismissNav))
//		self.navigationItem.leftBarButtonItem?.image = UIImage(named: "back")
//		self.navigationItem.leftBarButtonItem?.tintColor = Color.navigationItem
        
        rootView = UIView()
		
		country = UIView()
        country.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseCountry)))
        let chevron = UIImageView(image: UIImage(systemName: "chevron.down")?.withTintColor(Color.lightText).resize(CGSize(width: 16, height: 8)))
        chevron.contentMode = .center
        let title = Title(text: "Enter your phone number")
        countryCode = UILabel("🇺🇸 +1", Color.textDark, UIFont.systemFont(ofSize: 20))
        if let countryNumber = UserDefaults.standard.string(forKey: Constants.verificationCountry) {
            countryCode.text = countryNumber
            phoneValue = countryNumber
        }
        phone = UITextField("Phone number")
        phone.keyboardType = .numberPad
        phone.font = UIFont.systemFont(ofSize: 20)
        if let phoneNumber = UserDefaults.standard.string(forKey: Constants.verificationPhone) {
            phone.text = phoneNumber
        }
        country.add().horizontal(8).view(countryCode).gap(2).view(chevron, 16).end(8)
        country.constrain(type: .verticalFill, countryCode, chevron)
        phone.leftView = country
        let disclaimerLabel = UILabel("By entering your number, you're agreeing to your Terms of Service and Privacy Policy.", Color.lightText, UIFont.systemFont(ofSize: 12))
        disclaimerLabel.numberOfLines = 3
        let continueButton = ButtonXL("Continue", action: #selector(verifyPhone))
        
        rootView.add().vertical(0.15 * view.frame.height).view(title).gap(8).view(message).gap(64).view(phone, 44).gap(8).view(disclaimerLabel).gap(50).view(continueButton, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, phone, disclaimerLabel, title, message, margin: 32)
        rootView.constrain(type: .horizontalCenter, continueButton)
        
        view.add().vertical(0).view(rootView).end(">=0")
        view.constrain(type: .horizontalFill, rootView)
	}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = fromDemo != nil ? "Sign Up" : ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootView.hideIndicator()
    }
    
    @objc func chooseCountry() {
        let countryPicker = CountryPickerViewController()
        countryPicker.selectedCountry = "US"
        countryPicker.delegate = self
        self.present(countryPicker, animated: true)
        DispatchQueue.main.async {
            countryPicker.searchTextField.becomeFirstResponder()
        }
    }
    
    func countryPicker(didSelect country: Country) {
        countryCode.text = country.isoCode.getFlag() + " +" + country.phoneCode
        phoneValue = "+" + country.phoneCode
        DispatchQueue.main.async {
            self.phone.layoutSubviews()
            self.phone.becomeFirstResponder()
        }
    }
    
    
    @objc func verifyPhone() {
        view.showIndicator(size: .large, color: Color.darkBlue_white)
        if path == .ClaimUsername {
            let controller = CodeViewController()
            controller.fromDemo = true
            controller.path = .ClaimUsername
            if let text = self.phone.text {
                controller.phoneNumber = self.phoneValue + text
                title = ""
                Api.main.verifyPhone(controller.phoneNumber!) { data, error in
                    DispatchQueue.main.async {
                        self.view.hideIndicator()
                    }
                    if error == nil {
                        let response = Response<DataType.None>((data?.toDictionary())! as NSDictionary)
                        if response.code == 200 {
                            DispatchQueue.main.async {
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
        }else if path == .InviteCode {
            // Actuall sign up path
            if let text = self.phone.text {
                let phone = self.phoneValue + text
                Api.main.verifyPhone(phone, completion: { data, error in
                    DispatchQueue.main.async { self.view.hideIndicator() }
                    if error == nil {
                        let response = Response<DataType.None>((data?.toDictionary())! as NSDictionary)
                        if response.code == 200 {
                            Progress.state = .PhoneCodeSent
                            DispatchQueue.main.async {
                                let controller = CodeViewController();
                                if let text = self.phone.text {
                                    controller.phoneNumber = self.phoneValue + text
                                    UserDefaults.standard.set(text, forKey: Constants.verificationPhone)
                                    UserDefaults.standard.set(self.phoneValue, forKey: Constants.verificationCountry)
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }
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
                })
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if phone.isFirstResponder {
            phone.resignFirstResponder()
        }
    }
	
	@objc func dismissNav() {
		self.navigationController?.dismiss(animated: true, completion: nil)
	}
	
	
}
