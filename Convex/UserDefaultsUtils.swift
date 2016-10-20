//
//  UserDefaultsUtils.swift
//  Convex
//
//  Created by Matthew Daigle on 10/20/16.
//  Copyright © 2016 Matt Daigle. All rights reserved.
//

import Foundation

struct UserDefaultsUtils {
    
    static func valueFromDefaults(key: String) -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: key)
    }
    
    static func saveToDefaults(key: String, value: String?) {
        let defaults = UserDefaults.standard
        if let newValue = value {
            defaults.set(newValue, forKey: key)
        }
        else {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    static func valueFromDefaults(key: String) -> Int? {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: key)
    }
    
    static func saveToDefaults(key: String, value: Int?) {
        let defaults = UserDefaults.standard
        if let newValue = value {
            defaults.set(newValue, forKey: key)
        }
        else {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    static func valueFromDefaults(key: String) -> Bool? {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: key)
    }
    
    static func saveToDefaults(key: String, value: Bool?) {
        let defaults = UserDefaults.standard
        if let newValue = value {
            defaults.set(newValue, forKey: key)
        }
        else {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
    
    static func valueFromDefaults(key: String) -> Date? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key) as? Date
    }
    
    static func saveToDefaults(key: String, value: Date?) {
        let defaults = UserDefaults.standard
        if let newValue = value {
            defaults.set(newValue, forKey: key)
        }
        else {
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
}
