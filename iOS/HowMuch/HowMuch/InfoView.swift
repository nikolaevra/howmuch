//
//  InfoView.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit

class InfoView: UIView {

	@IBAction func goingButton(_ sender: UIButton) {
		print("button")
	}
	class func instanceFromNib() -> UIView {
		return UINib(nibName: "InfoView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
	}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
