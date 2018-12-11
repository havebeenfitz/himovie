//
//  AppDelegate.swift
//  HiMovie
//
//  Created by Max Kraev on 10/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        instantiateRealm()
        
        return true
    }
    
    //MARK: - Private
    
    private func instantiateRealm() {
        do {
            _ = try Realm()
        } catch {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }

}

