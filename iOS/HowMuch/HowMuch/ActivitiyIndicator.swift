//
//  ActivitiyIndicator.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import Foundation
import UIKit
class ActivityIndicator{
	static let shareInstance = ActivityIndicator()

	var blurEffect = UIBlurEffect()
	var blurEffectView = UIVisualEffectView()
	var loadingIndicator = UIActivityIndicatorView()
	var shadeView = UIView()
	let labelText = UILabel()

	init () {
		blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
		blurEffectView = UIVisualEffectView(effect: blurEffect)
		loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
	}

	func showIndicator(_ view: UIView, loadingMessage:String = "Loading...") {
		// Shadow or blur

			blurEffectView.frame = view.bounds
			view.addSubview(blurEffectView)

		// Loading Indicator
		loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.startAnimating()
		loadingIndicator.center = view.center
		view.addSubview(loadingIndicator)

		// Label text
		labelText.frame = CGRect(x: 0,y: loadingIndicator.center.y+40,width: view.frame.width,height: 20)
		labelText.text = loadingMessage
		labelText.textAlignment=NSTextAlignment.center
		labelText.textColor=UIColor.white
		view.addSubview(labelText)
	}

	func hideIndicator() {
		shadeView.removeFromSuperview()
		loadingIndicator.removeFromSuperview()
		blurEffectView.removeFromSuperview()
		labelText.removeFromSuperview()
	}
}
