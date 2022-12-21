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
    var phoneValue = "1"
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
        phone = UITextField("Phone number")
        phone.keyboardType = .numberPad
        phone.font = UIFont.systemFont(ofSize: 20)
        country.add().horizontal(8).view(countryCode).gap(2).view(chevron, 16).end(8)
        country.constrain(type: .verticalFill, countryCode, chevron)
        phone.leftView = country
        let disclaimerLabel = UILabel("By entering your number, you're agreeing to your Terms of Service and Privacy Policy.", Color.lightText, UIFont.systemFont(ofSize: 12))
        disclaimerLabel.numberOfLines = 3
        let continueButton = ButtonXL("Continue", action: #selector(verifyPhone))
        
        rootView.add().vertical(0.15 * view.frame.height).view(title).gap(64).view(phone, 44).gap(8).view(disclaimerLabel).gap(50).view(continueButton, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, phone, disclaimerLabel, title, margin: 32)
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
        if fromDemo != nil {
            let controller = VerifyPhoneController()
            controller.fromDemo = true
            if let text = self.phone.text {
                controller.phoneNumber = self.phoneValue + text
                title = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    self.navigationController?.pushViewController(controller, animated: true)
                })
            }
        }else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                let controller = VerifyPhoneController();
                if let text = self.phone.text {
                    controller.phoneNumber = self.phoneValue + text
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            })
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
