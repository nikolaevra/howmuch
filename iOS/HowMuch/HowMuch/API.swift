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
	static let baseUrl = "http://138.197.132.178/"
	
	static func getStores(with price:Double, lat: Double, lng: Double, complete:((JSON) -> Void)?){
		let parameters = [
			"price":"\(price)",
			"lat":"\(lat)",
			"lon":"\(lng)",
			"radius":"5000"
		]
		Alamofire.request(baseUrl + "get-location", method: .post, parameters: parameters).responseJSON { (response) in
			complete!(JSON(response.result.value!))

		}
	}
}
