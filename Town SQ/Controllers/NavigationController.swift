//
//  NavigationController.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    var appearance: UINavigationBarAppearance!
	
	override init(rootViewController: UIViewController) {
		super.init(rootViewController: rootViewController)
		self.view.backgroundColor = Color.background
		
		self.navigationItem.backBarButtonItem?.tintColor = Color.navigationItem
		
		appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.largeTitleTextAttributes = [.foregroundColor: Color.black_white]
		appearance.backgroundColor = Color.background
		appearance.titleTextAttributes = [
			NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17),
			NSAttributedString.Key.foregroundColor: Color.black_white
		]
		self.navigationBar.standardAppearance = appearance
		self.navigationBar.compactAppearance = appearance
		self.navigationBar.scrollEdgeAppearance = appearance
		self.navigationBar.prefersLargeTitles = false
		self.navigationBar.tintColor = Color.black_white
		self.navigationBar.isTranslucent = false

	}
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
    func hideTopBar() {
        appearance.shadowImage = UIImage(color: UIColor.clear)
        appearance.backgroundColor = UIColor.clear
        appearance.backgroundImage = UIImage()
        appearance.configureWithTransparentBackground()
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.isTranslucent = true
    }
    
    func showTopBar() {
        appearance.configureWithOpaqueBackground()
//        appearance.shadowImage = UINavigationBar.appearance().shadowImage
        appearance.backgroundColor = Color.background
//        appearance.backgroundImage = UINavigationBar.appearance().backgroundImage(for: .default)
        
        self.navigationBar.standardAppearance = appearance
        self.navigationBar.compactAppearance = appearance
        self.navigationBar.scrollEdgeAppearance = appearance
        self.navigationBar.isTranslucent = false
    }
}
