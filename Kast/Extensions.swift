//
//  Extensions.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

extension UIView {
	
	func addConstraints(format: String, views: UIView...) {
		var viewDict = [String: Any]()
		for(index, view) in views.enumerated() {
			view.translatesAutoresizingMaskIntoConstraints = false
			let key = "v\(index)"
			viewDict[key] = view
		}
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewDict))
	}
	
	func constrain(type: ConstraintType, _ views: UIView..., margin: Float = 0) {
		if type == .horizontalFill {
			for view in views {
				addConstraints(format: "H:|-\(margin)-[v0]-\(margin)-|", views: view)
			}
		}else if type == .verticalFill {
			for view in views {
				addConstraints(format: "V:|-\(margin)-[v0]-\(margin)-|", views: view)
			}
		}
	}
	
	func showIndicator(size: Int, color: UIColor) {
		let loadIndicator = UIActivityIndicatorView()
		loadIndicator.style = .large
		loadIndicator.color = color
		loadIndicator.startAnimating()
		var dimen = 20
		if size == 2 { dimen = 40 }
		if size == 3 { dimen = 60 }
		if size == 4 { dimen = 80 }
		if size == 5 { dimen = 100 }
		addSubview(loadIndicator)
		addConstraints(format: "V:|-(>=0)-[v0(\(dimen))]-(>=0)-|", views: loadIndicator)
		addConstraints(format: "H:|-(>=0)-[v0(\(dimen))]-(>=0)-|", views: loadIndicator)
		loadIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		loadIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
	}
	
	func hideIndicator() {
		for v: UIView in subviews {
			if v is UIActivityIndicatorView {
				v.removeFromSuperview()
			}
		}
	}
	
	func addSubviews(views: UIView...) {
		for view in views {
			addSubview(view)
		}
	}
	
	func scale(by scale: CGFloat) {
		self.contentScaleFactor = scale
		for subview in self.subviews {
			subview.scale(by: scale)
		}
	}
	
	func getImage(scale: CGFloat? = nil) -> UIImage? {
		let bounds = self.bounds
		UIGraphicsBeginImageContext(bounds.size)
		if let context = UIGraphicsGetCurrentContext()  {
			self.layer.render(in: context)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return image
		}
		return nil
	}
}

extension UIColor {
	convenience init(hex: Int) {
		self.init(red: CGFloat((hex >> 16) & 0xff) / 255.0, green: CGFloat((hex >> 8) & 0xff) / 255.0, blue: CGFloat(hex & 0xff) / 255.0, alpha: 1)
	}
}

extension UILabel {
	convenience init(_ text: String, _ color: UIColor?, _ font: UIFont?) {
		self.init()
		self.text = text
		self.font = UIFont.systemFont(ofSize: 12)
		if color != nil {
			self.textColor = color!
		}
		if font != nil {
			self.font = font
		}
	}
}

extension Data {
	func toDictionary() -> [Dictionary<String, Any>] {
		do {
			return try JSONSerialization.jsonObject(with: self, options: []) as! [Dictionary<String, Any>]
		} catch {
			print(error.localizedDescription)
			return [[:]]
		}
	}
	func toJsonArray() -> [Any]? {
		do {
			return try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [Any]
		} catch {
			print(error.localizedDescription)
		}
		return nil
	}
}

enum ConstraintType {
	case horizontalFill
	case verticalFill
}

extension UIImage {
	
	func resize(_ size: CGSize) -> UIImage{
		UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
		
		self.draw(in: CGRect(x:0, y:0, width:size.width, height:size.height))
		let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext();
		return newImage
	}
	
	func rotate(_ deg: CGFloat ) -> UIImage {
		let rotatedSize = CGRect(origin: .zero, size: size)
			.applying(CGAffineTransform(rotationAngle: CGFloat(deg)))
			.integral.size
		UIGraphicsBeginImageContext(rotatedSize)
		if let context = UIGraphicsGetCurrentContext() {
			let origin = CGPoint(x: rotatedSize.width / 2.0,
								 y: rotatedSize.height / 2.0)
			context.translateBy(x: origin.x, y: origin.y)
			context.rotate(by: deg)
			draw(in: CGRect(x: -origin.y, y: -origin.x,
							width: size.width, height: size.height))
			let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return rotatedImage ?? self
		}
		
		return self
		
	}
}

extension Encodable {
	var dictionary: [String: Any] {
		return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
	}
	var nsDictionary: NSDictionary {
		return dictionary as NSDictionary
	}
}

extension UIImageView {
	func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
		contentMode = mode
		URLSession.shared.dataTask(with: url) { (data, response, error) in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
				else { return }
			DispatchQueue.main.async() { () -> Void in
				self.image = image
			}
		}.resume()
	}
	func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
		guard let url = URL(string: link) else { return }
		downloadedFrom(url: url, contentMode: mode)
	}
}

extension UIButton {
	convenience init(_ text: String, font: UIFont? = UIFont.systemFont(ofSize: 17), image: UIImage? = UIImage()) {
		self.init()
		self.setTitle(text, for: .normal)
		self.titleLabel?.font = font
		if image != nil {
			self.setImage(image, for: .normal)
		}
		
		self.backgroundColor = Color.purple
		self.titleLabel?.textColor = UIColor.white
		self.layer.cornerRadius = 12
		self.layer.shadowColor = Color.buttonShadow.cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: 6)
		self.layer.shadowRadius = 10
		self.layer.shadowOpacity = 0.56
	}
	
	func rightImage() {
		self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
	}
}

