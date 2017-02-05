//
//  MyMenuViewController.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth
import SwiftyJSON
import FirebaseDatabase

extension MyMenuViewController: FBSDKLoginButtonDelegate {

	func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

		if let error = error {
			print(error.localizedDescription)
			return
  }
		let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)

		FIRAuth.auth()?.signIn(with: credential) { (user, error) in
			if let error = error {
				print(error)
				return
			}
			let userID = FIRAuth.auth()?.currentUser?.uid
//			print(user)
			let ref = FIRDatabase.database().reference()
			ref.child("history").child(userID!).observe(.value, with: { (snapshot) in
				self.histories = []
				for (key, subJson) in JSON(snapshot.value!) {
					self.histories.append(History(subJson))
				}

				self.tableView.reloadData()

				//			if let hs = JSON(snapshot.value!).array {
				//				self.histories.removeAll()
				//				for history in hs {
				//
				//				}
				//				self.tableView.reloadData()
				//
				//			}

			})

		}
coverView.isHidden = true
		barButton(show: true)
	}

	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		let firebaseAuth = FIRAuth.auth()
		do {
			try firebaseAuth?.signOut()
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
		}
		coverView.isHidden = false
		barButton(show: false)
	}

	func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
		return true
	}
}
extension MyMenuViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return histories.count
	}

	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 300.0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell

		cell.setup(history: histories[indexPath.row])
		return cell
	}
}
class MyMenuViewController: UIViewController {
	var ref: FIRDatabaseReference!
	var histories: [History] = []


	@IBOutlet weak var buttomView: UIView!

	var coverView:UIView!
	@IBOutlet weak var tableView: UITableView!

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
				tableView.reloadData()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
		tableView.allowsSelection = false
tableView.tableFooterView = UIView()
		ref = FIRDatabase.database().reference()

		let userID = FIRAuth.auth()?.currentUser?.uid
//		
//		let history = History()
//		history.lat = LocationManager.getLat()
//		history.lng = LocationManager.getLng()
//		history.menuName = "test menu"
//		history.restaurantName = "dunnal"
//		history.price = 11.3

//		ref.child("history").child(userID!).child(NSUUID().uuidString).setValue(history.json())

//		ref.child("history").child(userID!).set


//		
//		ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//			// Get user value
//			let value = snapshot.value as? NSDictionary
//			let username = value?["username"] as? String ?? ""
//			let user = User.init(username: username)
//
//			// ...
//  }) { (error) in
//	print(error.localizedDescription)
//		}
//

		if(userID != nil){
			let userID = FIRAuth.auth()?.currentUser?.uid
			ref.child("history").child(userID!).observe(.value, with: { (snapshot) in
				self.histories = []
				for (key, subJson) in JSON(snapshot.value!) {
					self.histories.append(History(subJson))
				}

				self.tableView.reloadData()

				//			if let hs = JSON(snapshot.value!).array {
				//				self.histories.removeAll()
				//				for history in hs {
				//
				//				}
				//				self.tableView.reloadData()
				//
				//			}
				
			})

		}

		let view = UIView(frame: self.view.frame)
		view.backgroundColor = UIColor.white
		let label = UILabel(frame: CGRect(x: 0, y: self.view.frame.height/2.0-50.0, width: self.view.frame.width, height: 25.0))
		label.text = "Please login to use this feature"
		label.textAlignment = .center
		let loginButton = FBSDKLoginButton()

		loginButton.readPermissions = ["email"]
		loginButton.center = self.view.center
		loginButton.delegate = self
		view.addSubview(label)
		view.addSubview(loginButton)
		self.view.addSubview(view)
		coverView = view




		if FIRAuth.auth()?.currentUser == nil {
			coverView.isHidden = false
			barButton(show: false)
					}else{
coverView.isHidden = true
barButton(show: true)
		}
	}

	func barButton(show: Bool) {
		let button = FBSDKLoginButton()
		button.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 25.0)
		button.delegate = self
		if(show) {
			navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
		}else {
			navigationItem.rightBarButtonItem = nil
		}

	}

//	func logout() {
//		let loginManager = FBSDKLoginManager()
//		loginManager.logOut()
//		let firebaseAuth = FIRAuth.auth()
//		do {
//			try firebaseAuth?.signOut()
//		} catch let signOutError as NSError {
//			print ("Error signing out: %@", signOutError)
//		}
//		viewDidLoad()
//	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		JGAlert.show(nil, title: "History", message: nil, preferredStyle: .actionSheet, options: ["View Details"], destructiveOptions: ["Delete"], completed: nil)
		tableView.deselectRow(at: indexPath, animated: true)
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
