//
//  History.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import Foundation
import SwiftyJSON

class History {
	var timestamp = Date()
	var restaurantName = ""
	var moneySpent = 0.0
	var lat = Double(0.0)
	var fullness = 0
	var imageURL = "google.com/daasd.png"
	var lng = Double(0.0)

	func json() -> [String:String]{
		var result = [String:String]()
		result["timestamp"] = "\(timestamp.timeIntervalSince1970)"
		result["restaurantName"] = restaurantName
		result["moneySpent"] = "\(moneySpent)"
		result["fullness"] = "0"
		result["imageURL"] = "google.com/daasd.png"
		result["lat"] = "\(lat)"
		result["lng"] = "\(lng)"
		return result
	}

	init() {}

	init(_ json:JSON) {
		timestamp = Date(timeIntervalSince1970: TimeInterval(exactly: json["timestamp"].floatValue)!)
		restaurantName = json["restaurantName"].stringValue
		moneySpent = json["moneySpent"].doubleValue
		lat = json["lat"].doubleValue
		lng = json["lng"].doubleValue
	}

}

extension Date {
	func getLocalizedStringWith(_ dateStyle:DateFormatter.Style, timeStyle: DateFormatter.Style) -> String{
		return DateFormatter.localizedString(from: self, dateStyle: dateStyle, timeStyle: timeStyle)
	}

	func getString(_ format:String) -> String{
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format

		return dateFormatter.string(from: self)
	}
}
