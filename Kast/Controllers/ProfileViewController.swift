//
//  ProfileViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ProfileViewController: ViewController {
	
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
		
        let followButton = UIButton("Follow", font: UIFont.systemFont(ofSize: 14, weight: .semibold))
        followButton.layer.cornerRadius = 15
        followButton.backgroundColor = Color.darkBlue_white
        let messageButton = UIImageView(image: UIImage(named: "message"))
        messageButton.asButton()
        let moreButton = UIImageView(image: UIImage(named: "more"))
        moreButton.asButton()
        let separator = UIView()
        separator.backgroundColor = Color.separator
        let bio = UILabel("Hi, welcome to my profile. I’m a father, son & a cheerful spirit person. If you like what you see, please give me a follow & I will quickly follow back", Color.lightText, UIFont.systemFont(ofSize: 16))
        bio.textAlignment = .center
        bio.numberOfLines = 6
        let buttonContainer = UIView()
        buttonContainer.addSubviews(views: followButton, messageButton, moreButton)
        buttonContainer.addConstraints(format: "H:|-(>=0)-[v0]-8-[v1(30)]-8-[v2(30)]-(>=0)-|", views: followButton, messageButton, moreButton)
        buttonContainer.addConstraints(format: "V:|-0-[v0(30)]-0-|", views: followButton)
        buttonContainer.addConstraints(format: "V:|-0-[v0(30)]-0-|", views: messageButton)
        buttonContainer.addConstraints(format: "V:|-0-[v0(30)]-0-|", views: moreButton)
		
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
        
        let statGroup = UIView()
        let joined = TagButton(UIImage(systemName: "calendar")!, "Joined Sept 2021", color: Color.darkBlue_white)
        joined.layer.borderWidth = 0
        let location = TagButton(UIImage(systemName: "pin")!, "West Virginia, CA", color: Color.darkBlue_white)
        location.layer.borderWidth = 0
        statGroup.addSubviews(views: joined, location)
        statGroup.addConstraints(format: "H:|-0-[v0]-8-[v1]-0-|", views: joined, location)
        statGroup.constrain(type: .verticalFill, joined, location)
        
        
        view.addSubviews(views: profilePhoto, displayName, username, buttonContainer, counterContainer, separator, bio, statGroup)
        view.addConstraints(
            format: "V:|-8-[v0(80)]-4-[v1]-0-[v2]-16-[v3]-24-[v4(44)]-16-[v5(1)]-16-[v6]-16-[v7]-(>=0)-|",
            views: profilePhoto, displayName, username, buttonContainer, counterContainer, separator, bio, statGroup
        )
        view.constrain(type: .horizontalFill, bio, margin: 32)
        view.addConstraints(format: "H:|-(>=0)-[v0(80)]-(>=0)-|", views: profilePhoto)
        profilePhoto.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view.constrain(type: .horizontalFill, displayName, username, separator)
        view.addConstraints(format: "H:|-(>=0)-[v0]-(>=0)-|", views: buttonContainer)
        view.addConstraints(format: "H:|-(>=0)-[v0]-(>=0)-|", views: counterContainer)
        view.addConstraints(format: "H:|-(>=0)-[v0]-(>=0)-|", views: statGroup)
        buttonContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        counterContainer.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        statGroup.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
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

