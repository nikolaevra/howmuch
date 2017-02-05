//
//  HistoryTableViewCell.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit
import GoogleMaps

class HistoryTableViewCell: UITableViewCell {
	@IBOutlet weak var mapViewContainer: UIView!

	@IBOutlet weak var restaurantNameLabel: UILabel!
	

	@IBOutlet weak var priceLAbel: UILabel!

	@IBOutlet weak var timestampLabel: UILabel!

	var mapView: GMSMapView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

	func setup(history: History) {

		restaurantNameLabel.text = history.restaurantName
		timestampLabel.text = history.timestamp.getLocalizedStringWith(.medium, timeStyle: .medium)
		priceLAbel.text = String(format: "You spent $ %.2f", history.moneySpent)



		let camera = GMSCameraPosition.camera(withLatitude: history.lat, longitude: history.lng, zoom: 16.0)

		let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)

		mapView.frame = mapViewContainer.frame
		mapView.frame = CGRect(x: mapViewContainer.frame.origin.x, y: mapViewContainer.frame.origin.y, width: self.frame.width, height: mapViewContainer.frame.height)
		mapView.settings.setAllGesturesEnabled(false)
		mapView.isUserInteractionEnabled = false
		addSubview(mapView)
		self.mapView = mapView

		// Creates a marker in the center of the map.
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2D(latitude: history.lat, longitude: history.lng)
		//		marker.title = "Sydney"
		//		marker.snippet = "Australia"
		//		marker.infoWindowAnchor = CGPoint(x: 0.44, y: 0.45)
		marker.map = mapView
//		self.view.bringSubview(toFront: mapView)
	}

	

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
