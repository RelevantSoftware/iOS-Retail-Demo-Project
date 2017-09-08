//
//  Settings.swift
//  RetailDemo
//
//  Created by Taras Chernyshenko on 2/27/17.
//  Copyright © 2017 Relevant. All rights reserved.
//

import Foundation

struct Settings {
    
    static let app = Settings(userDefaults: UserDefaults.standard)
    
    private init(userDefaults: UserDefaults? = nil) {
        self.userDefaults = userDefaults
    }
    
    private let userDefaults: UserDefaults?
    
    //TODO: Add API url address
    let baseURL = URL(string: "")!
}
