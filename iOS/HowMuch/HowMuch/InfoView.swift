//
//  InfoView.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit

class InfoView: UIView {

	@IBOutlet weak var foodImage: UIImageView!

	@IBOutlet weak var time: UILabel!
	@IBOutlet weak var phoneNumber: UILabel!
	@IBOutlet weak var menuName: UILabel!

	@IBOutlet weak var foodPrice: UILabel!
	@IBOutlet weak var restName: UILabel!

	@IBOutlet weak var address: UILabel!
	@IBAction func goingButton(_ sender: UIButton) {
		print("button")
	}

	func set(store: Restaurant) {
		if(store.menus.count != 0) {
			menuName.text = store.menus[0].food_name
			foodPrice.text = "$ \(store.menus[0].food_price)"
		}
		phoneNumber.text  = store.phone
		restName.text = store.restaurant_name
		address.text = store.address

	}
	
	class func instanceFromNib() -> UIView {
		return UINib(nibName: "InfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
	}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
