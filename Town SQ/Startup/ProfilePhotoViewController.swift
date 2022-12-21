//
//  ProfilePhotoViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 17/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ProfilePhotoViewController: ViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	var button: UIButton!
	var imagePicker: UIImagePickerController!
	var photo: UIImageView!
	
	var delegate: UISceneDelegate!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Color.background
		self.navigationItem.title = "Profile picture"
		let backButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
		backButtonItem.tintColor = Color.navigationItem
		self.navigationItem.backBarButtonItem = backButtonItem
		
		delegate = UIApplication.shared.delegate as? UISceneDelegate
		
		
		let title = UILabel("Choose your profile picture", Color.formTitle, UIFont.systemFont(ofSize: 22, weight: .bold))
        title.textAlignment = .center
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
		
		button = ButtonXL("Next", action: #selector(complete))
		button.isHidden = true
        view.add().horizontal(">=0").view(photo, 180).end(">=0")
        view.add().vertical(0.08 * view.frame.height).view(title, 24).gap(48).view(photo, 180).gap(-56).view(chooseButton, 40).gap(48).view(button, 44).end(">=0")
        photo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		view.constrain(type: .horizontalFill, title, margin: 24)
        view.constrain(type: .horizontalCenter, button, chooseButton)
		
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
