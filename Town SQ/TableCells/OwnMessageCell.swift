//
//  OwnMessageCell.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 31/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class OwnMessageCell: UITableViewCell {
	
	var comment: Comment!
    var feedBody: UILabel!
    var image: UIImageView!
    var separator: UIView!
	
	func start() {
		let ownerImage = makeOwnerImage()
        feedBody = UILabel("", Color.black_white, UIFont.systemFont(ofSize: 16))
		feedBody.numberOfLines = 6
        feedBody.interactions = [UITextInteraction(for: .editable)]
		
		let time = UILabel("2d ago", Color.lightBlue, UIFont.systemFont(ofSize: 12))
		
		let bodyContainer = UIView()
		bodyContainer.backgroundColor = Color.backgroundDark
		bodyContainer.layer.cornerRadius = 8
		bodyContainer.clipsToBounds = true
		bodyContainer.addSubviews(views: feedBody)
		bodyContainer.addConstraints(format: "V:|-8-[v0]-8-|", views: feedBody)
		bodyContainer.constrain(type: .horizontalFill, feedBody, margin: 8)
		
		let container = UIView()
        container.add().vertical(8).view(ownerImage, 40).end(">=0")
        container.add().vertical(8).view(bodyContainer).gap(8).view(time).end(8)
        container.add().horizontal(48).view(bodyContainer).gap(8).view(ownerImage, 40).end(0)
        container.add().horizontal(">=0").view(time).end(50)
		
        separator = UIView()
        separator.backgroundColor = Color.background
		self.contentView.backgroundColor = Color.background
        self.contentView.add().vertical(0).view(container).gap(0).view(separator, 1).end(0)
		self.contentView.constrain(type: .horizontalFill, container, margin: 16)
		self.contentView.constrain(type: .horizontalFill, separator)
	}
    
    func build(_ comment: Comment) {
        self.comment = comment
        feedBody.text = comment.body!
        if comment.user?.profile_photo != nil {
            image.download(link: (comment.user?.profile_photo)!, contentMode: .scaleAspectFill)
        }
    }
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        start()
    }
	
    func makeOwnerImage() -> UIImageView {
        image = UIImageView(image: UIImage(named: "profile_background"))
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }
	
	
}
