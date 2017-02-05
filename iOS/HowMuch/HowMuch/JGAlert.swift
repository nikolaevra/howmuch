//
//  JGAlert.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import Foundation

import UIKit
import Foundation

class JGAlert{

	static func showAlert(_ vc:UIViewController = JGUtils.getFrontViewController(), title: String?, buttonMessage:String = "OK", message: String?){
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: buttonMessage, style: .default, handler: nil))
		vc.present(alert, animated: true, completion: nil)
	}

	static func numberInput(_ vc:UIViewController, title: String?, message: String?, preferredStyle: UIAlertControllerStyle, completed:((String) -> Void)?){

		let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

		let saveAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: {
			alert -> Void in

			let firstTextField = alertController.textFields![0] as UITextField
			if(firstTextField.text?.isEmpty)! {
				print("Input filed is empty. Do notrhing")
			} else{
				if let completed = completed{
					completed(firstTextField.text!)
				}

			}
		})
		/*
		let deleteAction = UIAlertAction(title: "Delete", style: .destructive , handler: {
		alert -> Void in

		})
		*/
		let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel , handler: {
			alert -> Void in

		})

		alertController.addTextField { (textField : UITextField!) -> Void in
			textField.placeholder = ""
			textField.keyboardType = UIKeyboardType.numberPad
		}

		//alertController.addAction(deleteAction)
		alertController.addAction(saveAction)
		alertController.addAction(cancelAction)


		vc.present(alertController, animated: true, completion: nil)
	}

	var alertController = UIAlertController()

	/**
	Create AlertViewController
	*/

	static func show(_ vc:UIViewController?, title: String?, message: String?, preferredStyle: UIAlertControllerStyle, options:[String], completed:((String, Int) -> Void)?){
		show(vc, title: title, message: message, preferredStyle: preferredStyle, options: options, destructiveOptions: nil, completed: completed)
	}

	static func show(_ vc:UIViewController?, title: String?, message: String?, preferredStyle: UIAlertControllerStyle, options:[String], destructiveOptions:[String]?, completed: ((String, Int) -> Void)?){
		//(Int, Int) -> Int, _ a: Int, _ b: Int)

		//Create the AlertController
		let actionSheetController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)

		//Create and add the Cancel action
		let cancelAction: UIAlertAction = UIAlertAction(title: options.count == 0 ? "OK" : "Cancel", style: .cancel) { action -> Void in
			if let completed = completed{
				completed("", -1)
			}

		}

		actionSheetController.addAction(cancelAction)

		for option in options{
			//Create and add a second option action
			let userOption: UIAlertAction = UIAlertAction(title: option, style: .default) { action -> Void in
				if let completed = completed{
					completed(option, options.index(of: option)!)
				}
			}
			actionSheetController.addAction(userOption)
		}
		if let destructiveOptions = destructiveOptions{
			for destructiveOption in destructiveOptions{
				let destOption: UIAlertAction = UIAlertAction(title: destructiveOption, style: UIAlertActionStyle.destructive, handler: { (action) in
					if let completed = completed{
						completed(destructiveOption, destructiveOptions.index(of: destructiveOption)! + options.count)
					}
				})
				actionSheetController.addAction(destOption)
			}


		}


		if(vc == nil){
			if var topController = UIApplication.shared.keyWindow?.rootViewController {
				while let presentedViewController = topController.presentedViewController {
					topController = presentedViewController
				}

				topController.present(actionSheetController, animated: true, completion: nil)

			}
		}else{
			//Present the AlertController
			vc!.present(actionSheetController, animated: true, completion: nil)
		}

	}
}


class JGUtils{
	static func getFrontViewController() -> UIViewController{
		if var topController = UIApplication.shared.keyWindow?.rootViewController {
			while let presentedViewController = topController.presentedViewController {
				topController = presentedViewController
			}
			return topController
		}
		print("Failed to find first view controller @ JGUtils.getFrontViewController()")
		return UIViewController()
	}
}

