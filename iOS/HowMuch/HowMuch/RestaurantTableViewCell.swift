//
//  RestaurantTableViewCell.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

	@IBOutlet weak var restImgView: UIImageView!
	@IBOutlet weak var phoneLabel: UILabel!
	@IBOutlet weak var addLabel: UILabel!
	@IBOutlet weak var hourLabel: UILabel!
	@IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
