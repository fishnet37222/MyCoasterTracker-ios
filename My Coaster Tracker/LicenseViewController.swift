//
//  LicenseViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/17/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit

class LicenseViewController: UIViewController, UIWebViewDelegate {
	@IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

		webView.delegate = self
		let localFilePath = Bundle.main.url(forResource: "LICENSE-2.0", withExtension: "html")
		let request = URLRequest(url: localFilePath!)
		webView.loadRequest(request);

		let model = UIDevice.current.model
		if (model == "iPhone") {
			self.navigationItem.backBarButtonItem = self.splitViewController?.displayModeButtonItem
		}
		if (model == "iPad") {
			self.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem

			let splitViewController = self.splitViewController!
			if UIApplication.shared.statusBarOrientation == .portrait {
				UIView.animate(withDuration: 0.2, animations: {
					splitViewController.preferredDisplayMode = .primaryHidden
				})
			}
		}
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

	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		switch navigationType {
		case UIWebViewNavigationType.linkClicked:
			UIApplication.shared.open(request.url!, options: [:], completionHandler: nil)
			return false
		default:
			return true
		}
	}
}
