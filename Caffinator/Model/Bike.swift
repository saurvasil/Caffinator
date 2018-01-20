//
//  Cafe.swift
//  Caffinator
//
//  Created by Akash Subramanian on 11/9/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import Foundation
import UIKit

struct Bike :Equatable {
    
    var id: String
    let name: String
    let picture: UIImage
    let description :String
    let hourly: Double
    let daily: Double
    let address: String
    let ownersid: String
    let reserved: String
    let phone: String
    
    init(name: String, picture: UIImage, description: String, hourly: Double, daily: Double, address: String, ownersid: String, reserved: String, phone: String) {
        self.id = UUID().uuidString
        self.name = name
        self.picture = picture
        self.description = description;
        self.daily = daily
        self.hourly = hourly
        self.address = address
        self.ownersid = ownersid
        self.reserved = reserved
        self.phone = phone
    }
    init(id: String, name: String, picture: UIImage, description: String, hourly: Double, daily: Double, address: String, ownersid: String, reserved: String, phone: String) {
        self.id = id
        self.name = name
        self.picture = picture
        self.description = description;
        self.daily = daily
        self.hourly = hourly
        self.address = address
        self.ownersid = ownersid
        self.reserved = reserved
        self.phone = phone
    }
    
    static func ==(lhs:Bike, rhs:Bike) -> Bool { // Implement Equatable
        return lhs.name == rhs.name && lhs.ownersid == rhs.ownersid
    }
    
}
