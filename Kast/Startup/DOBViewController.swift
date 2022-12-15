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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
        self.view.backgroundColor = Color.background
        self.navigationItem.title = "Display name"
        
        rootView = UIView()
        
        let descriptionLabel = UILabel("You must be older than 18 years old to use this app", Color.lightText, UIFont.systemFont(ofSize: 14))
        descriptionLabel.numberOfLines = 2
        let verifyButton = ButtonXL("Next", action: #selector(verify))
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .automatic
        datePicker.alpha = 1
        datePicker.backgroundColor = Color.formInput
        datePicker.locale = Locale(identifier: "EN")
        datePicker.addTarget(self, action: #selector(setDate), for: .valueChanged)
        datePicker.layer.cornerRadius = 12
        datePicker.clipsToBounds = true
        datePicker.inputView?.tintColor = Color.purple
        let formatter = DateFormatter()
        formatter.dateFormat = "DD-MM-YYYY"
        datePicker.minimumDate = formatter.date(from: "01-01-1920")
        datePicker.maximumDate = Date(timeIntervalSinceNow: -(14 * 365 * 86400))
        
        rootView.add().vertical(0.14 * view.frame.height).view(datePicker, 44).gap(8).view(descriptionLabel).gap(50).view(verifyButton, 44).end(">=0")
        rootView.constrain(type: .horizontalFill, datePicker, margin: 32)
        rootView.add().horizontal(32).view(descriptionLabel).end(56)
        rootView.constrain(type: .horizontalCenter, verifyButton)
        
        view.add().vertical(0).view(rootView).end(">=0")
        view.constrain(type: .horizontalFill, rootView)
        
        let title = UILabel("Choose your date of birth", Color.formTitle, UIFont.systemFont(ofSize: 18, weight: .bold))
        
        
        
        
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
		print(sender.date)
	}
	
	@objc func openPhoto() {
		self.navigationController?.pushViewController(ProfilePhotoViewController(), animated: true)
	}
}

