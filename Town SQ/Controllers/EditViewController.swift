//
//  FirstViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit
import NotificationCenter
import PhotosUI

class EditViewController: ViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
	var editField: UITextView!
    var counter: UILabel!
    var publishButton: UIBarButtonItem!
    var imagePicker: UIImagePickerController!
    var photo: UIImageView!
    var messageWrap: UIView!
    var scrollView: UIScrollView!
    var phPicker: PHPickerViewController!
    
    var mediaPhoto: UIImage?
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
        self.view.backgroundColor = Color.background
        
        let rootView = UIView()
        
        messageWrap = UIView()
        messageWrap.backgroundColor = Color.backgroundDark
        messageWrap.layer.cornerRadius = 8
        
        editField = UITextView()
        editField.text = "What about?"
        editField.backgroundColor = UIColor.clear
        editField.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -2)
        editField.textColor = Color.black_white
        editField.font = UIFont.systemFont(ofSize: 18)
        editField.delegate = self
        editField.textAlignment = .natural
        editField.showsVerticalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification , object: .none)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: .none)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: .none)
        
        let photoImage = UIImage(named: "photo")
        let camera = UIImage(named: "camera")
        
        let photoButton = UIImageView(image: photoImage?.withTintColor(Color.darkBlue_white))
        photoButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
        photoButton.isUserInteractionEnabled = true
        photoButton.contentMode = .center
        let cameraButton = UIImageView(image: camera?.withTintColor(Color.darkBlue_white))
        cameraButton.contentMode = .center
        cameraButton.isUserInteractionEnabled = true
        cameraButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCamera)))
        counter = UILabel("200", Color.black_white, UIFont.boldSystemFont(ofSize: 12))
        
        let controlView = UIView()
        controlView.add().horizontal(8).view(cameraButton, 40).gap(8).view(photoButton, 40).gap(">=0").view(counter).end("16")
        controlView.add().vertical(0).view(cameraButton, 40).end(0)
        controlView.add().vertical(0).view(photoButton, 40).end(0)
        controlView.constrain(type: .verticalCenter, counter)
        
        photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.layer.cornerRadius = 8
        photo.isHidden = true
        photo.clipsToBounds = true
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
        
        messageWrap.add().vertical(0).view(editField, 140).gap(8).view(photo, 0).gap(8).view(controlView, 40).end(8)
        messageWrap.constrain(type: .horizontalFill, editField, controlView)
        messageWrap.constrain(type: .horizontalFill, photo, margin: 16)
        
        let button = ButtonXL("Publish", action: #selector(publish))
        button.disable(true)
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 16, bottom: 14, right: 16)
        
        rootView.add().vertical(16).view(messageWrap).end(">=48")
        rootView.add().horizontal(16).view(messageWrap).end(16)
        rootView.isUserInteractionEnabled = true
        
        scrollView = UIScrollView()
        scrollView.add().horizontal(0).view(rootView, view.frame.width).end(0)
        scrollView.constrain(type: .verticalFill, rootView)
        scrollView.delegate = self
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resign)))
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        toolbar.barTintColor = Color.create(0xFFFFFF, dark: 0x00000000)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        publishButton = UIBarButtonItem(customView: button)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(cancel))
        cancelButton.tintColor = Color.red
        toolbar.setItems([
            cancelButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            publishButton
        ], animated: false)
        
        view.add().vertical(safeAreaInset!.top + 16).view(toolbar, 44).gap(0).view(scrollView).end(0)
        view.constrain(type: .horizontalFill, scrollView, toolbar)
        
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
    }
    
    @objc func publish() {
        if let image = mediaPhoto {
            let w = image.size.width
            let h = image.size.height
            let adjRatio = (w > h ? 720 / w : 720 / h)
            let newImage = image.resizeWithImageIO(to: CGSize(width: adjRatio * w, height: adjRatio * h))
            let imageData = newImage!.jpegData(compressionQuality: 9)
//            S3.shared().uploadImage(data: imageData!, name: "\(name.uuidString).jpg", completion: { path in
//                ImageCache.shared().set(data: imageData!, path: path, completion: nil)
//            })
            
            Socket.shared.publishBroadcast(editField.text, imageData?.base64EncodedString(), .photo)
        }else {
            Socket.shared.publishBroadcast(editField.text, nil, nil)
        }
        editField.text = ""
        disableButton(true)
        dismiss(animated: true)
    }
    
    func disableButton(_ disable: Bool) {
        publishButton.isEnabled = !disable
        if disable {
            publishButton.customView?.alpha = 0.5
        }else {
            publishButton.customView?.alpha = 1
        }
    }
    
    
    @objc func resign() {
        if editField.isFirstResponder {
            editField.resignFirstResponder()
        }
    }
    
    @objc func showImagePicker() {
        var phPickerConfig = PHPickerConfiguration(photoLibrary: .shared())
        phPickerConfig.selectionLimit = 1
        phPickerConfig.filter = PHPickerFilter.any(of: [.images, .livePhotos])
        phPicker = PHPickerViewController(configuration: phPickerConfig)
        phPicker.delegate = self
        present(phPicker, animated: true)
    }
    
    @objc func showCamera() {
        imagePicker.sourceType = .camera
        imagePicker.cameraCaptureMode = .photo
        imagePicker.cameraDevice = .rear
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        photo.isHidden = false
        messageWrap.constraints.forEach({ constraint in
            if (constraint.firstItem as! UIView) == photo && constraint.firstAttribute == .height {
                constraint.constant = 240
            }
        })
        messageWrap.layoutIfNeeded()
        photo.showIndicator(size: .large, color: Color.purple)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            mediaPhoto = image
            photo.image = image
            photo.hideIndicator()
        }
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        phPicker.dismiss(animated: true)
        self.photo.isHidden = false
        self.messageWrap.constraints.forEach({ constraint in
            if (constraint.firstItem as! UIView) == self.photo && constraint.firstAttribute == .height {
                constraint.constant = 240
            }
        })
        self.messageWrap.layoutIfNeeded()
        photo.showIndicator(size: .large, color: Color.purple)
        if let provider = results.first?.itemProvider {
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { uiImage, _ in
                    if let image = uiImage as? UIImage {
                        DispatchQueue.main.async {
                            self.mediaPhoto = image
                            self.photo.image = image
                            self.photo.hideIndicator()
                        }

                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "What about?" {
            textView.text = ""
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = 200 - textView.text.count
        counter.text = "\(count)"
        DispatchQueue.main.async { [self] in
            if count < 0 {
                counter.textColor = Color.red
                disableButton(true)
            } else {
                counter.textColor = Color.black_white
                if textView.text.count > 0 {
                    disableButton(false)
                }else {
                    disableButton(true)
                }
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let kFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            view.constraints.forEach({ constraint in
                if (constraint.secondItem as? UIView) == scrollView && constraint.firstAttribute == .bottom {
                    constraint.constant = kFrame.height
                }
            })
            view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.constraints.forEach({ constraint in
            if (constraint.secondItem as? UIView) == scrollView && constraint.firstAttribute == .bottom {
                constraint.constant = 0
            }
        })
        view.layoutIfNeeded()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if editField.isFirstResponder {
            editField.resignFirstResponder()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if editField.isFirstResponder {
            editField.resignFirstResponder()
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }

}

extension FileManager {
    func writeToTmp(data: Data, name: String) -> URL? {
        let tmp = temporaryDirectory
        let path = tmp.appendingPathExtension("\(name).jpg")
        if createFile(atPath: path.absoluteString, contents: data) {
            return path
        }else { return nil }
    }
}

extension UIImage {
    func resizeWithImageIO(to newSize: CGSize) -> UIImage? {
        var resultImage = self
        
        guard let data = jpegData(compressionQuality: 1.0) else { return resultImage }
        let imageCFData = NSData(data: data) as CFData
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: max(newSize.width, newSize.height)
        ] as CFDictionary
        guard   let source = CGImageSourceCreateWithData(imageCFData, nil),
                let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else { return resultImage }
        resultImage = UIImage(cgImage: imageReference)
        
        return resultImage
    }

}
