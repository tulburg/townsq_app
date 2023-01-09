//
//  ProfileViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ProfileViewController: ViewController, SocketDelegate {
    
	
	var details: [String]!
	var values: [String]!
    var rootView: UIView!
    var profilePhoto: UIImageView!
    var displayName: UILabel!
    var username: UILabel!
    var bio: UILabel!
    var followingCount: UILabel!
    var followersCount: UILabel!
    var broadcastCount: UILabel!
    var locationLabel: UILabel!
    var joinedLabel: UILabel!
    var followButton: UIButton!
    
    var properUser: User?
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	init() {
		super.init(nibName: nil, bundle: nil)
        title = ""
        let tabImage = UIImage(color: UIColor.clear)
		self.tabBarItem = UITabBarItem(title: "", image: tabImage, tag: 2)
		
		details = ["Date of birth", "Email address"]
		values = ["17 December", "tulburg@yahoo.com"]
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = Color.background
        view.showIndicator(size: .large, color: Color.darkBlue_white)
	}
    
    func setup(user: User) {
        view.hideIndicator()
        rootView = UIView()
        
        profilePhoto = UIImageView(link: "https://t4.ftcdn.net/jpg/04/86/11/69/360_F_486116937_WzL9xLnHyQWlsnGTCwyLyWF8DAcEMIT5.jpg", contentMode: .scaleAspectFill)
        if let photo = user.profile_photo {
            profilePhoto = UIImageView(link: photo, contentMode: .scaleAspectFill)
        }
        profilePhoto.clipsToBounds = true
        profilePhoto.layer.cornerRadius = 12
        profilePhoto.isUserInteractionEnabled = true
        profilePhoto.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPhotoPicker)))
        displayName = UILabel((user.name)!, Color.grayDark, UIFont.boldSystemFont(ofSize: 24))
        displayName.textAlignment = .center
        username = UILabel("@" + (user.username)!, Color.grayMid, UIFont.systemFont(ofSize: 14))
        username.textAlignment = .center
        
        followButton = UIButton("Follow", font: UIFont.systemFont(ofSize: 14, weight: .semibold))
        followButton.layer.cornerRadius = 15
        followButton.backgroundColor = Color.darkBlue
        followButton.addTarget(self, action: #selector(follow), for: .touchUpInside)
        let message = UIImage(named: "message")?.withTintColor(Color.darkBlue_white)
        let messageButton = UIImageView(image: message)
        messageButton.asButton()
        
        // MARK: - Upcoming feature
        messageButton.alpha = 0.3
        
        let more = UIImage(named: "more")?.withTintColor(Color.darkBlue_white)
        let moreButton = UIImageView(image: more)
        moreButton.asButton()
        let separator = UIView()
        separator.backgroundColor = Color.separator
        bio = UILabel("Hi, welcome to my profile. I’m a father, son & a cheerful spirit person. If you like what you see, please give me a follow & I will quickly follow back", Color.lightText, UIFont.systemFont(ofSize: 16))
        bio.textColor = Color.black_white
        bio.textAlignment = .center
        bio.numberOfLines = 6
        let buttonContainer = UIView()
        buttonContainer.addSubviews(views: followButton, messageButton, moreButton)
        buttonContainer.addConstraints(format: "H:|-(>=0)-[v0]-8-[v1(30)]-8-[v2(30)]-(>=0)-|", views: followButton, messageButton, moreButton)
        buttonContainer.addConstraints(format: "V:|-0-[v0(30)]-0-|", views: followButton)
        buttonContainer.addConstraints(format: "V:|-0-[v0(30)]-0-|", views: messageButton)
        buttonContainer.addConstraints(format: "V:|-0-[v0(30)]-0-|", views: moreButton)
        
        let (followers, followersCount) = makeCounter(245, "Followers")
        let (following, followingCount) = makeCounter(198, "Following")
        let (broadcasts, broadcastCount) = makeCounter(0, "Broadcasts")
        self.followersCount = followersCount
        self.followingCount = followingCount
        self.broadcastCount = broadcastCount
        let separator1 = UIView()
        separator1.backgroundColor = Color.separator
        let separator2 = UIView()
        separator2.backgroundColor = Color.separator
        let counterContainer = UIView()
        counterContainer.addSubviews(views: followers, following, broadcasts, separator1, separator2)
        counterContainer.addConstraints(format: "H:|-0-[v0(72)]-16-[v1(1)]-16-[v2(72)]-16-[v3(1)]-16-[v4(72)]-0-|", views: followers, separator1, following, separator2, broadcasts)
        counterContainer.constrain(type: .verticalFill, separator1, separator2, margin: 8)
        
        let statGroup = UIView()
        let (joined, joinedLabel) = TagButton(UIImage(systemName: "calendar")!, "Joined Sept 2021", color: Color.darkBlue_white)
        self.joinedLabel = joinedLabel
        joined.layer.borderWidth = 0
        let (location, locationLabel) = TagButton(UIImage(systemName: "pin")!, "West Virginia, CA", color: Color.darkBlue_white)
        self.locationLabel = locationLabel
        location.layer.borderWidth = 0
        statGroup.addSubviews(views: joined, location)
        statGroup.addConstraints(format: "H:|-0-[v0]-8-[v1]-0-|", views: joined, location)
        statGroup.constrain(type: .verticalFill, joined, location)
        
        if properUser != nil && properUser != self.user {
            rootView.add().vertical(48).view(profilePhoto, 120).gap(16).view(displayName).gap(0).view(username).gap(16).view(buttonContainer).gap(16).view(counterContainer, 44).gap(16).view(separator, 1).gap(16).view(bio).gap(16).view(statGroup).end(">=0")
        }else {
            rootView.add().vertical(48).view(profilePhoto, 120).gap(16).view(displayName).gap(0).view(username).gap(16).view(counterContainer, 44).gap(16).view(separator, 1).gap(16).view(bio).gap(16).view(statGroup).end(">=0")
        }
        
        rootView.constrain(type: .horizontalFill, bio, margin: 32)
        rootView.addConstraints(format: "H:|-(>=0)-[v0(120)]-(>=0)-|", views: profilePhoto)
        profilePhoto.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        rootView.constrain(type: .horizontalFill, displayName, username, separator)
        if properUser != nil && properUser != self.user {
            rootView.addConstraints(format: "H:|-(>=0)-[v0]-(>=0)-|", views: buttonContainer)
            buttonContainer.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        }
        rootView.addConstraints(format: "H:|-(>=0)-[v0]-(>=0)-|", views: counterContainer)
        rootView.addConstraints(format: "H:|-(>=0)-[v0]-(>=0)-|", views: statGroup)
        counterContainer.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        statGroup.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
        
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.add().horizontal(0).view(rootView, view.frame.width).end(0)
        scrollView.constrain(type: .verticalFill, rootView)
        view.add().horizontal(0).view(scrollView, view.frame.width).end(0)
        view.add().vertical(0).view(scrollView).end(0)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.title = ""
        (self.navigationController as? NavigationController)?.hideTopBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarItem.badgeColor = UIColor.clear
        self.tabBarItem.badgeValue = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarItem.badgeColor = UIColor.red
        self.tabBarItem.badgeValue = "3"
        
        (self.navigationController as? NavigationController)?.showTopBar()
    }
	
    func makeCounter(_ count: Int, _ label: String) -> (UIView, UILabel) {
        let countLabel = UILabel("\(count)", Color.grayDark, UIFont.systemFont(ofSize: 24))
        countLabel.textAlignment = .center
        let labelLabel = UILabel(label, Color.gray, UIFont.systemFont(ofSize: 12, weight: .semibold))
        labelLabel.textAlignment = .center
        let container = UIView()
        container.addSubviews(views: countLabel, labelLabel)
        container.addConstraints(format: "V:|-0-[v0]-2-[v1]-0-|", views: countLabel, labelLabel)
        container.constrain(type: .horizontalFill, countLabel, labelLabel)
        return (container, countLabel)
    }
	
    @objc func openPhotoPicker() {
        present(ProfilePhotoViewController(), animated: true)
    }
    
    @objc func follow() {
        if properUser != nil {
            Socket.shared.follow(properUser!)
        }
    }
    
    func socket(didReceive event: Constants.Events, data: ResponseData) {
        if event == .User {
            if let user = data as? DataType.User {
                setup(user: properUser!)
                followersCount.text = "\(user.followers ?? 0)"
                followingCount.text = "\(user.following ?? 0)"
                joinedLabel.text = "Joined " + (user.created?.string(with: "MMM, yyyy"))!
                profilePhoto.download(link: user.profile_photo!, contentMode: .scaleAspectFill)
                displayName.text = user.name
                username.text = "@" + user.username!
                if user.isFollowing! {
                    followButton.setTitle("Unfollow", for: .normal)
                    followButton.backgroundColor = Color.red
                }
                self.view.hideIndicator()
            }
        }
    }
	
}

