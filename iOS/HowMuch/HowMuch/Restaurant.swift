//
//  Restaurant.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import Foundation
import SwiftyJSON

class Restaurant {
	var address = ""
	var city = ""
	var locality = ""
	var city_id = 0
	var zipcode = ""
	var lon: Double = 0.0
	var lat: Double = 0.0
	var phone = ""
	var restaurant_name = ""
	var country_id = 0
	var menus:[Menu] = []

	init() {

	}

	init(_ json:JSON){
		update(from: json)
	}

	func update(from json:JSON) {
		address = json["address"][0].stringValue + " " + json["address"][1].stringValue

		restaurant_name = json["restaurant_name"].stringValue
		phone = json["phone"].stringValue
		lon = json["lon"].doubleValue
		lat = json["lat"].doubleValue

		let menu_items = json["menu_items"].array!
		menus = []
		for item in menu_items {
			menus.append(Menu(item))
		}
	}
}
