//
//  ViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 13/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var message: UILabel!
    var root: UIViewController!
    var path: FlowPath!
    var user: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        message = UILabel("", Color.darkBlue_white, UIFont.systemFont(ofSize: 14))
        message.numberOfLines = 2
        message.isHidden = true
        
        user = DB.UserRecord()
    }
    
    var safeAreaInset: UIEdgeInsets? {
        get {
            let delegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            return delegate.window?.safeAreaInsets
        }
    }
    
    func TagButton(_ image: UIImage, _ title: String, color: UIColor?) -> UIView {
        let container = UIView()
        container.layer.cornerRadius = 15
        container.layer.borderColor = Color.separator.cgColor
        container.layer.borderWidth = 1
        
        image.withRenderingMode(.alwaysTemplate)

        let imageView = UIImageView(image: image.withTintColor((color != nil) ? color! : UIColor.darkText).resize(CGSize(width: 16, height: 16)))
        imageView.contentMode = .center

        
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = color!
        
        container.addSubviews(views: imageView, label)
        container.addConstraints(format: "H:|-12-[v0]-4-[v1]-12-|", views: imageView, label)
        container.constrain(type: .verticalFill, imageView, label, margin: 8)
        
        return container
    }
    
    func Title(text: String) -> UILabel {
        let title = UILabel(text, Color.formTitle, UIFont.systemFont(ofSize: 20, weight: .bold))
        return title
    }
    
    func ButtonXL(_ text: String, action: Selector) -> UIButton {
        let button = UIButton(text, font: UIFont.systemFont(ofSize: 18, weight: .bold))
        button.backgroundColor = Color.darkBlue_white
        button.setTitleColor(Color.white_black, for: .normal)
        button.layer.cornerRadius = 22
        button.contentEdgeInsets = UIEdgeInsets(top: 14, left: 40, bottom: 14, right: 40)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func ClearButton(_ text: String, action: Selector) -> UIButton {
        let button = UIButton(text, font: UIFont.systemFont(ofSize: 18, weight: .semibold))
        button.backgroundColor = UIColor.clear
        button.setTitleColor(Color.darkBlue_white, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    func showError(_ text: String, delay: CGFloat) {
        message.isHidden = false
        message.text = text
        message.textColor = Color.red
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: 0.3, delay: 0, animations: { [self] in
                message.isHidden = true
            }, completion: { _ in
                self.message.text = ""
                self.message.textColor = Color.darkBlue_white
            })
        })
    }
    
    func showMessage(_ text: String, delay: CGFloat) {
        message.isHidden = false
        message.text = text
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: 0.3, delay: 0, animations: { [self] in
                message.isHidden = true
            }, completion: { _ in
                self.message.text = ""
            })
        })
    }
    
    enum FlowPath {
        case ClaimUsername
        case InviteCode
    }
}
