//
//  MessageCell.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 27/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
	
	var message: Message!
	
	init(_ message: Message) {
		super.init(style: .default  , reuseIdentifier: nil)
		self.message = message
		
		let ownerImage = makeOwnerImage()
		let ownerName = UILabel("Simone biles", Color.darkBlue, UIFont.systemFont(ofSize: 17, weight: .bold))
		let feedTime = UILabel("2d ago", Color.darkBlue, UIFont.italicSystemFont(ofSize: 12))
		let feedBody = UILabel(message.body!, Color.textDark, UIFont.systemFont(ofSize: 16))
		feedBody.numberOfLines = 6
		
		let ownerContainer = UIView()
		ownerContainer.addSubviews(views: ownerName, feedTime)
		ownerContainer.addConstraints(format: "V:|-2-[v0(24)]-2-|", views: ownerName)
		ownerContainer.addConstraints(format: "V:|-2-[v0(24)]-2-|", views: feedTime)
		ownerContainer.addConstraints(format: "H:|-0-[v0]-8-[v1(40)]-(>=0)-|", views: ownerName, feedTime)
		
		
		let bodyContainer = UIView()
		bodyContainer.addSubviews(views: ownerContainer, feedBody)
		bodyContainer.addConstraints(format: "V:|-8-[v0]-0-[v1]-8-|", views: ownerContainer, feedBody)
		bodyContainer.constrain(type: .horizontalFill, ownerContainer, feedBody)
		
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
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	func makeOwnerImage() -> UIImageView {
		let imageView = UIImageView()
		imageView.layer.cornerRadius = 12
		imageView.clipsToBounds = true
		imageView.backgroundColor = Color.red
		return imageView
	}
	
	
}
