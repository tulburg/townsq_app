//
//  ProfilePhotoViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 17/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit
import PhotosUI

class ProfilePhotoViewController: ViewController, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
	
	var button: UIButton!
	var photo: UIImageView!
    var phPicker: PHPickerViewController!
	
	var delegate: UISceneDelegate!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Color.background
		let backButtonItem = UIBarButtonItem(title: "", style: .done, target: self, action: nil)
		backButtonItem.tintColor = Color.navigationItem
		self.navigationItem.backBarButtonItem = backButtonItem
		
		delegate = UIApplication.shared.delegate as? UISceneDelegate
		
		let title = Title(text: "Choose your profile picture")
        title.textAlignment = .center
        message.textAlignment = .center
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
        view.add().vertical(0.14 * view.frame.height).view(title).gap(8).view(message).gap(64).view(photo, 180).gap(-56).view(chooseButton, 40).gap(48).view(button, 44).end(">=0")
        photo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		view.constrain(type: .horizontalFill, title, message, margin: 32)
        view.constrain(type: .horizontalCenter, button, chooseButton)
    
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        phPicker = PHPickerViewController(configuration: phPickerConfig)
        phPicker.delegate = self
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	@objc func pop() {
		self.navigationController?.popViewController(animated: true)
	}
	
    @objc func showImagePicker() {
        present(phPicker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        phPicker.dismiss(animated: true)
        view.showIndicator(size: .large, color: Color.darkBlue_white)
        if let provider = results.first?.itemProvider {
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { uiImage, _ in
                    if let image = uiImage as? UIImage {
                        DispatchQueue.main.async {
                            self.photo.image = image
                            
                            let w = image.size.width
                            let h = image.size.height
                            let adjRatio = (w > h ? 240 / w : 240 / h)
                            let newImage = image.resize(CGSize(width: adjRatio * w, height: adjRatio * h))
                            let imageData = newImage.jpegData(compressionQuality: 9)
                            let name = UUID()
                            let fileAddr = Constants.S3Addr + "\(name.uuidString).jpg"
                            Api.main.setProfile("profile_photo", fileAddr) { data, error in
                                DispatchQueue.main.async { self.view.hideIndicator() }
                                let response = Response<AnyObject>((data?.toDictionary())! as NSDictionary)
                                if response.code == 200 {
                                    Progress.state = .ProfilePhotoSet
                                    DispatchQueue.main.async {
                                        S3.shared().uploadImage(data: imageData!, name: "\(name.uuidString).jpg", completion: { path in
                                            ImageCache.shared().set(data: imageData!, path: path, completion: nil)
                                        })
                                        
                                        DB.shared.update(.User, predicate: NSPredicate(format: "primary = %@", NSNumber(booleanLiteral:  true)), keyValue: ["profile_photo": fileAddr])
                                        self.button.isHidden = false
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }
    }
	
	@objc func complete() {
		let vc = NavigationController(rootViewController: TabBarController())
		vc.modalPresentationStyle = .overCurrentContext
		self.navigationController?.present(vc, animated: true, completion: nil)
	}
}
