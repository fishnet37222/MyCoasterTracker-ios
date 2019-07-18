//
//  LicenseViewController.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/17/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import WebKit

class LicenseViewController: UIViewController, WKNavigationDelegate {
	@IBOutlet weak var webView: WKWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView.navigationDelegate = self
		let localFilePath = Bundle.main.path(forResource: "LICENSE", ofType: "html")
		let url = URL(fileURLWithPath: localFilePath!)
		webView.loadFileURL(url, allowingReadAccessTo: url)
		
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
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		switch navigationAction.navigationType {
		case WKNavigationType.linkActivated:
			UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
			decisionHandler(WKNavigationActionPolicy.cancel)
		default:
			decisionHandler(WKNavigationActionPolicy.allow)
		}
	}
}
