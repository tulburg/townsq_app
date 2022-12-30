//
//  DOBViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 14/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class DOBViewController: ViewController, UITextFieldDelegate {
    
    var rootView: UIView!
    var datePicker: UIDatePicker!
    var dateField: UITextField!
    var selectedDate: Date?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.view.backgroundColor = Color.background
        
        rootView = UIView()
        let title = Title(text: "Date of birth")
        
        let descriptionLabel = UILabel("You must be older than 18 years old to use this app", Color.lightText, UIFont.systemFont(ofSize: 14))
        descriptionLabel.numberOfLines = 2
        let verifyButton = ButtonXL("Next", action: #selector(verify))
        
        dateField = UITextField("Date of birth")
        dateField.font = UIFont.systemFont(ofSize: 20)
        let nformatter = DateFormatter()
        nformatter.dateFormat = "MMMM d, YYYY"
        if let ndate = user?.date_of_birth {
            dateField.text = nformatter.string(from: ndate)
            selectedDate = ndate
        }
        
        let pickerContainer = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.38))
        pickerContainer.layer.shadowColor = UIColor.black.cgColor
        pickerContainer.layer.shadowOpacity = 0.15
        pickerContainer.layer.shadowOffset = .zero
        pickerContainer.layer.shadowRadius = 16
        pickerContainer.layer.shadowPath = UIBezierPath(rect: pickerContainer.bounds).cgPath
        pickerContainer.layer.shouldRasterize = true
        pickerContainer.layer.rasterizationScale = UIScreen.main.scale
        pickerContainer.backgroundColor = Color.background
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.barTintColor = Color.background
        toolbar.tintColor = Color.darkBlue_white
        toolbar.backgroundColor = Color.background
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissPicker)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        ], animated: false)

        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.alpha = 1
        datePicker.backgroundColor = Color.background
        datePicker.addTarget(self, action: #selector(setDate), for: .valueChanged)
        datePicker.layer.cornerRadius = 12
        datePicker.clipsToBounds = true
        datePicker.inputView?.tintColor = Color.purple
        let formatter = DateFormatter()
        formatter.dateFormat = "DD-MM-YYYY"
        if let date = user?.date_of_birth {
            datePicker.date = date
        }else {
            datePicker.date = Date(timeIntervalSinceNow: -(22 * 365 * 86400))
        }
        datePicker.minimumDate = formatter.date(from: "01-01-1920")
        datePicker.maximumDate = Date(timeIntervalSinceNow: -(18 * 365 * 86400))
        pickerContainer.add().vertical(0).view(toolbar, 44).view(datePicker).end(0)
        pickerContainer.constrain(type: .horizontalFill, datePicker, toolbar)
        dateField.inputView = pickerContainer
        
        rootView.add().vertical(0.15 * view.frame.height).view(title).gap(8).view(message).gap(64).view(dateField, 44).gap(8).view(descriptionLabel).gap(50).view(verifyButton, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, dateField, title, margin: 32)
        rootView.add().horizontal(32).view(descriptionLabel).end(56)
        rootView.constrain(type: .horizontalCenter, verifyButton)
        
        view.add().vertical(0).view(rootView).end(">=0")
        view.constrain(type: .horizontalFill, rootView)
        
//        let title = UILabel("Choose your date of birth", Color.formTitle, UIFont.systemFont(ofSize: 18, weight: .bold))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rootView.hideIndicator()
    }
    
    @objc func verify() {
        rootView.showIndicator(size: .large, color: Color.darkBlue_white)
        if let date = selectedDate {
            Api.main.setProfile("date_of_birth", dateField.text!) { data, error in
                DispatchQueue.main.async { self.rootView.hideIndicator() }
                let response = Response<AnyObject>((data?.toDictionary())! as NSDictionary)
                if response.code == 200 {
                    Progress.state = .DOBSet
                    
                    DispatchQueue.main.async {
                        DB.shared.update(.User, predicate: NSPredicate(format: "primary = %@", NSNumber(booleanLiteral: true)), keyValue: ["date_of_birth": date])
                        let controller = ProfilePhotoViewController()
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                } else if response.code == 400 {
                    DispatchQueue.main.async { [self] in
                        showError("Username is invalid, please try again", delay: Constants.defaultMessageDelay)
                    }
                } else {
                    DispatchQueue.main.async { [self] in
                        if let errorMessage = response.error {
                            showError(errorMessage, delay: Constants.defaultMessageDelay)
                        }
                    }
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if datePicker.isFirstResponder {
            datePicker.resignFirstResponder()
        }
    }
    
    @objc func dismissNav() {
        dismiss(animated: true)
    }
	
	@objc func pop() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func setDate(_ sender: UIDatePicker, value: Any) {
        selectedDate = sender.date
	}
    
    @objc func dismissPicker() {
        dateField.resignFirstResponder()
        if (selectedDate != nil) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM d, YYYY"
            dateField.text = formatter.string(from: selectedDate!)
        }
    }
}

