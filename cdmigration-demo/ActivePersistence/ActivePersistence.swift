//
//  ActivePersistence.swift
//  cdmigration-demo
//
//  Created by Jin He on 10/4/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation

class ActivePersistence: NSObject {
    static let shared = ActivePersistence()
    
    private override init() {
        super.init()
    }
}
