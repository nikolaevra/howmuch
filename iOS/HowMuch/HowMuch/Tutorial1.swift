//
//  Tutorial1.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit

class Tutorial1: UIView {
	class func instanceFromNib() -> UIView {
		return UINib(nibName: "Tutorial1", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
	}

	class func instanceFromNib2() -> UIView {
		return UINib(nibName: "Tutorial2", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
	}

	class func instanceFromNib3() -> UIView {
		return UINib(nibName: "Tutorial3", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
	}

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