extension UITextField {
	convenience init(_ hint: String) {
		self.init()
		self.placeholder = hint;
		self.backgroundColor = Color.formInput
		self.textColor = UIColor.secondaryLabel
		self.clipsToBounds = true
		self.layer.cornerRadius = 12
		self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 20))
		self.leftViewRect(forBounds: CGRect(x: 0, y: 0, width: 16, height: 20))
		self.leftViewMode = .always
	}
}

extension UITableView {
	convenience init(background: UIColor, delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
		self.init()
		self.estimatedRowHeight = UITableView.automaticDimension
		self.tableFooterView = UIView(frame: CGRect.zero)
		self.separatorStyle = .none
	  	self.backgroundColor = background
		self.delegate = delegate
		self.dataSource = dataSource
	}
}

extension UINavigationController {
	
	public func presentTransparentNavigationBar() {
		navigationBar.setBackgroundImage(UIImage(), for:UIBarMetrics.default)
		navigationBar.shadowImage = UIImage()
	}
	
	public func hideTransparentNavigationBar() {
		//        setNavigationBarHidden(true, animated:false)
		navigationBar.setBackgroundImage(UINavigationBar.appearance().backgroundImage(for: UIBarMetrics.default), for:UIBarMetrics.default)
		navigationBar.shadowImage = UINavigationBar.appearance().shadowImage
	}
	
	func configureNavigationBar(withTitle title: String, largeTitleColor: UIColor, tintColor: UIColor, navBarColor: UIColor, smallTitleColorWhenScrolling: UIUserInterfaceStyle, prefersLargeTitles: Bool) {
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.largeTitleTextAttributes = [.foregroundColor: largeTitleColor]
		appearance.backgroundColor = navBarColor
		navigationController?.navigationBar.standardAppearance = appearance
		navigationController?.navigationBar.compactAppearance = appearance
		navigationController?.navigationBar.scrollEdgeAppearance = appearance
		navigationController?.navigationBar.prefersLargeTitles = prefersLargeTitles
		navigationController?.title = title
		navigationController?.navigationBar.tintColor = tintColor
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.navigationBar.overrideUserInterfaceStyle = smallTitleColorWhenScrolling
	}
	
	func changeBackgroundColor(_ color: UIColor) {
		let appearance = UINavigationBarAppearance()
		appearance.configureWithOpaqueBackground()
		appearance.backgroundColor = color
		appearance.shadowImage = UIImage(named: "bar")?.resize(CGSize(width: self.view.frame.width, height: 3))
		self.navigationBar.standardAppearance = appearance
		self.navigationBar.compactAppearance = appearance
		self.navigationBar.scrollEdgeAppearance = appearance
	}
}

extension NSMutableData {
	
	func appendString(_ value : String) {
		let data = value.data(using: String.Encoding.utf8, allowLossyConversion: true)
		append(data!)
	}
}

extension NSMutableAttributedString {
	@discardableResult func bold(_ text:String, size: CGFloat) -> NSMutableAttributedString {
		let attrs:[NSAttributedString.Key: Any] = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: size)]
		let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
		self.append(boldString)
		return self
	}
	
	@discardableResult func boldUnderline(_ text:String, size: CGFloat) -> NSMutableAttributedString {
		let attrs:[NSAttributedString.Key: Any] = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: size), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
		let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
		self.append(boldString)
		return self
	}
	
	@discardableResult func normal(_ text:String)->NSMutableAttributedString {
		let normal =  NSAttributedString(string: text)
		self.append(normal)
		return self
	}
}


/***********************/

struct Color {
	
	static let purple = UIColor(hex: 0x8A609C)
	static let cyan = UIColor(hex: 0x5CCCD0)
	static let red = UIColor(hex: 0xD65745)
	static let darkBlue = UIColor(hex: 0x465A6F)
	static let lightBlue = UIColor(hex: 0x627F9D)
	
	static func create(_ light: UIColor, dark: UIColor) -> UIColor {
		return UIColor(dynamicProvider: { trait in
			return trait.userInterfaceStyle == .dark ? dark : light
		})
	}
	
	static let textGray = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0xC1C1C1) : UIColor(hex: 0x4E4E4E)
	})
	static let textDark = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0xC1C1C1) : UIColor(hex: 0x4E4E4E)
	})
	static let textBlue = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x627F9D) : UIColor(hex: 0x465A6F)
	})
	
	static let title = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor.white : purple
	})
	
	static let background = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x141414) : UIColor.white
	})
	
	/// Tab icons color
	static let editTabLight = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0xCEF0F1) : UIColor(hex: 0x355758)
	})
	static let editTab = cyan
	static let homeTabLight = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x53405C) : UIColor(hex: 0xDBCEE0)
	})
	static let homeTab = purple
	static let profileTabLight = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x4F302B) : UIColor(hex: 0xF2CBC6)
	})
	static let profileTab = red
	static let settingsTabLight = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x2C3136) : UIColor(hex: 0xC6CCD3)
	})
	static let settingsTab = darkBlue
	
	static let separator = UIColor(hex: 0xE1E1E1)
	
	static let formTitle = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor(hex: 0x686868)
	})
	static let formDescription = UIColor(hex: 0xAEAEAE)
	static let formPlaceholder = UIColor(hex: 0xB9BBBB)
	static let formInput = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x000000) : UIColor(hex: 0xEFF2F2)
	})
	
	static let buttonShadow = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x202020) : UIColor(hex: 0x8A609C)
	})
	
	static let separatorBackground = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x313131) : UIColor.white
	})
	
	static let blueLabel = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x627F9D) : Color.darkBlue
	})
	
	static let navigationItem = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor.white : Color.purple
	})
	
	static let separatorLabel = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
	})
}

func Localize(_ string: String) -> String {
	return NSLocalizedString(string, comment: "")
}
