//
//  ViewController.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-03.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit

extension ViewController: UITextFieldDelegate {
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		UIView.animate(withDuration: 1.0) {
			self.goButton.alpha = 1.0
		}
		return true
	}
}
class ViewController: UIViewController {

	@IBAction func didTabGo(_ sender: UIButton) {
		API.getStores(with: Double(userInput.text!)!, lat: LocationManager.getLat(), lng: LocationManager.getLng()) { (response) in
			print("response received")
		}
	}
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

		// Do any additional setup after loading the view, typically from a nib.
	}
//
//	override func viewWillDisappear(_ animated: Bool) {
//		super.viewWillDisappear(animated)
//		let view = UIView(frame: self.view.frame)
//		view.backgroundColor = UIColor.lightGray
//	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

