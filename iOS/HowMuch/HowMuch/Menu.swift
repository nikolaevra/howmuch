//
//  Menu.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import Foundation
import SwiftyJSON
class Menu {

	var food_name = ""
	var food_price = 0.0

	init() {}
	init(_ json:JSON) {
		food_name = json["food_name"].stringValue
		food_price = json["food_price"].doubleValue
	}

}
