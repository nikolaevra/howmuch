//
//  API.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-03.
//  Copyright © 2017 Group.name. All rights reserved.
//

import SwiftyJSON
import Foundation
import Alamofire

class API {
	static let baseUrl = "http://138.197.132.178:5000/api/v1/"
	static func getStores(with price:Double, lat: Double, lng: Double, complete:((JSON) -> Void)?){
		let parameters = [
			"price":"\(price)",
			"lat":"\(lat)",
			"lng":"\(lng)"
		]

		Alamofire.request(baseUrl + "my_price", method: .get, parameters: parameters).responseJSON { (response) in
			print(response)
		}
	}
}
