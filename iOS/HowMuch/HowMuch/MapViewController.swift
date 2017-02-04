//
//  MapViewController.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()



		let camera = GMSCameraPosition.camera(withLatitude: LocationManager.getLat(), longitude: LocationManager.getLng(), zoom: 6.0)
		let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		mapView.isMyLocationEnabled = true
		mapView.delegate = self
		mapView.settings.myLocationButton = true

		view = mapView


		// Creates a marker in the center of the map.
		let marker = GMSMarker()
		marker.position = CLLocationCoordinate2D(latitude: LocationManager.getLat(), longitude: LocationManager.getLng())
//		marker.title = "Sydney"
//		marker.snippet = "Australia"
//		marker.infoWindowAnchor = CGPoint(x: 0.44, y: 0.45)
		marker.map = mapView
		


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
		view.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width * 0.8, height: self.view.frame.height/4)

		return view
	}





}
