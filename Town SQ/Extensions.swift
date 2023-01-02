//
//  Extensions.swift
//  Kast
//
//  Created by Tolu Oluwagbemi on 06/07/2020.
//  Copyright © 2020 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class ConstrainChain {
    var chain: String = ""
    var host: UIView!
    var viewIndex: Int = 0
    var subviews: [UIView] = []
    init(_ host: UIView) {
        self.host = host
    }
    
    func vertical(_ startMargin: CGFloat) -> ConstrainChain {
        chain += "V:|-(\(startMargin))-"
        return self
    }
    
    func vertical(_ startMargin: String) -> ConstrainChain {
        chain += "V:|-(\(startMargin))-"
        return self
    }
    func horizontal(_ startMargin: CGFloat) -> ConstrainChain {
        chain += "H:|-(\(startMargin))-"
        return self
    }
    
    func horizontal(_ startMargin: String) -> ConstrainChain {
        chain += "H:|-(\(startMargin))-"
        return self
    }
    
    func view(_ subView: UIView) -> ConstrainChain {
        if subviews.firstIndex(of: subView) == nil {
            host.addSubview(subView)
            subviews.append(subView)
        }
        chain += "[v\(viewIndex)]-"
        viewIndex += 1
        return self
    }
    func view(_ subView: UIView, _ size: CGFloat) -> ConstrainChain {
        if subviews.firstIndex(of: subView) == nil {
            host.addSubview(subView)
            subviews.append(subView)
        }
        chain += "[v\(viewIndex)(\(size))]-"
        viewIndex += 1
        return self
    }
    func view(_ subView: UIView, _ size: String) -> ConstrainChain {
        if subviews.firstIndex(of: subView) == nil {
            host.addSubview(subView)
            subviews.append(subView)
        }
        chain += "[v\(viewIndex)(\(size))]-"
        viewIndex += 1
        return self
    }
    func gap(_ margin: CGFloat) -> ConstrainChain {
        chain += "(\(margin))-"
        return self
    }
    func gap(_ margin: String) -> ConstrainChain {
        chain += "(\(margin))-"
        return self
    }
    
    func end(_ margin: CGFloat) {
        chain += "(\(margin))-|"
        host.addConstraints(format: chain, views: subviews)
    }
    func end(_ margin: String) {
        chain += "(\(margin))-|"
        host.addConstraints(format: chain, views: subviews)
    }
}

extension UIView {
	
	func addConstraints(format: String, views: UIView...) {
		addConstraints(format: format, views: views)
	}
    
    func addConstraints(format: String, views: [UIView]) {
        var viewDict = [String: Any]()
        for(index, view) in views.enumerated() {
            view.translatesAutoresizingMaskIntoConstraints = false
            let key = "v\(index)"
            viewDict[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewDict))
    }
	
	func constrain(type: ConstraintType, _ views: UIView..., margin: Float = 0) {
        switch type {
        case .horizontalFill:
            for view in views {
                addConstraints(format: "H:|-\(margin)-[v0]-\(margin)-|", views: view)
            }
        case .verticalFill:
            for view in views {
                addConstraints(format: "V:|-\(margin)-[v0]-\(margin)-|", views: view)
            }
        case .verticalCenter:
            for view in views {
                addConstraints(format: "V:|-(>=\(margin))-[v0]-(>=\(margin))-|", views: view)
                view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            }
        case .horizontalCenter:
            for view in views {
                addConstraints(format: "H:|-(>=\(margin))-[v0]-(>=\(margin))-|", views: view)
                view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            }
        }
	}
    
    func add() -> ConstrainChain {
        return ConstrainChain(self)
    }
	
    func showIndicator(size: UIActivityIndicatorView.Style, color: UIColor, background: UIColor) {
        let loadIndicator = UIActivityIndicatorView()
        loadIndicator.style = size
        loadIndicator.color = color
        
        let wrapper = UIView()
        wrapper.tag = 0x77234
        wrapper.backgroundColor = background
        wrapper.addSubview(loadIndicator)
        wrapper.constrain(type: .verticalCenter, loadIndicator)
        wrapper.constrain(type: .horizontalCenter, loadIndicator)
        wrapper.isUserInteractionEnabled = true
        wrapper.addGestureRecognizer(UITapGestureRecognizer())
        wrapper.layer.cornerRadius = layer.cornerRadius
        
        addSubview(wrapper)
        add().vertical(0).view(wrapper).end(0)
        add().horizontal(0).view(wrapper).end(0)
		loadIndicator.startAnimating()
	}
    
    func showIndicator(size: UIActivityIndicatorView.Style, color: UIColor) {
        showIndicator(size: size, color: color, background: Color.create(0xFFFFFF, dark: 0x000000).withAlphaComponent(size == .large ? 0.6 : 0.9))
    }
	
