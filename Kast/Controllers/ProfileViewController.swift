//
//  ProfileViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
	
	var details: [String]!
	var values: [String]!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	init() {
		super.init(nibName: nil, bundle: nil)
        title = ""
        let tabImage = UIImage()
		self.tabBarItem = UITabBarItem(title: "", image: tabImage, tag: 2)
		
		details = ["Date of birth", "Email address"]
		values = ["17 December", "tulburg@yahoo.com"]
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = Color.background
		
        let profilePhoto = UIImageView(link: "https://t4.ftcdn.net/jpg/04/86/11/69/360_F_486116937_WzL9xLnHyQWlsnGTCwyLyWF8DAcEMIT5.jpg", contentMode: .scaleAspectFill)
		profilePhoto.clipsToBounds = true
		profilePhoto.layer.cornerRadius = 40
		let displayName = UILabel("Simone biles", Color.grayDark, UIFont.boldSystemFont(ofSize: 24))
		displayName.textAlignment = .center
        let username = UILabel("@simone_biles", Color.grayMid, UIFont.systemFont(ofSize: 14))
        username.textAlignment = .center
		
        let followButton = UIButton("Follow")
        let messageButton = UIButton("", font: UIFont.systemFont(ofSize: 12), image: UIImage(named: "message"))
        let moreButton = UIButton("", font: UIFont.systemFont(ofSize: 12), image: UIImage(named: "more"))
        let separator = UIView()
        separator.backgroundColor = Color.separator
        let bio = UILabel("Hi, welcome to my profile. I’m a father, son & a cheerful spirit person. If you like what you see, please give me a follow & I will quickly follow back", Color.lightText, UIFont.systemFont(ofSize: 16))
        let buttonContainer = UIView()
        buttonContainer.addSubviews(views: followButton, messageButton, moreButton)
        buttonContainer.addConstraints(format: "H:|-(>=0)-[v0]-8-[v1]-8-[v2]-(>=0)-|", views: followButton, messageButton, moreButton)
        buttonContainer.constrain(type: .verticalFill, followButton, messageButton, moreButton)
		
        let followers = makeCounter(245, "Followers")
        let following = makeCounter(198, "Following")
        let broadcasts = makeCounter(0, "Broadcasts")
        let separator1 = UIView()
        separator1.backgroundColor = Color.separator
        let separator2 = UIView()
        separator2.backgroundColor = Color.separator
        let counterContainer = UIView()
        counterContainer.addSubviews(views: followers, following, broadcasts, separator1, separator2)
        counterContainer.addConstraints(format: "H:|-0-[v0(72)]-16-[v1(1)]-16-[v2(72)]-16-[v3(1)]-16-[v4(72)]-0-|", views: followers, separator1, following, separator2, broadcasts)
        counterContainer.constrain(type: .verticalFill, separator1, separator2, margin: 8)
        
        view.addSubviews(views: profilePhoto, displayName, username, buttonContainer, counterContainer, separator)
        view.addConstraints(format: "V:|-8-[v0(80)]-4-[v1]-0-[v2]-16-[v3]-24-[v4(44)]-16-[v5(1)]-(>=0)-|", views: profilePhoto, displayName, username, buttonContainer, counterContainer, separator)
        view.addConstraints(format: "H:|-(>=0)-[v0(80)]-(>=0)-|", views: profilePhoto)
        profilePhoto.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.constrain(type: .horizontalFill, displayName, username, separator)
        view.addConstraints(format: "H:|-(>=0)-[v0]-(>=0)-|", views: buttonContainer)
        view.addConstraints(format: "H:|-(>=0)-[v0]-(>=0)-|", views: counterContainer)
        buttonContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        counterContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		
	}
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = ""
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        self.tabBarItem.badgeColor = UIColor.red
        self.tabBarItem.badgeValue = "3"
        
    }
	
    func makeCounter(_ count: Int, _ label: String) -> UIView {
        let countLabel = UILabel("\(count)", Color.grayDark, UIFont.systemFont(ofSize: 24))
        countLabel.textAlignment = .center
        let labelLabel = UILabel(label, Color.gray, UIFont.systemFont(ofSize: 12, weight: .semibold))
        labelLabel.textAlignment = .center
        let container = UIView()
        container.addSubviews(views: countLabel, labelLabel)
        container.addConstraints(format: "V:|-0-[v0]-2-[v1]-0-|", views: countLabel, labelLabel)
        container.constrain(type: .horizontalFill, countLabel, labelLabel)
        return container
    }
	
	
}

