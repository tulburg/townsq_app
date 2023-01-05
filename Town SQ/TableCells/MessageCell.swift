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
    var separator: UIView!
    
    var upvote: UIImageView!
    var downvote: UIImageView!
    var vote: UILabel!
    
    var onVoteChange: ((_ vote: Int) -> Void)? = nil
    
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
        
        upvote = UIImageView(image: UIImage(systemName: "shift.fill"))
        upvote.contentMode = .center
        upvote.tintColor = Color.backgroundDark
        upvote.isUserInteractionEnabled = true
        upvote.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(upvoteFn)))
        downvote = UIImageView(image: UIImage(systemName: "shift.fill"))
        downvote.transform = CGAffineTransform(translationX: 0, y: 0).rotated(by: 3.14)
        downvote.tintColor = Color.backgroundDark
        downvote.contentMode = .center
        downvote.isUserInteractionEnabled = true
        downvote.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(downvoteFn)))
        vote = UILabel("-", Color.gray, UIFont.systemFont(ofSize: 16))
        let voteContainer = UIView()
        voteContainer.add().horizontal(0).view(upvote, 40).gap(4).view(vote).gap(4).view(downvote, 40).end(0)
        voteContainer.constrain(type: .verticalFill, downvote, vote, upvote)
        
        let nameGroup = UIView()
        nameGroup.add().vertical(0).view(ownerContainer).gap(-2).view(ownerUsername).end(8)
        nameGroup.constrain(type: .horizontalFill, ownerContainer, ownerUsername)
        
        let topContainer = UIView()
        topContainer.add().horizontal(0).view(nameGroup).gap(">=0").view(voteContainer).end(0)
        topContainer.constrain(type: .verticalFill, nameGroup, voteContainer)
        
		
		let bodyContainer = UIView()
        bodyContainer.add().vertical(8).view(topContainer).gap(0).view(feedBody).end(8)
        bodyContainer.constrain(type: .horizontalFill, topContainer, feedBody)
		
		let container = UIView()
		container.addSubviews(views: ownerImage, bodyContainer)
		container.addConstraints(format: "V:|-16-[v0(40)]-(>=0)-|", views: ownerImage)
		container.addConstraints(format: "V:|-0-[v0]-8-|", views: bodyContainer)
		container.addConstraints(format: "H:|-0-[v0(40)]-8-[v1]-0-|", views: ownerImage, bodyContainer)
		
        separator = UIView()
        separator.backgroundColor = Color.messageSeparator
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
        ownerName.text = comment.user?.name ?? ""
        ownerUsername.text = "@" + (comment.user?.username ?? "")
        feedTime.text = Date.time(since: comment.created!) + " ago"
        let estVote = comment.vote + comment.user_vote
        upvote.tintColor = Color.backgroundDark
        downvote.tintColor = Color.backgroundDark
        if estVote == 0 {
            vote.text = "-"
        }else {
            vote.text = "\(estVote)"
        }
        if comment.user_vote == 1 {
            upvote.tintColor = Color.purple
        }
        if comment.user_vote == -1 {
            downvote.tintColor = Color.red
        }
    }
    
    func hideSeparator() {
        separator.isHidden = true
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
	
    @objc func downvoteFn() {
        if comment.user_vote == 1 {
            return
        }
        if comment.user_vote == -1 {
            voteFn(1)
        }else {
            voteFn(-1)
        }
    }
    
    @objc func upvoteFn() {
        if comment.user_vote == -1 {
            return
        }
        if comment.user_vote == 1 {
            voteFn(-1)
        }else {
            voteFn(1)
        }
    }
    
    func voteFn(_ vote: Int) {
        guard
            comment.user_vote != vote
        else { return }
        comment.user_vote = comment.user_vote + Int16(vote)
        DB.shared.save()
        if (onVoteChange != nil) {
            onVoteChange!(vote)
        }
    }
}
