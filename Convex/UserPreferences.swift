//
//  UserPreferences.swift
//  Convex
//
//  Created by Matthew Daigle on 10/20/16.
//  Copyright © 2016 Matt Daigle. All rights reserved.
//

import Foundation

struct UserPreferences {
    
    static var firstAppLaunchDate: Date? {
        get { return UserDefaultsUtils.valueFromDefaults(key: "firstAppLaunchDate") }
        set { UserDefaultsUtils.saveToDefaults(key: "firstAppLaunchDate", value: newValue) }
    }
    
    static var numberOfSessions: Int {
        get { return UserDefaultsUtils.valueFromDefaults(key: "numberOfSessions") ?? 0 }
        set { UserDefaultsUtils.saveToDefaults(key: "numberOfSessions", value: newValue) }
    }
    
    static var hasConverted: Bool {
        get { return UserDefaultsUtils.valueFromDefaults(key: "hasConverted") ?? false }
        set { UserDefaultsUtils.saveToDefaults(key: "hasConverted", value: newValue) }
    }
    
    static var haveAskedToRateApp: Bool {
        get { return UserDefaultsUtils.valueFromDefaults(key: "haveAskedToRateApp") ?? false }
        set { UserDefaultsUtils.saveToDefaults(key: "haveAskedToRateApp", value: newValue) }
    }
}
