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
    var button: UIButton!
    var imagePicker: UIImagePickerController!
    var photo: UIImageView!
    var messageWrap: UIView!
    var scrollView: UIScrollView!
    var phPicker: PHPickerViewController!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init() {
		super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = Color.background
        
        let rootView = UIView()
        
        messageWrap = UIView()
        messageWrap.backgroundColor = Color.backgroundDark
        messageWrap.layer.cornerRadius = 8
        
        editField = UITextView()
        editField.text = "Message here"
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
        controlView.add().horizontal(16).view(cameraButton, 32).gap(8).view(photoButton, 32).gap(">=0").view(counter).end("16")
        controlView.add().vertical(0).view(cameraButton, 32).end(0)
        controlView.add().vertical(0).view(photoButton, 32).end(0)
        controlView.constrain(type: .verticalCenter, counter)
        
        photo = UIImageView()
        photo.contentMode = .scaleAspectFill
        photo.layer.cornerRadius = 8
        photo.isHidden = true
        photo.clipsToBounds = true
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
        
        messageWrap.add().vertical(0).view(editField, 140).gap(8).view(photo, 0).gap(8).view(controlView, 32).end(16)
        messageWrap.constrain(type: .horizontalFill, editField, controlView)
        messageWrap.constrain(type: .horizontalFill, photo, margin: 16)
        
        let buttonContainer = UIView()
        button = ButtonXL("Publish", action: #selector(publish))
        button.isEnabled = false
        button.alpha = 0.3
        
        buttonContainer.add().horizontal(">=0").view(button).end(0)
        buttonContainer.add().vertical(0).view(button, 44).end(0)
        
        rootView.add().vertical(16).view(messageWrap).gap(24).view(buttonContainer).end(">=48")
        rootView.add().horizontal(16).view(messageWrap).end(16)
        rootView.add().horizontal(">=0").view(buttonContainer).end(16)
        
        scrollView = UIScrollView()
        scrollView.add().horizontal(0).view(rootView, view.frame.width).end(0)
        scrollView.constrain(type: .verticalFill, rootView)
        scrollView.delegate = self
        
        view.addSubview(scrollView)
        view.constrain(type: .horizontalFill, scrollView)
        view.constrain(type: .verticalFill, scrollView)
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = "New broadcast"
    }
    
    @objc func publish() {
        
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
        photo.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        photo.isHidden = false
        messageWrap.constraints.forEach({ constraint in
            if (constraint.firstItem as! UIView) == photo && constraint.firstAttribute == .height {
                constraint.constant = 240
            }
        })
        messageWrap.layoutIfNeeded()
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        phPicker.dismiss(animated: true)

        if let provider = results.first?.itemProvider {
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { uiImage, _ in
                    if let image = uiImage as? UIImage {
                        DispatchQueue.main.async {
                            let w = image.size.width
                            let h = image.size.height
                            let adjRatio = (w > h ? 720 / w : 720 / h)
                            let newImage = image.resize(CGSize(width: adjRatio * w, height: adjRatio * h))
                            let imageData = newImage.jpegData(compressionQuality: 9)
                            let name = UUID()
                            S3.shared().uploadImage(data: imageData!, name: "\(name.uuidString).jpg", completion: { path in
                                ImageCache.shared().set(data: imageData!, path: path, completion: nil)
                            })

                            self.photo.image = image
                            self.photo.isHidden = false
                            self.messageWrap.constraints.forEach({ constraint in
                                if (constraint.firstItem as! UIView) == self.photo && constraint.firstAttribute == .height {
                                    constraint.constant = 240
                                }
                            })
                            self.messageWrap.layoutIfNeeded()
                        }

                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let count = 200 - textView.text.count
        counter.text = "\(count)"
        DispatchQueue.main.async { [self] in
            if count < 0 {
                counter.textColor = Color.red
                button.isEnabled = false
                button.alpha = 0.3
            } else {
                counter.textColor = Color.black_white
                button.isEnabled = true
                button.alpha = 1
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

}

extension FileManager {
    func writeToTmp(data: Data, name: String) -> URL? {
        let tmp = temporaryDirectory
        let path = tmp.appendingPathExtension("\(name).jpg")
        if createFile(atPath: path.absoluteString, contents: data) {
            return path
        }else { return nil }
    }
    
//    func someting() {
//        do {
//            let documentFolderURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
//            let fileURL = documentFolderURL.appendingPathComponent((URL(string: (live?.media)!)?.lastPathComponent)!)
//            if live.type == "photo" {
//                eventPhoto.image = UIImage(contentsOfFile: fileURL.path)
//            }else if live.type == "video" {
//                player = AVPlayer(url: fileURL)
//                let playerController = AVPlayerViewController()
//                playerController.videoGravity = AVLayerVideoGravityResizeAspectFill
//                playerController.player = player
//                let videoView = playerController.view
//                videoView?.contentMode = .scaleAspectFill
//                videoView?.frame = view.bounds
//                if let p = playerController.player {
//                    p.play()
//                }
//                view.addSubview(videoView!)
//                view.constrain(type: .verticalFill, videoView!)
//                view.constrain(type: .horizontalFill, videoView!)
//                eventPhoto.isHidden = true
//                NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.player.currentItem)
//            }
//        }catch let error {
//            NSLog("Error -> \(error.localizedDescription)")
//        }
//    }
}
