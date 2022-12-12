//
//  TabController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
	
	var homeBadge: String!
	
	var navigationBarConstraint: NSLayoutConstraint!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nil, bundle: nil)

		self.setViewControllers([
            FeedViewController(), SearchViewController(), ActiveViewController(), ProfileViewController()
		], animated: false)
        
		self.tabBar.barTintColor = Color.background
        self.tabBar.backgroundColor = Color.background
        self.tabBar.isTranslucent = false
		self.tabBar.unselectedItemTintColor = UIColor.gray.withAlphaComponent(0.5)
		self.tabBar.tintColor = Color.tabItem

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(presentEditor))
        self.navigationItem.rightBarButtonItem?.tintColor = Color.darkBlue_white
		self.navigationItem.backBarButtonItem?.tintColor = UIColor.clear
		self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear
		], for: .normal)
		
	}
	
	@objc func presentEditor() {
		let editVC = EditViewController()
        editVC.modalPresentationStyle = .popover
//		DispatchQueue.main.async {
//			if self.canResignFirstResponder {
//				self.resignFirstResponder()
//				let vc = self.viewControllers?[0] as? EditViewController
//				vc?.textView.resignFirstResponder()
//				vc?.textView.endEditing(true)
//			}
//		}
		self.present(editVC, animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
}
