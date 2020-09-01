//
//  OwnMessageCell.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 31/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class OwnMessageCell: UITableViewCell {
	
	var message: Message!
	
	init(_ message: Message) {
		super.init(style: .default  , reuseIdentifier: nil)
		self.message = message
		
		let ownerImage = makeOwnerImage()
		let feedBody = UILabel(message.body!, UIColor.white, UIFont.systemFont(ofSize: 16))
		feedBody.numberOfLines = 6
		
		let time = UILabel("2d ago", Color.lightBlue, UIFont.systemFont(ofSize: 12))
		
		let bodyContainer = UIView()
		bodyContainer.backgroundColor = Color.purple
		bodyContainer.layer.cornerRadius = 12
		bodyContainer.clipsToBounds = true
		bodyContainer.addSubviews(views: feedBody)
		bodyContainer.addConstraints(format: "V:|-8-[v0]-8-|", views: feedBody)
		bodyContainer.constrain(type: .horizontalFill, feedBody, margin: 8)
		
		let container = UIView()
		container.addSubviews(views: ownerImage, bodyContainer, time)
		container.addConstraints(format: "V:|-16-[v0(40)]-(>=0)-|", views: ownerImage)
		container.addConstraints(format: "V:|-16-[v0]-8-[v1]-8-|", views: bodyContainer, time)
		container.addConstraints(format: "H:|-0-[v0(40)]-8-[v1]-(>=0)-|", views: ownerImage, bodyContainer)
		container.addConstraints(format: "H:|-48-[v0(>=40)]-48-|", views: time)
		
		self.contentView.addSubview(container)
		self.contentView.backgroundColor = Color.background
		self.contentView.constrain(type: .horizontalFill, container, margin: 48)
		self.contentView.constrain(type: .verticalFill, container)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func makeOwnerImage() -> UIImageView {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.backgroundColor = Color.cyan
		return imageView
	}
	
	
}
