//
//  TabController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController, SocketDelegate {
	
	var homeBadge: String!
    var activeBadge: UIView!
    var profileRing: UIView!
    var profileImage: UIImageView!
	
	var navigationBarConstraint: NSLayoutConstraint!
    var user: User!
    var hasUnread = false
	
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
        
        user = DB.UserRecord()
        let activeBroadcasts = DB.activeBroadcasts()!
        hasUnread = activeBroadcasts.filter{ return $0.unread > 0 }.count > 0

		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(presentEditor))
        self.navigationItem.rightBarButtonItem?.tintColor = Color.darkBlue_white
		self.navigationItem.backBarButtonItem?.tintColor = UIColor.clear
		self.navigationItem.backBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear
		], for: .normal)
        
        Socket.shared.registerDelegate(self)
	}
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.items?.firstIndex(of: item) == 3 {
            profileRing.backgroundColor = Color.tabItem
            self.navigationItem.rightBarButtonItems = [
                UIBarButtonItem(image: UIImage(named: "settings"), style: .done, target: self, action: #selector(openSettings)),
                UIBarButtonItem(image: UIImage(systemName: "bell"), style: .done, target: self, action: #selector(openSettings)),
            ]
            (self.navigationController as! NavigationController).hideTopBar()
        }else {
            profileRing.backgroundColor = Color.homeTabLight
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "edit"), style: .plain, target: self, action: #selector(presentEditor))]
            (self.navigationController as! NavigationController).showTopBar()
        }

    }

	@objc func presentEditor() {
		let editVC = EditViewController()
        editVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(editVC, animated: true)
	}

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupBadges()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        profileImage?.layer.borderColor = Color.white_black.cgColor
    }
    
    func setupBadges() {
        if self.activeBadge != nil || self.profileRing != nil {
            return;
        }
        let barButton = self.tabBar.subviews[3]
        activeBadge = UIView(frame: CGRect(x: (barButton.frame.width / 2) + 6, y: 8, width: 6, height: 6))
        activeBadge.backgroundColor = UIColor.red
        activeBadge.layer.cornerRadius = 3
        activeBadge.clipsToBounds = true
        activeBadge.tag = "tab-badge".hashValue
        activeBadge.isHidden = !hasUnread
        barButton.addSubview(activeBadge)
        
        let profileButton = self.tabBar.subviews[4]
        profileRing = UIView()
        profileRing.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectProfile)))
        profileRing.backgroundColor = Color.homeTabLight
        profileRing.layer.cornerRadius = 15
        profileRing.clipsToBounds = true
        profileImage = UIImageView(image: UIImage(named: "profile_background"))
        if let photo = user.profile_photo {
            profileImage = UIImageView(link: photo, contentMode: .scaleAspectFill)
        }
        profileImage.backgroundColor = Color.white_black
        profileImage.layer.cornerRadius = 14
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = Color.white_black.cgColor
        profileImage.layer.borderWidth = 2
        profileImage.tintColor = UIColor.lightText
        profileRing.addSubview(profileImage)
        profileRing.addConstraints(format: "V:|-2-[v0(28)]-2-|", views: profileImage)
        profileRing.addConstraints(format: "H:|-2-[v0(28)]-2-|", views: profileImage)
        profileButton.addSubview(profileRing)
        profileButton.addConstraints(format: "V:|-8-[v0]-(>=0)-|", views: profileRing)
        profileButton.addConstraints(format: "H:|-(\((profileButton.frame.width / 2) - 24))-[v0]-(>=0)-|", views: profileRing)
        
        tabBar.items![3].badgeColor = Color.red
        tabBar.items![3].badgeValue = "3"
    }

    @objc func selectProfile() {
        selectedIndex = 3
        profileRing.backgroundColor = Color.tabItem
        tabBar(self.tabBar, didSelect: tabBar.items![3])
    }

    @objc func openSettings() {
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    func socket(didReceive event: Constants.Events, data: ResponseData) {
        if event == .GotComment && self.selectedIndex != 2 {
            self.activeBadge.isHidden = false
        }
    }
	
}
