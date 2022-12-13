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
    var activeBadge: UIView!
    var profileRing: UIView!
	
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.items?.firstIndex(of: item) == 3 {
            profileRing.backgroundColor = Color.tabItem
        }else {
            profileRing.backgroundColor = Color.homeTabLight
        }
    }
	
	@objc func presentEditor() {
		let editVC = EditViewController()
        editVC.modalPresentationStyle = .popover
		self.present(editVC, animated: true)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let barButton = self.tabBar.subviews[3]
        activeBadge = UIView(frame: CGRect(x: (barButton.frame.width / 2) + 6, y: 8, width: 6, height: 6))
        activeBadge.backgroundColor = UIColor.red
        activeBadge.layer.cornerRadius = 3
        activeBadge.clipsToBounds = true
        barButton.addSubview(activeBadge)
        
        let profileButton = self.tabBar.subviews[4]
        profileRing = UIView()
        profileRing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfile)))
        profileRing.backgroundColor = Color.homeTabLight
        profileRing.layer.cornerRadius = 15
        profileRing.clipsToBounds = true
        let imageView = UIImageView(link: "https://t4.ftcdn.net/jpg/04/86/11/69/360_F_486116937_WzL9xLnHyQWlsnGTCwyLyWF8DAcEMIT5.jpg", contentMode: .scaleAspectFill)
        imageView.layer.borderColor = Color.white_black.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        imageView.tintColor = UIColor.lightText
        profileRing.addSubview(imageView)
        profileRing.addConstraints(format: "V:|-2-[v0(28)]-2-|", views: imageView)
        profileRing.addConstraints(format: "H:|-2-[v0(28)]-2-|", views: imageView)
        profileButton.addSubview(profileRing)
        profileButton.addConstraints(format: "V:|-8-[v0]-(>=0)-|", views: profileRing)
        profileButton.addConstraints(format: "H:|-(\((profileButton.frame.width / 2) - 24))-[v0]-(>=0)-|", views: profileRing)
    }
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
	}
    
    @objc func selectProfile() {
        selectedIndex = 3
        profileRing.backgroundColor = Color.tabItem
    }
	
}
