//
//  LocationManager.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-03.
//  Copyright © 2017 Group.name. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
	enum CoordinateType{
		case Lat
		case Lng
	}

	static let locationManager = CLLocationManager()

	static func locationServicesEnabled() -> Bool{
		locationManager.requestWhenInUseAuthorization()
		return CLLocationManager.locationServicesEnabled()
	}

	static func getLat() -> Double{
		return getCoordinate(type: .Lat)
	}

	static func getLng() -> Double{
		return getCoordinate(type: .Lng)
	}

	static func getCoordinate(type:CoordinateType) -> Double{
		if(locationServicesEnabled()){
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			if let location = locationManager.location{
				if(type == .Lng){
					return location.coordinate.longitude
				}else{
					return location.coordinate.latitude
				}
			}
		}

		return 0.0
	}
}
