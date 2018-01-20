//
//  Member.swift
//  Caffinator
//
//  Created by Saur Vasil on 12/2/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import Foundation
import UIKit
struct Member {
    
    var id: String? = nil// the key/ index under which the data for the cafe is stored in the database ("0", "1", ...)
    let fName: String
    let lName: String
    let address: String
    let picture: UIImage
    let phoneNumber : String
    var bikes : [Bike]
    let email: String
    
    init(fName: String, lName: String, address: String, picture: UIImage, phoneNumber: String, bikes: [Bike], email: String) {
        self.fName = fName
        self.lName = lName
        self.address = address
        self.picture = picture
        self.phoneNumber = phoneNumber;
        self.bikes = bikes
        self.email = email
    }
    init(id: String, fName: String, lName: String, address: String, picture: UIImage, phoneNumber: String, bikes: [Bike], email: String) {
        self.id = id
        self.fName = fName
        self.lName = lName
        self.address = address
        self.picture = picture
        self.phoneNumber = phoneNumber;
        self.bikes = bikes
        self.email = email
    }
    
}
