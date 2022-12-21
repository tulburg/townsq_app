//
//  SuccessViewController.swift
//  Town SQ
//
//  Created by Tolu Oluwagbemi on 21/12/2022.
//  Copyright © 2022 Tolu Oluwagbemi. All rights reserved.
//

import UIKit

class SuccessViewController: ViewController {
    
    init(title: String, subtitle: String) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = Color.background
        
        let check = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withTintColor(Color.cyan, renderingMode: .alwaysOriginal))
        check.contentMode = .scaleAspectFill
        let title = Title(text: title)
        title.textAlignment = .center
        title.numberOfLines = 2
        let subtitle = UILabel(subtitle, Color.lightText, UIFont.systemFont(ofSize: 16))
        subtitle.numberOfLines = 3
        subtitle.textAlignment = .center
        let awesome = ButtonXL("Awesome!", action: #selector(close))
        
        let rootView = UIView()
        
        rootView.add().vertical(safeAreaInset!.top + (0.08 * view.frame.height)).view(check, view.frame.width * 0.4).gap(48).view(title).gap(24).view(subtitle)
            .gap(">=0").view(awesome, 44).end(">=\(48 + safeAreaInset!.bottom)")
        rootView.add().horizontal(">=0").view(check, view.frame.width * 0.4).end(">=0")
        rootView.constrain(type: .horizontalCenter, check, awesome)
        rootView.constrain(type: .horizontalFill, title, subtitle, margin: 32)
        
        view.addSubview(rootView)
        view.constrain(type: .horizontalFill, rootView)
        view.constrain(type: .verticalFill, rootView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
}
