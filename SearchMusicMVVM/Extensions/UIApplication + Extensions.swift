//
//  UIApplication + Extensions.swift
//  SearchMusicMVVM
//
//  Created by Michael Iskandar on 04/09/20.
//  Copyright © 2020 Michael Iskandar. All rights reserved.
//

import UIKit

public extension UIApplication {

    func clearLaunchScreenCache() {
        do {
            try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
            sleep(5)
        } catch {
            print("Failed to delete launch screen cache: \(error)")
        }
    }

}
