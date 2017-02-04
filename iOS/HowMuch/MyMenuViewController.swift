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
			print(user)
		}
	}

	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		let firebaseAuth = FIRAuth.auth()
		do {
			try firebaseAuth?.signOut()
		} catch let signOutError as NSError {
			print ("Error signing out: %@", signOutError)
		}

	}

	func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
		performSegue(withIdentifier: "goMain", sender: nil)
		return true
	}
}

class MyMenuViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {

		super.viewDidLoad()
		if FIRAuth.auth()?.currentUser == nil {
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
		}else{
			let button = FBSDKLoginButton()
			button.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 25.0)
			navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)

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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
