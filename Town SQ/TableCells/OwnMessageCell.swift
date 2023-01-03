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
    var feedBody: UILabel!
	
	func start() {
		let ownerImage = makeOwnerImage()
        feedBody = UILabel("", Color.black_white, UIFont.systemFont(ofSize: 16))
		feedBody.numberOfLines = 6
		
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
		
		self.contentView.addSubview(container)
		self.contentView.backgroundColor = Color.background
		self.contentView.constrain(type: .horizontalFill, container, margin: 16)
		self.contentView.constrain(type: .verticalFill, container)
	}
    
    func build(_ message: Message) {
        self.message = message
        feedBody.text = message.body!
    }
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        start()
    }
	
    func makeOwnerImage() -> UIImageView {
        let imageView = UIImageView(link: "https://images.ctfassets.net/sc7uy4u0eewy/LPEpShMYorRpDnv0TU720/e279146d5feac47133ff1c1b0818752b/emil-pakarklis.jpg", contentMode: .scaleAspectFill)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }
	
	
}
