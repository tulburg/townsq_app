//
//  SettingsViewController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	
	var settings: [Setting] = []
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	init() {
		super.init(nibName: nil, bundle: nil)
		let tabImage = UIImage(named: "settings")
		tabImage?.withRenderingMode(.alwaysTemplate)
		self.tabBarItem = UITabBarItem(title: "", image: tabImage, tag: 3)
		
		[1,2,3,4,5].forEach({ i in
			self.settings.append(Setting("Post ordering", type: .Boolean, description: "Choose the order you want your post"))
		})
		
		let tableView = UITableView()
		tableView.estimatedRowHeight = UITableView.automaticDimension
		tableView.tableFooterView = UIView(frame: CGRect.zero)
		tableView.backgroundColor = Color.background
		tableView.dataSource = self
		tableView.delegate = self
		
		self.view.addSubview(tableView)
		self.view.constrain(type: .horizontalFill, tableView)
		self.view.constrain(type: .verticalFill, tableView)
		
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = Color.background
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return settings.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = SettingsTableCell(settings[indexPath.row])
		
		return cell
	}
	
}


class SettingsTableCell: UITableViewCell {
	
	init(_ setting: Setting) {
		super.init(style: .default, reuseIdentifier: "settings-tableview-cell")
		
		let title = UILabel(setting.title, Color.darkBlue, UIFont.boldSystemFont(ofSize: 18))
		let description = UILabel(setting.description, Color.textBlue, UIFont.systemFont(ofSize: 15))
		
	  	let titleContainer = UIView()
		titleContainer.addSubviews(views: title, description)
		titleContainer.addConstraints(format: "V:|-4-[v0]-(-2)-[v1]-(>=0)-|", views: title, description)
		titleContainer.constrain(type: .horizontalFill, title, description)
		
		let controlContainer = UIView()
		let switchControl = UISwitch()
		controlContainer.addSubviews(views: switchControl)
		
		let container = UIView()
		container.addSubviews(views: titleContainer, controlContainer)
		container.constrain(type: .verticalFill, titleContainer, controlContainer, margin: 8)
		container.addConstraints(format: "H:|-24-[v0]-8-[v1(40)]-24-|", views: titleContainer, controlContainer)
		
		self.contentView.addSubview(container)
		self.contentView.constrain(type: .horizontalFill, container)
		self.contentView.constrain(type: .verticalFill, container)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
}

struct Setting {
	var title: String
	var type: SettingType
	var description: String
	
	init(_ title: String, type: SettingType, description: String) {
		self.title = title
		self.type = type
		self.description = description
	}
}

enum SettingType {
	case Boolean
	case String
	case Number
	case Options
}


