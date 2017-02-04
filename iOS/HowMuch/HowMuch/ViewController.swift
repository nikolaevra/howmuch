//
//  ViewController.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-03.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit
import GoogleMaps
extension ViewController: UITextFieldDelegate {
	override func didChangeValue(forKey key: String, withSetMutation mutationKind: NSKeyValueSetMutationKind, using objects: Set<AnyHashable>) {
		UIView.animate(withDuration: 1.0) {
			self.goButton.alpha = 1.0
		}
	}
}
class ViewController: UIViewController {

	@IBOutlet weak var howMuchLabel: UIButton!
	@IBOutlet weak var userInput: UITextField!

	@IBOutlet weak var goButton: UIButton!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		UIView.animate(withDuration: 1.0) { 
			self.howMuchLabel.alpha = 1.0
			self.userInput.alpha = 1.0


		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		userInput.delegate = self
		userInput.becomeFirstResponder()
		howMuchLabel.alpha = 0.0
		userInput.alpha = 0.0
		goButton.alpha = 0.0

//		API.getStores(with: 10.00, lat: LocationManager.getLat(), lng: LocationManager.getLng()) { (response) in
//
//		}
//
//		let camera = GMSCameraPosition.camera(withLatitude: LocationManager.getLat(), longitude: LocationManager.getLng(), zoom: 6.0)
//		let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//		mapView.isMyLocationEnabled = true
//
//		mapView.frame = self.mapView.frame
//		view.addSubview(mapView)
//
//		// Creates a marker in the center of the map.
//		let marker = GMSMarker()
//		marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
//		marker.title = "Sydney"
//		marker.snippet = "Australia"
//		marker.map = mapView

		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

