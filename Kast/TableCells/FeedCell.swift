//
//  FeedCell.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 09/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    var feed: String!
    var separator: UIView!
    
    init(feedText feed: String, _ activity: Int?) {
        super.init(style: .default, reuseIdentifier: .none)
        self.feed = feed
        
        let ownerImage = makeOwnerImage()
        let ownerName = UILabel("Simone biles", Color.darkBlue_white, UIFont.systemFont(ofSize: 17, weight: .bold))
        let ownerUsername = UILabel("@simone", Color.lightText, UIFont.systemFont(ofSize: 14, weight: .regular))
        let feedTime = UILabel("2d ago", Color.darkBlue, UIFont.italicSystemFont(ofSize: 12))
        let feedText = UILabel(feed, Color.black_white, UIFont.systemFont(ofSize: 16))
        feedText.numberOfLines = 6
        let feedImage = UIImageView(link: "https://img5.goodfon.com/wallpaper/nbig/0/63/face-look-beautiful-girl-flowers-field-eyes.jpg", contentMode: .scaleAspectFill)
        feedImage.layer.cornerRadius = 8
        feedImage.clipsToBounds = true
        let feedBody = UIView()
        feedBody.addSubviews(views: feedText, feedImage)
        feedBody.constrain(type: .horizontalFill, feedText, feedImage)
        feedBody.addConstraints(format: "V:|-0-[v0]-16-[v1(220)]-0-|", views: feedText, feedImage)
        
        let activityCounter = activityBadge(activity)
        if activity == nil {
            activityCounter.isHidden = true
        }
        
        let ownerContainer = UIView()
        ownerContainer.addSubviews(views: ownerName, feedTime, activityCounter)
        ownerContainer.addConstraints(format: "V:|-0-[v0]-0-|", views: ownerName)
        ownerContainer.addConstraints(format: "V:|-(>=0)-[v0]-2-|", views: feedTime)
        ownerContainer.addConstraints(format: "V:|-0-[v0(22)]-(>=0)-|", views: activityCounter)
        ownerContainer.addConstraints(format: "H:|-0-[v0]-[v1(40@1)]-(>=0)-[v2(>=22@1)]-0-|", views: ownerName, feedTime, activityCounter)
        
        let feedActivityCounter = makeFeedAcitivityCounter()
        let feedActivitySummary = UILabel("are talking about this", Color.darkBlue_white, UIFont.systemFont(ofSize: 12))
        let feedActivityContainer = UIView()
        feedActivityContainer.addSubviews(views: feedActivityCounter, feedActivitySummary)
        feedActivityContainer.addConstraints(format: "V:|-2-[v0]-2-|", views: feedActivityCounter)
        feedActivityContainer.addConstraints(format: "H:|-0-[v0]-4-[v1(>=\(contentView.frame.width/2),<=\(contentView.frame.width))]-0-|", views: feedActivityCounter, feedActivitySummary)
        feedActivitySummary.centerYAnchor.constraint(equalTo: feedActivityContainer.centerYAnchor).isActive = true
        
        let bottomContainer = UIView()
        let leaveContainer = UIView();
        let actionSeparator = makeSeparator()
        bottomContainer.addSubviews(views: feedActivityContainer, actionSeparator, leaveContainer)
        bottomContainer.addConstraints(format: "V:|-0-[v0]-(\(activity != nil ? 8 : 0))-[v1(1)]-(\(activity != nil ? 8 : 0))-[v2]-0-|", views: feedActivityContainer, actionSeparator, leaveContainer)
        bottomContainer.constrain(type: .horizontalFill, feedActivityContainer, leaveContainer, actionSeparator)
        actionSeparator.isHidden = true
        if activity != nil {
            actionSeparator.isHidden = false
            let leaveButton = UIButton("Leave", font: UIFont.systemFont(ofSize: 12, weight: .bold), image: UIImage(named: "cancel")?.resize(CGSize(width: 8, height: 8)))
            leaveButton.backgroundColor = Color.red
            
            let statusText = UILabel("Joined 2 mins ago", Color.darkBlue_white, UIFont.systemFont(ofSize: 12))
            let mutable = NSMutableAttributedString()
            mutable.normal("Joined ")
            mutable.bold("2 mins", size: 12, weight: UIFont.Weight.heavy)
            mutable.normal(" ago")
            statusText.attributedText = mutable
            leaveContainer.addSubviews(views: statusText, leaveButton)
            leaveContainer.constrain(type: .verticalFill, statusText, leaveButton)
            leaveContainer.addConstraints(format: "H:|-0-[v0]-(>=0)-[v1]-0-|", views: statusText, leaveButton)
        }
        
        let bodyContainer = UIView()
        bodyContainer.addSubviews(views: ownerContainer, ownerUsername, feedBody, bottomContainer)
        bodyContainer.addConstraints(format: "V:|-16-[v0]-0-[v1]-4-[v2]-8-[v3]-8-|", views: ownerContainer, ownerUsername, feedBody, bottomContainer)
        bodyContainer.constrain(type: .horizontalFill, ownerContainer, ownerUsername, feedBody, bottomContainer)
        
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
        self.contentView.addConstraints(format: "V:|-0-[v0]-2-[v1(1)]-0-|", views: feedContainer, self.separator)
        
        
        
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = Color.background
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeOwnerImage() -> UIImageView {
        let imageView = UIImageView(link: "https://imgc.artprintimages.com/img/print/young-girl-trying-to-determine-which-lipstick-color-will-look-right-with-her-complextion_u-l-p75yfe0.jpg", contentMode: .scaleAspectFill)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }
    
    func makeFeedAcitivityCounter() -> UIView {
        let container = UIView()
        container.backgroundColor = Color.darkBlue_white
        container.layer.cornerRadius = 8
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = UIColor.systemBackground
        label.text = "2.3k People"
        container.addSubview(label)
        container.constrain(type: .horizontalFill, label, margin: 6)
        container.constrain(type: .verticalFill, label, margin: 2)
        return container
    }
    
    func activityBadge(_ count: Int?) -> UIView {
        let container = UIView()
        container.backgroundColor = Color.darkBlue_white
        container.layer.cornerRadius = 11
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = Color.white_black
        if count != nil {
            label.text = "\(count!)"
        } else {
            label.text = "0"
        }
        
        container.addSubview(label)
        container.constrain(type: .horizontalFill, label, margin: 6)
        container.constrain(type: .verticalFill, label, margin: 2)
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
    
    
}
