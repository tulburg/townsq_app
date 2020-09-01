//
//  ProfilePhotoViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 17/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ProfilePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	var button: UIButton!
	var imagePicker: UIImagePickerController!
	var photo: UIImageView!
	
	var delegate: UISceneDelegate!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Color.background
		self.navigationItem.title = "Profile photo"
		let backButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
		backButtonItem.tintColor = Color.navigationItem
		self.navigationItem.backBarButtonItem = backButtonItem
		
		delegate = UIApplication.shared.delegate as? UISceneDelegate
		
		
		let title = UILabel("Choose your profile photo", Color.formTitle, UIFont.systemFont(ofSize: 18, weight: .bold))
		let description = UILabel("Please select the photo to be displayed on your profile", Color.formDescription, UIFont.systemFont(ofSize: 16))
		description.numberOfLines = 2
		
		photo = UIImageView()
		photo.image = UIImage(named: "profile_background")
		photo.contentMode = .scaleAspectFill
		photo.isUserInteractionEnabled = true
		photo.layer.cornerRadius = 15
		photo.clipsToBounds = true
		photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
		
		let chooseButton = UIButton("Choose", font: UIFont.boldSystemFont(ofSize: 18), image: UIImage())
		chooseButton.rightImage()
		chooseButton.backgroundColor = UIColor.black.withAlphaComponent(0.1)
		chooseButton.addTarget(self, action: #selector(showImagePicker), for: .touchUpInside)
		chooseButton.layer.shadowOpacity = 0
		
		button = UIButton("Next", font: UIFont.systemFont(ofSize: 16), image: UIImage(named: "arrow_right"))
		button.rightImage()
		button.isHidden = true
		button.addTarget(self, action: #selector(complete), for: .touchUpInside)
		
		self.view.addSubviews(views: title, description, photo, chooseButton, button)
		self.view.constrain(type: .horizontalFill, title, description, photo, margin: 24)
		self.view.addConstraints(format: "H:|-(>=0)-[v0(120)]-24-|", views: button)
		self.view.addConstraints(format: "H:|-(>=0)-[v0(120)]-(>=0)-|", views: chooseButton)
		self.view.addConstraints(format: "V:|-120-[v0(24)]-8-[v1(48)]-24-[v2(\(self.view.frame.width - 48))]-(-56)-[v3(40)]-40-[v4(40)]-(>=0)-|", views: title, description, photo, chooseButton, button)
		chooseButton.centerXAnchor.constraint(equalTo: photo.centerXAnchor).isActive = true
		
		imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	@objc func pop() {
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func showImagePicker() {
		self.navigationController?.present(imagePicker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		print(info)
		imagePicker.dismiss(animated: true, completion: nil)
		photo.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
		button.isHidden = false
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		imagePicker.dismiss(animated: true, completion: nil)
	}
	
	@objc func complete() {
		let vc = NavigationController(rootViewController: TabBarController())
		vc.modalPresentationStyle = .overCurrentContext
		self.navigationController?.present(vc, animated: true, completion: nil)
	}
}
