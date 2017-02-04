//
//  MapViewController.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

	

	@IBAction func didChangeSeg(_ sender: UISegmentedControl) {

		//Map
		if(sender.selectedSegmentIndex == 0) {
			UIView.transition(from: self.tableView, to: self.mapView, duration: 1.0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)

		} else {
			//List
			let fv = self.mapView
			let tv = self.tableView
			UIView.transition(from: fv!, to: tv!
				, duration: 1.0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
		}
		// set a transition style


		// with no animation block, and a completion block set to 'nil' this makes a single line of code

	}

	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var mapViewContainer: UIView!
	var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

		let camera = GMSCameraPosition.camera(withLatitude: LocationManager.getLat(), longitude: LocationManager.getLng(), zoom: 6.0)
		let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		mapView.isMyLocationEnabled = true
		mapView.delegate = self
		mapView.settings.myLocationButton = true
		mapView.frame = mapViewContainer.frame
		self.view.addSubview(mapView)
		self.mapView = mapView

		// Creates a marker in the center of the map.
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2D(latitude: LocationManager.getLat(), longitude: LocationManager.getLng())
//		marker.title = "Sydney"
//		marker.snippet = "Australia"
//		marker.infoWindowAnchor = CGPoint(x: 0.44, y: 0.45)
		marker.map = mapView
		self.view.bringSubview(toFront: mapView)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MapViewController: GMSMapViewDelegate {
	func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
		let view = InfoView.instanceFromNib()
		view.frame = CGRect(x: 0.0, y: -5.0, width: self.view.frame.width * 0.8, height: self.view.frame.height/4)
		view.layer.cornerRadius = 5

		return view
	}

	func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
		let alert = UIAlertController(title: "My Menu Added", message: "Name of food has been added to your menu", preferredStyle: UIAlertControllerStyle.alert)
		alert.addAction(UIAlertAction(title: "Awsome!", style: UIAlertActionStyle.default, handler: nil))
		self.present(alert, animated: true, completion: nil)
	}


	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .default, reuseIdentifier: "defaultCell")
		cell.textLabel?.text
			= "Hi"
		return cell
	}




}
