//
//  TutorialViewController.swift
//  HowMuch
//
//  Created by Jung Geon Choi on 2017-02-04.
//  Copyright © 2017 Group.name. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
	@IBOutlet weak var startButton: UIButton!
	@IBOutlet weak var pageIndicator: UIPageControl!

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let pageWidth = scrollView.frame.size.width
		let fractionalPage = scrollView.contentOffset.x / pageWidth
		let page = lround(Double(fractionalPage))
		pageIndicator.currentPage = page
		print(page)

		if(page == 2) {
			UIView.animate(withDuration: 1.0, animations: { 
				self.startButton.alpha = 1.0
			})
		}else {
			UIView.animate(withDuration: 1.0, animations: {
				self.startButton.alpha = 0.0
			})

		}
	}

    override func viewDidLoad() {
        super.viewDidLoad()
		scrollView.delegate = self
		startButton.alpha = 0.0
		scrollView.showsHorizontalScrollIndicator = false

		let views = [
		Tutorial1.instanceFromNib(),
		Tutorial1.instanceFromNib2(),
		Tutorial1.instanceFromNib3()]
		for i in 0...2 {
			let view = views[i]
			view.frame = CGRect(x: self.view.frame.width * CGFloat(i), y: 0.0, width: self.view.frame.width, height: self.view.frame.height)
			scrollView.addSubview(view)
		}
		self.view.bringSubview(toFront: pageIndicator)

scrollView.contentSize = CGSize(width: self.view.frame.width*3.0, height: self.view.frame.height)

scrollView.backgroundColor = UIColor.gray

		scrollView.isPagingEnabled = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	@IBOutlet weak var scrollView: UIScrollView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
