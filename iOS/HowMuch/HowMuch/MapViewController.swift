//
//  MapViewController.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit
import GoogleMaps

import FBSDKLoginKit
import FirebaseAuth
import SwiftyJSON
import FirebaseDatabase

extension MapViewController: UITableViewDelegate, UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
		return cell
	}



}

class MapViewController: UIViewController {
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
	var restaurants:[Restaurant] = []
	var mapView: GMSMapView!
	var markers: [GMSMarker] = []
	func updateMarkers() {
		for m in markers {
			m.map = nil
		}
		markers = []

		for r in restaurants {
			let marker = GMSMarker()
			marker.position = CLLocationCoordinate2D(latitude: r.lat, longitude: r.lon)
			marker.map = mapView
			markers.append(marker)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
tableView.tableFooterView = UIView()
		API.getStores(with: UserDefaults.standard.double(forKey: "userPrice"), lat: LocationManager.getLat(), lng: LocationManager.getLng()) { (response) in

			let rs = response["data"].array ?? []
			self.restaurants = []
			for restaurant in rs {
				self.restaurants.append(Restaurant(restaurant))
			}

			self.updateMarkers()
			ActivityIndicator.shareInstance.hideIndicator()
		}

		let camera = GMSCameraPosition.camera(withLatitude: LocationManager.getLat(), longitude: LocationManager.getLng(), zoom: 11.0)
		let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
		mapView.isMyLocationEnabled = true
		mapView.delegate = self
		mapView.settings.myLocationButton = true
		mapView.frame = mapViewContainer.frame
		self.view.addSubview(mapView)
		self.mapView = mapView

			self.view.bringSubview(toFront: mapView)
ActivityIndicator.shareInstance.showIndicator(self.view)

		// Do any additional setup after loading the view.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	var userselectionMarker:GMSMarker!

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
		let view = InfoView.instanceFromNib() as! InfoView
		let index = markers.index(of: marker)

		view.set(store: restaurants[index!])
		view.frame = CGRect(x: 0.0, y: -5.0, width: self.view.frame.width * 0.8, height: self.view.frame.height/4)
		view.layer.cornerRadius = 5

		return view
	}

	func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {

		let ref = FIRDatabase.database().reference()

		let userID = FIRAuth.auth()?.currentUser?.uid

		if(userID == nil){
			let alert = UIAlertController(title: "ERROR", message: "This feature requires login. Please login and retry", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)

		}else{
			let alert = UIAlertController(title: "My Menu Added", message: "Name of food has been added to your menu", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "Awsome!", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)


			let index = markers.index(of: marker)
			let store = restaurants[index!]
			let history = History()
			history.lat = store.lat
			history.lng = store.lon
			if(store.menus.count != 0) {

				history.moneySpent = store.menus[0].food_price
			}else{

				history.moneySpent = 9.98
			}

			history.restaurantName = store.restaurant_name


			ref.child("history").child(userID!).child(NSUUID().uuidString).setValue(history.json())
		}

		self.tabBarController?.selectedIndex = 1


	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		JGAlert.show(nil, title: "Store", message: nil, preferredStyle: .actionSheet, options: ["View Details", "Call Store", "Navigate to Store"], destructiveOptions: nil, completed: nil)
		tableView.deselectRow(at: indexPath, animated: true)
	}

	func mapView(_ mapView: GMSMapView, didLongPressAt coordinate: CLLocationCoordinate2D) {
		// send API
		ActivityIndicator.shareInstance.showIndicator(self.view)
		API.getStores(with: UserDefaults.standard.double(forKey: "userPrice"), lat: coordinate.latitude, lng: coordinate.longitude) { (response) in
			print(response["data"])
			let rs = response["data"].array ?? []
			self.restaurants = []
			for restaurant in rs {
				self.restaurants.append(Restaurant(restaurant))
			}

			self.updateMarkers()
			ActivityIndicator.shareInstance.hideIndicator()
		}

		let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 11.0)
		mapView.animate(to: camera)
		if(userselectionMarker != nil){
			userselectionMarker.map = nil
		}
		userselectionMarker = GMSMarker()
		userselectionMarker.position = coordinate
		userselectionMarker.map = mapView
		userselectionMarker.icon = #imageLiteral(resourceName: "selection")
		userselectionMarker.appearAnimation = kGMSMarkerAnimationPop

	}

}
