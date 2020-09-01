//
//  ProfileViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	var details: [String]!
	var values: [String]!
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	  
	}
	
	
	init() {
		super.init(nibName: nil, bundle: nil)
		let tabImage = UIImage(named: "profile")
		tabImage?.withRenderingMode(.alwaysTemplate)
		self.tabBarItem = UITabBarItem(title: "", image: tabImage, tag: 2)
		
		details = ["Date of birth", "Email address"]
		values = ["17 December", "tulburg@yahoo.com"]
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = Color.background
		
		let profilePhoto = UIImageView(image: UIImage(named: "profile_background"))
		profilePhoto.contentMode = .scaleAspectFit
		profilePhoto.clipsToBounds = true
		profilePhoto.layer.cornerRadius = 36
		let displayName = UILabel("Daye Bosní", Color.darkBlue, UIFont.boldSystemFont(ofSize: 24))
		displayName.textAlignment = .center
		
		let detailsTable = UITableView()
		detailsTable.backgroundColor = Color.background
		detailsTable.rowHeight = UITableView.automaticDimension
		detailsTable.separatorInset = UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 24)
		detailsTable.tableFooterView = UIView(frame: CGRect.zero)
		detailsTable.delegate = self
		detailsTable.dataSource = self
		
		let editButton = UIButton("Change password")
		editButton.backgroundColor = Color.darkBlue
		
		self.view.addSubviews(views: profilePhoto, displayName, detailsTable, editButton)
		self.view.addConstraints(format: "V:|-120-[v0(160)]-16-[v1(28)]-24-[v2(140)]-24-[v3(40)]-(>=0)-|", views: profilePhoto, displayName, detailsTable, editButton)
		self.view.addConstraints(format: "H:|-(>=0)-[v0(160)]-(>=0)-|", views: profilePhoto)
		profilePhoto.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
		self.view.addConstraints(format: "H:|-16-[v0]-16-|", views: displayName)
		self.view.constrain(type: .horizontalFill, detailsTable)
		self.view.addConstraints(format: "H:|-32-[v0(160)]-(>=0)-|", views: editButton)
		
	}
	
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: DetailsTableCell = DetailsTableCell(details[indexPath.row], values[indexPath.row])

		return cell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return details.count
	}
	
	
}

class DetailsTableCell: UITableViewCell {
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	init(_ title: String, _ value: String) {
		super.init(style: .default, reuseIdentifier: "profile_details_table_cell")
		self.contentView.backgroundColor = Color.background
		self.accessoryType = .disclosureIndicator
		
		let titleLabel = UILabel(title, Color.textBlue, UIFont.boldSystemFont(ofSize: 14))
		let valueLabel = UILabel(value, Color.textDark, UIFont.systemFont(ofSize: 18))
		
		let container = UIView()
		container.addSubviews(views: titleLabel, valueLabel)
		container.constrain(type: .horizontalFill, titleLabel, valueLabel, margin: 24)
		container.addConstraints(format: "V:|-8-[v0(14)]-4-[v1(26)]-8-|", views: titleLabel, valueLabel)
		
		self.contentView.addSubviews(views: container)
		self.contentView.addConstraints(format: "V:|-0-[v0(60)]-(>=0)-|", views: container)
		self.contentView.constrain(type: .horizontalFill, container, margin: 4)
		
		if #available(iOS 14.0, *) {
//			self.backgroundConfiguration = .clear()
		} else {
			self.backgroundColor = UIColor.clear
		}
		
	}
	
	
	override func didMoveToSuperview() {

	}
}

