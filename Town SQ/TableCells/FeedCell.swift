//
//  FeedCell.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 09/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    var broadcast: Broadcast!
    var separator: UIView!
    
    var ownerName: UILabel!
    var ownerUsername: UILabel!
    var feedTime: UILabel!
    var feedText: UILabel!
    var unreadCount: UILabel!
    var unreadContainer: UIView!
    var peopleCount: UILabel!
    var ownerImage: UIImageView!
    var statusText: UILabel!
    var feedActivitySummary: UILabel!
    var feedImage: UIImageView!
    
    var asHeader: Bool!
    var activity: Bool!
    var hasMedia: Bool!
    
    var onLeave: (() -> Void)? = nil
    var onOpen: (() -> Void)? = nil
    
    var winH: CGFloat = 0
    var winW: CGFloat = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        hasMedia = reuseIdentifier?.contains("_with_media")
        asHeader = reuseIdentifier?.contains("_as_header")
        activity = reuseIdentifier?.contains("_as_active")
        
        let delegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        winH = (delegate.window?.rootViewController!.view.frame.height)!
        winW = (delegate.window?.rootViewController!.view.frame.width)!
        
        let ownerImage = makeOwnerImage()
        ownerImage.isUserInteractionEnabled = true
        ownerImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openProfile)))
        ownerName = UILabel("", Color.darkBlue_white, UIFont.systemFont(ofSize: 17, weight: .bold))
        ownerUsername = UILabel("@", Color.lightText, UIFont.systemFont(ofSize: 14, weight: .regular))
        ownerUsername.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openProfile)))
        feedTime = UILabel("ago", Color.darkBlue, UIFont.systemFont(ofSize: 12))
        feedText = UILabel("", Color.black_white, UIFont.systemFont(ofSize: 16))
        feedText.numberOfLines = 6
        
        let feedBody = UIView()
        if !hasMedia {
            feedBody.addSubviews(views: feedText)
            feedBody.constrain(type: .horizontalFill, feedText)
            feedBody.addConstraints(format: "V:|-0-[v0]-4-|", views: feedText)
        }else {
            feedImage = UIImageView(link: "https://img5.goodfon.com/wallpaper/nbig/0/63/face-look-beautiful-girl-flowers-field-eyes.jpg", contentMode: .scaleAspectFill)
            feedImage.layer.cornerRadius = 8
            feedImage.clipsToBounds = true
            feedBody.addSubviews(views: feedText, feedImage)
            feedBody.constrain(type: .horizontalFill, feedText, feedImage)
            feedBody.addConstraints(format: "V:|-0-[v0]-16-[v1(220)]-0-|", views: feedText, feedImage)
        }
        
        unreadContainer = activityBadge()
        unreadContainer.isHidden = true
        
        let ownerContainer = UIView()
        ownerContainer.addSubviews(views: ownerName, feedTime, unreadContainer)
        ownerContainer.addConstraints(format: "V:|-0-[v0]-0-|", views: ownerName)
        ownerContainer.addConstraints(format: "V:|-(>=0)-[v0]-2-|", views: feedTime)
        ownerContainer.addConstraints(format: "V:|-0-[v0(22)]-(>=0)-|", views: unreadContainer)
        ownerContainer.addConstraints(format: "H:|-0-[v0]-[v1(40@1)]-(>=0)-[v2(>=22)]-0-|", views: ownerName, feedTime, unreadContainer)
        ownerContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openProfile)))
        
        let feedActivityCounter = makeFeedAcitivityCounter()
        feedActivitySummary = UILabel("are talking about this", Color.darkBlue_white, UIFont.systemFont(ofSize: 12))
        let feedActivityContainer = UIView()
        feedActivityContainer.addSubviews(views: feedActivityCounter, feedActivitySummary)
        feedActivityContainer.addConstraints(format: "V:|-2-[v0]-2-|", views: feedActivityCounter)
        feedActivityContainer.addConstraints(format: "H:|-0-[v0]-4-[v1(>=\(contentView.frame.width/2),<=\(contentView.frame.width))]-(>=0)-|", views: feedActivityCounter, feedActivitySummary)
        feedActivitySummary.centerYAnchor.constraint(equalTo: feedActivityContainer.centerYAnchor).isActive = true
        
        let bottomContainer = UIView()
        let leaveContainer = UIView();
        let actionSeparator = makeSeparator()
        bottomContainer.addSubviews(views: feedActivityContainer, actionSeparator, leaveContainer)
        bottomContainer.addConstraints(format: "V:|-0-[v0]-(\((activity || asHeader) ? 8 : 0))-[v1(1)]-(\((activity || asHeader) ? 8 : 0))-[v2]-0-|", views: feedActivityContainer, actionSeparator, leaveContainer)
        bottomContainer.constrain(type: .horizontalFill, feedActivityContainer, leaveContainer, actionSeparator)
        actionSeparator.isHidden = true
        if activity || asHeader {
            actionSeparator.isHidden = false
            let leaveButton = UIButton("Leave", font: UIFont.systemFont(ofSize: 12, weight: .bold), image: UIImage(named: "cancel")?.resize(CGSize(width: 8, height: 8)))
            leaveButton.backgroundColor = Color.red
            leaveButton.addTarget(self, action: #selector(doLeave), for: .touchUpInside)
            
            statusText = UILabel("Joined 2 mins ago", Color.darkBlue_white, UIFont.systemFont(ofSize: 12))
            let mutable = NSMutableAttributedString()
            mutable.normal("Joined ")
            mutable.bold(Date.time(since: Date()), size: 12, weight: UIFont.Weight.heavy)
            mutable.normal(" ago")
            statusText.attributedText = mutable
            leaveContainer.addSubviews(views: statusText, leaveButton)
            leaveContainer.constrain(type: .verticalFill, statusText, leaveButton)
            leaveContainer.addConstraints(format: "H:|-0-[v0]-(>=0)-[v1]-0-|", views: statusText, leaveButton)
        }
        
        let bodyContainer = UIView()
        bodyContainer.addSubviews(views: ownerContainer, ownerUsername, feedBody, bottomContainer)
        
        if asHeader {
            bodyContainer.add().vertical(16).view(ownerContainer).gap(0).view(ownerUsername).gap(16).view(feedBody).gap(8).view(bottomContainer).end(8)
            bodyContainer.add().horizontal(-52).view(feedBody).end(0)
            bodyContainer.add().horizontal(-52).view(bottomContainer).end(0)
        }else {
            bodyContainer.add().vertical(16).view(ownerContainer).gap(0).view(ownerUsername).gap(4).view(feedBody).gap(8).view(bottomContainer).end(8)
            bodyContainer.add().horizontal(0).view(feedBody).end(0)
            bodyContainer.add().horizontal(0).view(bottomContainer).end(0)
        }
        bodyContainer.constrain(type: .horizontalFill, ownerContainer, ownerUsername)
        
        let feedContainer = UIView()
        feedContainer.addSubviews(views: ownerImage, bodyContainer)
        feedContainer.addConstraints(format: "V:|-16-[v0(40)]-(>=0)-|", views: ownerImage)
        feedContainer.addConstraints(format: "V:|-0-[v0]-8-|", views: bodyContainer)
        feedContainer.addConstraints(format: "H:|-0-[v0(40)]-12-[v1]-0-|", views: ownerImage, bodyContainer)
        
        self.separator = UIView()
        self.separator.backgroundColor = Color.separatorBackground
        
        self.contentView.addSubviews(views: feedContainer, self.separator)
        self.contentView.constrain(type: .horizontalFill, feedContainer, margin: 16)
        self.contentView.constrain(type: .horizontalFill, self.separator)
        self.contentView.addConstraints(format: "V:|-0-[v0]-2-[v1(1)]-(\(asHeader ? 24 : 0))-|", views: feedContainer, self.separator)
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = Color.background
    }
    
    func setup(_ broadcast: Broadcast) {
        self.broadcast = broadcast
        if asHeader {
            feedText.font = UIFont.systemFont(ofSize: 20)
        }
        if let user = broadcast.user {
            if (user.profile_photo != nil) {
                ownerImage.download(link: user.profile_photo!, contentMode: .scaleAspectFill)
            }
            ownerName.text = user.name
            ownerUsername.text = "@" + user.username!
        }
        feedText.text = broadcast.body
        feedTime.text = Date.time(since: broadcast.created!) + " ago"
        peopleCount.text = broadcast.people == 1 ? "\(broadcast.people) person" : "\(broadcast.people) people"
        feedActivitySummary.text = broadcast.people == 1 ? " is talking about this" : " are talking about this"
        if activity {
            if (broadcast.unread != 0) && broadcast.unread > 0 {
                unreadCount.text = "\(broadcast.unread)"
                unreadContainer.isHidden = false
            }else {
                unreadContainer.isHidden = true
            }
        }
        if statusText != nil {
            let mutable = NSMutableAttributedString()
            mutable.normal("Joined ")
            mutable.bold(Date.time(since: broadcast.joined ?? Date()), size: 12, weight: UIFont.Weight.heavy)
            mutable.normal(" ago")
            statusText.attributedText = mutable
        }
        
        if hasMedia {
            feedImage.download(link: Constants.S3Addr + broadcast.media!, sizeCb: { [self] image in
                let w = image.size.width
                let h = image.size.height
                let adjRatio = w > h ? (winW / w) : ((winH * 0.42) / h)
                let adjH = adjRatio * h
                for c in (feedImage.superview?.constraints)! {
                    if (c.firstItem as? UIImageView) == feedImage {
                        if c.firstAttribute == .height {
                            c.constant = adjH
                        }
                    }
                }
            })
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeOwnerImage() -> UIImageView {
        ownerImage = UIImageView(image: UIImage(named: "profile_background"))
        ownerImage.layer.cornerRadius = 8
        ownerImage.clipsToBounds = true
        return ownerImage
    }
    
    func makeFeedAcitivityCounter() -> UIView {
        let container = UIView()
        container.backgroundColor = Color.darkBlue_white
        container.layer.cornerRadius = 8
        peopleCount = UILabel()
        peopleCount.font = UIFont.boldSystemFont(ofSize: 10)
        peopleCount.textColor = UIColor.systemBackground
        peopleCount.text = "2.3k People"
        container.addSubview(peopleCount)
        container.constrain(type: .horizontalFill, peopleCount, margin: 6)
        container.constrain(type: .verticalFill, peopleCount, margin: 2)
        return container
    }
    
    func activityBadge() -> UIView {
        let container = UIView()
        container.backgroundColor = Color.darkBlue_white
        container.layer.cornerRadius = 11
        unreadCount = UILabel()
        unreadCount.font = UIFont.boldSystemFont(ofSize: 16)
        unreadCount.textColor = Color.white_black
        
        container.addSubview(unreadCount)
        container.constrain(type: .horizontalFill, unreadCount, margin: 6)
        container.constrain(type: .verticalFill, unreadCount, margin: 2)
        return container
    }
    
    func hideSeparator() {
        self.separator.isHidden = true
    }
    
    func makeSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = Color.separatorBackground
        return separator
    }
    
    @objc func doLeave() {
        if onLeave != nil {
            onLeave!()
        }
    }
    
    @objc func openProfile() {
        if onOpen != nil {
            onOpen!()
        }
    }
    
}
