//
//  Alert.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 19/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class Alert {
    
    var viewController = UIViewController()
    var viewHolder = UIView()
    var mainView: UIView!
    var backgroundOverlay: UIView!
    var parent: UIViewController!
    private var viewHolderTopConstraint: NSLayoutConstraint!
    
    var colors: Dictionary<String, UIColor> = [
        "info": UIColor.darkGray, "success" : UIColor.green,
        "error" : UIColor.red, "confirm" : UIColor.white, "custom" : UIColor.green
    ]
    var window: UIWindow? {
        get {
            let delegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            return delegate.window
        }
    }
    
    init(_ message: String, type: AlertType) {
        mainView = UIView()
        backgroundOverlay = UIView()
        viewController.view.backgroundColor = UIColor.clear
        viewController.modalPresentationStyle = .overCurrentContext
        mainView.frame = viewController.view.frame
        mainView.backgroundColor = UIColor.clear
        backgroundOverlay.backgroundColor = UIColor.black
        backgroundOverlay.frame = mainView.frame
        backgroundOverlay.alpha = 0.0
        backgroundOverlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(close)))
        viewController.view.addSubview(mainView)
        mainView.addSubview(backgroundOverlay)
        viewHolder.backgroundColor = UIColor.white
        viewHolder.layer.cornerRadius = 6
        if !(type == .custom || type == .confirm) {
            let title = UILabel()
            title.font = UIFont.boldSystemFont(ofSize: 20)
            title.textColor = colors[type.rawValue]
            title.text = message
            title.numberOfLines = 4
            let cancelButton = UIButton()
            let cancelImage = UIImage(named: "k_cancel")?.withRenderingMode(.alwaysTemplate)
            cancelButton.setImage(cancelImage, for: .normal)
            cancelButton.tintColor = UIColor.white
            cancelButton.backgroundColor = UIColor.red
            cancelButton.layer.cornerRadius = 15
            cancelButton.addTarget(self, action: #selector(close), for: .touchUpInside)
            viewHolder.addSubviews(title, cancelButton)
            viewHolder.addConstraints(format: "H:|-16-[v0]-8-[v1(30)]-16-|", views: title, cancelButton)
            viewHolder.addConstraints(format: "V:|-(>=0)-[v0(30)]-(>=0)-|", views: cancelButton)
            viewHolder.constrain(type: .verticalFill, title, margin: 16)
            cancelButton.centerYAnchor.constraint(equalTo: viewHolder.centerYAnchor).isActive = true
        }
        
        mainView.addSubviews(viewHolder)
        mainView.constrain(type: .horizontalFill, viewHolder, margin: 16)
        mainView.addConstraints(format: "V:|-(>=0)-[v0]-(>=-800)-|", views: viewHolder)
        viewHolderTopConstraint = NSLayoutConstraint(item: viewHolder, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant: self.viewHolder.frame.height + 16)
        viewHolderTopConstraint.isActive = true
        mainView.addConstraint(viewHolderTopConstraint)
    }
    
    func setController(_ vc: UIViewController) -> Alert {
        self.parent = vc
        return self
    }
    
    func setCustomView(_ view: UIView) -> Alert {
        viewHolder = view
        mainView.addSubviews(viewHolder)
        mainView.constrain(type: .horizontalFill, viewHolder, margin: 16)
        mainView.addConstraints(format: "V:|-(>=0)-[v0]-(>=-800)-|", views: viewHolder)
        viewHolder.layoutIfNeeded()
        viewHolderTopConstraint = NSLayoutConstraint(item: viewHolder, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1, constant:(self.viewHolder.frame.height + 16))
        viewHolderTopConstraint.isActive = true
        mainView.addConstraint(viewHolderTopConstraint)
        return self
    }
    
    func show() {
        var controller = window?.rootViewController
        if self.parent != nil {
            controller = parent
        }
        controller?.present(viewController, animated: false, completion: {
            UIView.animate(withDuration: 0.25, animations: {
                self.backgroundOverlay.alpha = 0.42
                self.mainView.removeConstraint(self.viewHolderTopConstraint)
                self.viewHolderTopConstraint = NSLayoutConstraint(item: self.viewHolder, attribute: .bottom, relatedBy: .equal, toItem: self.mainView, attribute: .bottom, multiplier: 1, constant: -16)
                self.viewHolderTopConstraint.isActive = true
                self.mainView.addConstraint(self.viewHolderTopConstraint)
                self.mainView.layoutIfNeeded()
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 30, execute: {
            self.close()
        })
        
    }
    
    @objc func close() {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundOverlay.alpha = 0.0
            self.mainView.removeConstraint(self.viewHolderTopConstraint)
            self.viewHolder.layoutIfNeeded()
            self.viewHolderTopConstraint = NSLayoutConstraint(item: self.viewHolder, attribute: .bottom, relatedBy: .equal, toItem: self.mainView, attribute: .bottom, multiplier: 1, constant: self.viewHolder.frame.height + 16)
            self.viewHolderTopConstraint.isActive = true
            self.mainView.addConstraint(self.viewHolderTopConstraint)
            self.mainView.layoutIfNeeded()
        }, completion: { (completed) -> Void in
            self.viewController.dismiss(animated: true, completion: nil)
        })
    }
    
    enum AlertType: String {
        case info
        case success
        case error
        case confirm
        case custom
    }
}

