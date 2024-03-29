//
//  ActivityIndicator.swift
//  Tenorize
//
//  Created by Eric Giannini on 8/29/18.
//  Copyright © 2018 Eric Giannini. All rights reserved.
//

import UIKit
class ActivityIndicator {
    
    // MARK: Private
    
    private static let restorationIdentifier = "TenorIndicator"
    
    private static var window: UIWindow? {
        return UIApplication.shared.keyWindow
    }
    
    // MARK: Public
    
    public static var defaultMessage = "Loading"
    
    public static var isShowing: Bool {
        return window?.subviews.reversed().contains { $0.restorationIdentifier == restorationIdentifier } == true
    }
    
    // MARK: Public Methods
    public static func startAnimating(message: String? = defaultMessage) {
        
        guard isShowing == false,
            let keyWindow = window else { return }
        
        DispatchQueue.main.async {
            
            let view = UIView()
            view.backgroundColor = UIColor.clear
            view.frame = keyWindow.rootViewController?.view.bounds ?? UIScreen.main.bounds
            view.restorationIdentifier = restorationIdentifier
            
            defer { keyWindow.addSubview(view) }
            
            let dimView = UIView()
            dimView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            view.addSubview(dimView)
            dimView.translatesAutoresizingMaskIntoConstraints = false
            dimView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
            
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            blurView.layer.masksToBounds = true
            blurView.layer.cornerRadius = 10
            view.addSubview(blurView)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            blurView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            blurView.widthAnchor.constraint(equalToConstant: 150).isActive = true
            blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
            
            let holderStackView = UIStackView()
            holderStackView.axis = .vertical
            holderStackView.distribution = .fill
            holderStackView.alignment = .center
            holderStackView.spacing = 15
            blurView.contentView.addSubview(holderStackView)
            holderStackView.translatesAutoresizingMaskIntoConstraints = false
            holderStackView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor, constant: 0).isActive = true
            holderStackView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor, constant: 0).isActive = true
            
            let loaderView = UIActivityIndicatorView(style: .whiteLarge)
            loaderView.startAnimating()
            loaderView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            holderStackView.addArrangedSubview(loaderView)
            
            let label = UILabel()
            label.text = message
            label.textColor = UIColor.white
            label.font = UIFont.boldSystemFont(ofSize: 17)
            label.numberOfLines = 0
            label.textAlignment = .center
            holderStackView.addArrangedSubview(label)
        }
    }
    
    public static func stopAnimating() {
        
        DispatchQueue.main.async {
            if let subViews = window?.subviews.reversed(),
                let loaderView = subViews.first(where: { $0.restorationIdentifier == restorationIdentifier }) {
                loaderView.removeFromSuperview()
            }
        }
    }
}
