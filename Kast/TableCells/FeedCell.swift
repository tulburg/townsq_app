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
    
    init(_ feed: String) {
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
        
        let ownerContainer = UIView()
        ownerContainer.addSubviews(views: ownerName, feedTime)
        ownerContainer.addConstraints(format: "V:|-0-[v0]-0-|", views: ownerName)
        ownerContainer.addConstraints(format: "V:|-(>=0)-[v0]-2-|", views: feedTime)
        ownerContainer.addConstraints(format: "H:|-0-[v0]-[v1(40@1)]-(>=0)-|", views: ownerName, feedTime)
        
        let feedActivityCounter = makeFeedAcitivityCounter()
        let feedActivitySummary = UILabel("are talking about this", Color.darkBlue_white, UIFont.systemFont(ofSize: 12))
        let feedActivityContainer = UIView()
        feedActivityContainer.addSubviews(views: feedActivityCounter, feedActivitySummary)
        feedActivityContainer.addConstraints(format: "V:|-2-[v0]-2-|", views: feedActivityCounter)
        feedActivityContainer.addConstraints(format: "H:|-0-[v0]-4-[v1(>=\(contentView.frame.width/2),<=\(contentView.frame.width))]-0-|", views: feedActivityCounter, feedActivitySummary)
        feedActivitySummary.centerYAnchor.constraint(equalTo: feedActivityContainer.centerYAnchor).isActive = true
        
        
        let bodyContainer = UIView()
        bodyContainer.addSubviews(views: ownerContainer, ownerUsername, feedBody, feedActivityContainer)
        bodyContainer.addConstraints(format: "V:|-16-[v0]-0-[v1]-4-[v2]-8-[v3]-8-|", views: ownerContainer, ownerUsername, feedBody, feedActivityContainer)
        bodyContainer.constrain(type: .horizontalFill, ownerContainer, ownerUsername, feedBody, feedActivityContainer)
        
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
    
    func hideSeparator() {
        self.separator.isHidden = true
    }
    
    
}