class Notice {
    
    var viewController = UIViewController()
    var viewHolder = UIView()
    var mainView: UIView!
    var backgroundOverlay: UIView!
    var callback: (_ completed: Bool) -> Void?
    var showing: Bool = false
    var controller: UIViewController!
    var window: UIWindow? {
        get {
            let delegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
            return delegate.window
        }
    }
    
    init(_ message: String, type: NoticeType, tap: @escaping (_ completed: Bool) -> Void) {
        mainView = UIView()
        backgroundOverlay = UIView()
        viewController.view.backgroundColor = UIColor.clear
        viewController.modalPresentationStyle = .overCurrentContext
        mainView.frame = viewController.view.frame
        mainView.backgroundColor = UIColor.clear
        backgroundOverlay.backgroundColor = UIColor.black
        backgroundOverlay.frame = mainView.frame
        backgroundOverlay.alpha = 0.0
        viewController.view.addSubview(mainView)
        mainView.addSubview(backgroundOverlay)
        viewHolder.backgroundColor = Color.cyan
        viewHolder.layer.shadowOpacity = 0.2
        viewHolder.layer.shadowOffset = CGSize(width: -2, height: -2)
        viewHolder.layer.cornerRadius = 4
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 14)
        title.textColor = UIColor.white
        title.text = message
        title.numberOfLines = 3
        title.textAlignment = .center
        let image = UIImageView()
        if type == NoticeType.error {
            image.image = UIImage(named: "bad")?.withRenderingMode(.alwaysTemplate)
        }else {
            image.image = UIImage(named: "good")?.withRenderingMode(.alwaysTemplate)
        }
        image.tintColor = UIColor.white
        viewHolder.addSubviews(title, image)
        viewHolder.addConstraints(format: "V:|-8-[v0(40)]-(>=8)-|", views: image)
        viewHolder.constrain(type: .verticalFill, title, margin: 8)
        viewHolder.addConstraints(format: "H:|-16-[v0(40)]-[v1]-16-|", views: image, title)
        //        image.centerXAnchor.constraint(equalTo: viewHolder.centerXAnchor).isActive = true
        callback = tap
        viewHolder.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(call)))
        mainView.addSubview(viewHolder)
        mainView.addConstraints(format: "V:|-72-[v0]-(>=0)-|", views: viewHolder)
        mainView.addConstraints(format: "H:|-32-[v0]-32-|", views: viewHolder)
        
        controller = window?.rootViewController
    }
    
    func show() {
        showing = true
        controller.present(viewController, animated: false, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 60000, execute: {
            self.call()
        })
    }
    
    func setController(_ vc: UIViewController) -> Notice {
        self.controller = vc
        return self
    }
    
    @objc func call() {
        if showing {
            self.callback(true)
            self.viewController.dismiss(animated: false, completion: nil)
        }
    }
    
    
    enum NoticeType: String {
        case error
        case info
    }
}

