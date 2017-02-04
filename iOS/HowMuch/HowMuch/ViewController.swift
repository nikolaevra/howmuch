//
//  ViewController.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-03.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		print(LocationManager.getCoordinate(type: .Lat))
		print(LocationManager.getCoordinate(type: .Lng))

		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

