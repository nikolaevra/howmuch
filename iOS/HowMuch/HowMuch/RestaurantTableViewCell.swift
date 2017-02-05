//
//  RestaurantTableViewCell.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

	@IBOutlet weak var foodname: UILabel!
	@IBOutlet weak var storename: UILabel!
	@IBOutlet weak var price: UILabel!

	@IBOutlet weak var addr: UILabel!

	@IBOutlet weak var phone: UILabel!

	func set(_ store:Restaurant) {
		if(store.menus.count != 0){
			foodname.text = store.menus[0].food_name
			price.text = "\(store.menus[0].food_price)"
		}else{
			foodname.text = "Delux Burger"
			price.text = "$ 13.99"
		}
		addr.text = store.address
		phone.text = store.phone


	}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
