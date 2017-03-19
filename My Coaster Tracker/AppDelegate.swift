//
//  AppDelegate.swift
//  My Coaster Tracker
//
//  Created by David Frischknecht on 2/14/17.
//  Copyright © 2017 David Frischknecht. All rights reserved.
//

import UIKit
import CoreData
import CocoaLumberjack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
	enum ShortcutIdentifier: String {
		case checkin
		
		init?(fullType: String?) {
			guard let last = fullType?.components(separatedBy: ".").last else {
				return nil
			}
			self.init(rawValue: last)
		}
		
		var type: String {
			return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
		}
	}
	
	var window: UIWindow?
	var launchedShortcutItem: UIApplicationShortcutItem?
	
	@discardableResult
	func handleShortCutItem(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
		guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
		guard let shortCutType = shortcutItem.type as String? else { return false }
		if shortCutType.components(separatedBy: ".").last == ShortcutIdentifier.checkin.rawValue {
			launchCheckIn()
			return true
		}
		
		return false
	}
	
	func launchCheckIn() {
		let splitController = window!.rootViewController as! UISplitViewController
		let navigationController = splitController.viewControllers[0] as! UINavigationController
		let navigationController2 = navigationController.topViewController as! UINavigationController
		let viewController = navigationController2.topViewController!
		viewController.performSegue(withIdentifier: "checkInSegue", sender: self)
	}


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		DDLog.add(DDASLLogger.sharedInstance())
		DDLog.add(DDTTYLogger.sharedInstance())
		let fileLogger = DDFileLogger()
		fileLogger?.rollingFrequency = TimeInterval(60*60*24)
		fileLogger?.logFileManager.maximumNumberOfLogFiles = 7
		DDLog.add(fileLogger)
		defaultDebugLevel = DDLogLevel.all
		var shouldPerformAdditionalDelegateHandling = true
		
		if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
			launchedShortcutItem = shortcutItem
			shouldPerformAdditionalDelegateHandling = false
		}
		
		return shouldPerformAdditionalDelegateHandling
	}
	
	func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
		let handledShortCutItem = handleShortCutItem(shortcutItem)
		completionHandler(handledShortCutItem)
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
		guard let shortcut = launchedShortcutItem else { return }
		handleShortCutItem(shortcut)
		launchedShortcutItem = nil
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.
		self.saveContext()
	}

	// MARK: - Core Data stack

	lazy var persistentContainer: NSPersistentContainer = {
	    /*
	     The persistent container for the application. This implementation
	     creates and returns a container, having loaded the store for the
	     application to it. This property is optional since there are legitimate
	     error conditions that could cause the creation of the store to fail.
	    */
	    let container = NSPersistentContainer(name: "My_Coaster_Tracker")
	    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
	        if let error = error as NSError? {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	             
	            /*
	             Typical reasons for an error here include:
	             * The parent directory does not exist, cannot be created, or disallows writing.
	             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
	             * The device is out of space.
	             * The store could not be migrated to the current model version.
	             Check the error message to determine what the actual problem was.
	             */
	            fatalError("Unresolved error \(error), \(error.userInfo)")
	        }
	    })
	    return container
	}()

	// MARK: - Core Data Saving support

	func saveContext () {
	    let context = persistentContainer.viewContext
	    if context.hasChanges {
	        do {
	            try context.save()
	        } catch {
	            // Replace this implementation with code to handle the error appropriately.
	            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	            let nserror = error as NSError
	            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
	        }
	    }
	}

}
