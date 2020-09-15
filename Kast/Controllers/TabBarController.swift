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

		let editViewController = EditViewController()
		editViewController.modalPresentationStyle = .overCurrentContext
		self.setViewControllers([
			editViewController, FeedViewController(), ProfileViewController(), SettingsViewController()
		], animated: false)
		
		self.selectedIndex = 1
		self.tabBar.barTintColor = Color.background
		self.tabBar.unselectedItemTintColor = UIColor.gray.withAlphaComponent(0.5)
		self.tabBar.tintColor = Color.homeTab
		self.title = "Home"

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "message"), style: .plain, target: self, action: #selector(presentMessages))
		self.navigationItem.rightBarButtonItem?.tintColor = Color.cyan
		self.navigationItem.backBarButtonItem?.tintColor = UIColor.clear
		self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear
		], for: .normal)
		
	}
	
	override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
		
		let feedVC: UIViewController = (self.viewControllers?[1])!
		
		if item.tag == 0 {
			self.title = "New Broadcast"
		} else if item.tag == 1 {
			self.title = "Home"
			let tabImage = UIImage(named: "home")
			tabImage?.withTintColor(Color.homeTabLight, renderingMode: .alwaysTemplate)
			item.image = tabImage
		}else if item.tag == 2 {
			self.title = "Profile"
		}else if item.tag == 3 {
			self.title = "Settings"
		}
		
		if item.tag != 1 {
			feedVC.tabBarItem.badgeValue = self.homeBadge
		}
		
	}
	
	@objc func presentMessages() {
		let messagesVC = MessagesViewController()
		messagesVC.modalPresentationStyle = .fullScreen
		DispatchQueue.main.async {
			if self.canResignFirstResponder {
				self.resignFirstResponder()
				let vc = self.viewControllers?[0] as? EditViewController
				vc?.textView.resignFirstResponder()
				vc?.textView.endEditing(true)
			}
		}
		self.navigationController?.pushViewController(messagesVC, animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
	
}
