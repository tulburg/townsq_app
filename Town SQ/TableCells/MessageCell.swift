//
//  MessageCell.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 27/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
	
	var comment: Comment!
    var feedBody: UILabel!
    var image: UIImageView!
    var ownerName: UILabel!
    var ownerUsername: UILabel!
    var feedTime: UILabel!
	func start() {
		
		let ownerImage = makeOwnerImage()
        ownerName = UILabel("Simone biles", Color.darkBlue_white, UIFont.systemFont(ofSize: 17, weight: .bold))
        ownerUsername = UILabel("@simone_biles", Color.lightText, UIFont.systemFont(ofSize: 14, weight: .regular))
		feedTime = UILabel("2d ago", Color.darkBlue, UIFont.systemFont(ofSize: 12))
		feedBody = UILabel("", Color.black_white, UIFont.systemFont(ofSize: 16))
		feedBody.numberOfLines = 6
		
		let ownerContainer = UIView()
		ownerContainer.addSubviews(views: ownerName, feedTime)
		ownerContainer.addConstraints(format: "V:|-2-[v0]-2-|", views: ownerName)
		ownerContainer.addConstraints(format: "V:|-2-[v0]-2-|", views: feedTime)
		ownerContainer.addConstraints(format: "H:|-0-[v0]-8-[v1]-(>=0)-|", views: ownerName, feedTime)
		
		let bodyContainer = UIView()
		bodyContainer.addSubviews(views: ownerContainer, feedBody, ownerUsername)
		bodyContainer.addConstraints(format: "V:|-8-[v0]-(-2)-[v1]-6-[v2]-8-|", views: ownerContainer, ownerUsername, feedBody)
		bodyContainer.constrain(type: .horizontalFill, ownerUsername, ownerContainer, feedBody)
		
		let container = UIView()
		container.addSubviews(views: ownerImage, bodyContainer)
		container.addConstraints(format: "V:|-16-[v0(40)]-(>=0)-|", views: ownerImage)
		container.addConstraints(format: "V:|-0-[v0]-8-|", views: bodyContainer)
		container.addConstraints(format: "H:|-0-[v0(40)]-8-[v1]-0-|", views: ownerImage, bodyContainer)
		
		self.contentView.addSubview(container)
		self.contentView.backgroundColor = Color.background
		self.contentView.constrain(type: .horizontalFill, container, margin: 16)
		self.contentView.constrain(type: .verticalFill, container)
		
	}
    
    func build(_ comment: Comment) {
        self.comment = comment
        feedBody.text = comment.body!
        if comment.user?.profile_photo != nil {
            image.download(link: (comment.user?.profile_photo)!, contentMode: .scaleAspectFill)
        }
        ownerName.text = (comment.user?.name)!
        ownerUsername.text = "@" + (comment.user?.username)!
        feedTime.text = Date.time(since: comment.created!) + " ago"
    }
    
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.start()
    }
	
	func makeOwnerImage() -> UIImageView {
        image = UIImageView(image: UIImage(named: "profile_background"))
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
	}
	
	
}