	func hideIndicator() {
		for v: UIView in subviews {
            if v.tag == 0x77234 {
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
    
    func debugLines(color: UIColor?) {
        self.layer.borderWidth = 1
        self.layer.borderColor = color?.cgColor
    }
    func debugLines() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
    }
	
	func getImage(scale: CGFloat? = nil) -> UIImage? {
		let bounds = self.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 3.0)
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
	func toDictionary() -> Dictionary<String, Any> {
		do {
			return try JSONSerialization.jsonObject(with: self, options: []) as! Dictionary<String, Any>
		} catch {
			print(error.localizedDescription)
			return [:]
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
    case horizontalCenter
    case verticalCenter
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
	
	convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
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
	convenience init(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        self.init()
		contentMode = mode
        guard let url = URL(string: link) else { return }
        if let path = ImageCache.shared().fetch(url: url) {
            let image = UIImage(contentsOfFile: path)
            self.image = image
        }else {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else { return }
                ImageCache.shared().set(data: image.jpegData(compressionQuality: 1)!, url: url, completion: nil)
                DispatchQueue.main.async() { () -> Void in
                    self.image = image
                }
            }.resume()
        }
	}
    
    func asButton() {
        contentMode = .center
        layer.borderWidth = 1
        layer.borderColor = Color.separator.cgColor
        layer.cornerRadius = 15
    }

}

extension UIButton {
	convenience init(_ text: String, font: UIFont? = UIFont.systemFont(ofSize: 17), image: UIImage? = UIImage()) {
		self.init()
		self.setTitle(text, for: .normal)
		self.titleLabel?.font = font
		if image != nil {
			self.setImage(image, for: .normal)
            self.contentEdgeInsets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 8)
            self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 16)
		}
		
		self.backgroundColor = Color.purple
		self.titleLabel?.textColor = UIColor.white
		self.layer.cornerRadius = 12
	}
	
	func rightImage() {
		self.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		self.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		self.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
		self.imageEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
	}
    
    func disable(_ disable: Bool) {
        self.isEnabled = !disable
        if disable {
            self.alpha = 0.4
        }else {
            self.alpha = 1
        }
    }
    
}

extension UITextField {
	convenience init(_ hint: String) {
		self.init()
		self.placeholder = hint;
		self.backgroundColor = Color.formInput
        self.textColor = Color.black_white
		self.clipsToBounds = true
		self.layer.cornerRadius = 22
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
}

extension NSMutableData {
	
	func appendString(_ value : String) {
		let data = value.data(using: String.Encoding.utf8, allowLossyConversion: true)
		append(data!)
	}
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text:String, size: CGFloat, weight: UIFont.Weight) -> NSMutableAttributedString {
        let attrs:[NSAttributedString.Key: Any] = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: size, weight: weight)]
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
	
	static func create(_ light: Int, dark: Int) -> UIColor {
		return UIColor(dynamicProvider: { trait in
            return trait.userInterfaceStyle == .dark ? UIColor(hex: dark) : UIColor(hex: light)
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
	
	static let black_white = UIColor(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor.black
	})
    
    static let white_black = UIColor(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
    })
	
	static let background = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x141414) : UIColor.white
	})
    
    static let backgroundDark = Color.create(0xECECEC, dark: 0x3F3F3F)
	
	// Tab icons color
    static let tabItemDisabled = UIColor(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? UIColor(hex: 0xBFBFBF) : UIColor(hex: 0xAFAFAF)
    })
    
    static let tabItem = UIColor(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? cyan : cyan
    })
    
    static let cyan_white = UIColor(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? UIColor(hex: 0xDFDFDF) : UIColor(hex: 0x5CCCD0)
    })
    
    static let darkBlue_white = UIColor(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? UIColor(hex: 0xDFDFDF) : UIColor(hex: 0x465A6F)
    })
    
    static let lightText = UIColor(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x808080) : UIColor(hex: 0x6c6c6c)
    })
    
    static let grayDark = Color.create(0x343434, dark: 0xFFFFFF)
    static let grayMid = Color.create(0x858585, dark: 0xc9c9c9)
    static let gray = Color.create(0xB6B6B6, dark: 0x9f9f9f)
    
    
    
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
	
    static let separator = Color.create(0xE1E1E1, dark: 0x303030)
	
	static let formTitle = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor.white : UIColor(hex: 0x686868)
	})
	static let formDescription = UIColor(hex: 0xAEAEAE)
	static let formPlaceholder = UIColor(hex: 0xB9BBBB)
	static let formInput = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x494949) : UIColor(hex: 0xEFF2F2)
	})
	
	static let buttonShadow = UIColor(dynamicProvider: { trait in
		return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x202020) : UIColor(hex: 0x8A609C)
	})
	
	static let separatorBackground = UIColor(dynamicProvider: { trait in
        return trait.userInterfaceStyle == .dark ? UIColor(hex: 0x313131) : UIColor(hex: 0xEBEBEB)
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

extension Date {
    var milliseconds: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    static func from(string: String) -> Date? {
        return self.from(string: string, with: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX")
    }
    
    static func from(string: String, with format: String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        return df.date(from: string)
    }

    func string(with format: String) -> String{
        let df = DateFormatter()
        df.dateFormat = format
        return df.string(from: self)
    }
    
    static func time(since fromDate: Date) -> String {
        guard fromDate < Date() else { return "Back to the future" }
        
        let allComponents: Set<Calendar.Component> = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components:DateComponents = Calendar.current.dateComponents(allComponents, from: fromDate, to: Date())
        
        for (period, timeAgo) in [
            ("year", components.year ?? 0),
            ("month", components.month ?? 0),
            ("week", components.weekOfYear ?? 0),
            ("day", components.day ?? 0),
            ("hour", components.hour ?? 0),
            ("minute", components.minute ?? 0),
            ("second", components.second ?? 0),
        ] {
            if timeAgo > 0 {
                return "\(timeAgo.of(period)) ago"
            }
        }
        
        return "Just now"
    }
}

extension Int {
    func of(_ name: String) -> String {
        guard self != 1 else { return "\(self) \(name)" }
        return "\(self) \(name)s"
    }
}
