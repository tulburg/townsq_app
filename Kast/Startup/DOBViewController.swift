//
//  DOBViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 14/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class DOBViewController: UIViewController, UITextFieldDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Color.background
		self.navigationItem.title = "Date of birth"
		let backButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
		backButtonItem.tintColor = Color.navigationItem
		self.navigationItem.backBarButtonItem = backButtonItem
		
		
		let title = UILabel("Choose your date of birth", Color.formTitle, UIFont.systemFont(ofSize: 18, weight: .bold))
		let description = UILabel("Please choose your date of birth to confirm you are older than 13", Color.formDescription, UIFont.systemFont(ofSize: 16))
		description.numberOfLines = 2
		
		let datePicker = UIDatePicker()
		datePicker.datePickerMode = .date
		datePicker.preferredDatePickerStyle = .automatic
		datePicker.alpha = 1
		datePicker.backgroundColor = Color.formInput
		datePicker.locale = Locale(identifier: "FR")
		datePicker.addTarget(self, action: #selector(setDate), for: .valueChanged)
		datePicker.layer.cornerRadius = 12
		datePicker.clipsToBounds = true
		datePicker.inputView?.tintColor = Color.purple
		let formatter = DateFormatter()
		formatter.dateFormat = "DD-MM-YYYY"
		datePicker.minimumDate = formatter.date(from: "01-01-1920")
		datePicker.maximumDate = Date(timeIntervalSinceNow: -(14 * 365 * 86400))
			
		let button = UIButton("Next", font: UIFont.systemFont(ofSize: 16), image: UIImage(named: "arrow_right"))
		button.rightImage()
		button.addTarget(self, action: #selector(openPhoto), for: .touchUpInside)
		self.view.addSubviews(views: title, description, datePicker, button)
		self.view.constrain(type: .horizontalFill, title, description, datePicker, margin: 24)
		self.view.addConstraints(format: "H:|-(>=0)-[v0(120)]-24-|", views: button)
		self.view.addConstraints(format: "V:|-120-[v0(24)]-8-[v1(48)]-24-[v2(40)]-32-[v3(40)]-(>=0)-|", views: title, description, datePicker, button)
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
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

