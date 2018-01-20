//
//  FirebaseDataManager.swift
//  Caffinator
//
//  Created by Akash Subramanian on 11/9/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseDataManager {
    
    // Use these database references only. Please DO NOT create your own.
    private static let user_ids = Database.database().reference(withPath: "user_ids")
    private static let objects_by_user_id = Database.database().reference(withPath: "objects_by_user_id")
    private static let objects_by_object_id = Database.database().reference(withPath: "objects_by_object_id")
    
    
    /*
     * Pulls all the bikes from the database
     */
    static func pullObjects(callback: @escaping (Bike) -> ()) {
        objects_by_object_id.observeSingleEvent(of: .value, with: { (snapshot) in
            // TIP: print snapshot here to see what the returned data looks like.
            for case let bikeSnapshot as DataSnapshot in snapshot.children { // for each coffee_shops entry
                let bikeData = bikeSnapshot.value as? NSDictionary;
                let name = bikeData?["name"] as? String;
                let picture = bikeData?["picture"] as? NSString;
                let description = bikeData?["description"] as? String;
                let hourly = bikeData?["hourly"] as? Double;
                let daily = bikeData?["daily"] as? Double;
                let address = bikeData?["address"] as? String;
                let ownersid = bikeData?["ownersid"] as? String;
                let reserved = bikeData?["reserved"] as? String;
                let phone = bikeData?["phone"] as? String;

                //create image out of picture
                let thumbnail1Data =  Data(base64Encoded: picture! as String, options: NSData.Base64DecodingOptions())
                let picUI: UIImage = UIImage(data: thumbnail1Data as! Data)!
                
                let bik = Bike(id: bikeSnapshot.key, name: name!, picture: picUI, description: description!, hourly: hourly!, daily: daily!, address: address!, ownersid: ownersid!, reserved: reserved!, phone: phone!)
                callback(bik)
            }
        })
    }
    
    //add bike
    static func addBike(bike: Bike, userid: String) {
        
        //also need to register first bike
        let key = objects_by_object_id
        let newRef = key.child(bike.id)
            
        //convert picture
        var base64String: NSString!
        let myImage = bike.picture
        let imageData = UIImageJPEGRepresentation(myImage, 0.9)
        base64String = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed) as NSString!
        
        let newBikeData = [
            "name": bike.name as NSString,
            "picture": base64String,
            "description": bike.description as NSString,
            "hourly": bike.hourly as NSNumber,
            "daily": bike.daily as NSNumber,
            "address": bike.address as NSString,
            "ownersid": bike.ownersid as NSString,
            "reserved": bike.reserved as NSString,
            "phone": bike.phone as NSString
        ]
        
        newRef.setValue(newBikeData)
    }
    
    //add bike
    static func removeBike(bike: Bike) {
        //also need to register first bike
        let key = objects_by_object_id
        let newRef = key.child(bike.id)
        newRef.removeValue();
    }
    
    //switch reserve bike
    static func reserve(bike: Bike, user: String) {
        if (bike.reserved == "0") {
            let key = objects_by_object_id
            let newRef = key.child(bike.id).child("reserved")
            newRef.setValue(user)
        } else {
            let key = objects_by_object_id
            let newRef = key.child(bike.id).child("reserved")
            newRef.setValue("0")
        }
       
    }
    
    //get owner information
    static func pullOwner(callback: @escaping (Member) -> ()) {
        user_ids.observeSingleEvent(of: .value, with: { (snapshot) in
            // TIP: print snapshot here to see what the returned data looks like.
            for case let memberSnapshot as DataSnapshot in snapshot.children {
                let memberData = memberSnapshot.value as? NSDictionary;
                let fname = memberData?["fName"] as? String;
                let lname = memberData?["lName"] as? String;
                let picture = memberData?["picture"] as? NSString;
                let phoneNumber = memberData?["phone_number"] as? String;
                let email = memberData?["email"] as? String;
                let address = memberData?["address"] as? String;
                let bikes: [Bike] = []
                //create image out of picture
                let thumbnail1Data =  Data(base64Encoded: picture! as String, options: NSData.Base64DecodingOptions())
                let picUI: UIImage = UIImage(data: thumbnail1Data as! Data)!
                
                let mem = Member(id: memberSnapshot.key, fName: fname!, lName: lname!, address: address!, picture: picUI, phoneNumber: phoneNumber!, bikes: bikes, email: email!)
                callback(mem)
            }
        })
    }
    
    
    /*
     * Adds a user to the database
     *
     * @param user  This is a unique user ID. examples: pennkey, email address, phone number, etc.
     * @param id    This is the id of a cafe, which ranges from "0" to "9"
     */
    static func addUser(user: Member) {
        
        // TIP: Think about the multiple steps required to complete this task.
        
        // TIP: Some useful functions required to complete this task are <database_reference>.queryOrderedByValue(), snapshot.exists(), and <database_reference>.removeValue()
        var key = user_ids
        var newRef = key.child((Auth.auth().currentUser?.uid)!)
        
        
        //convert picture
        var base64String: NSString!
        let myImage = user.picture
        let imageData = UIImageJPEGRepresentation(myImage, 0.9)
        base64String = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed) as NSString!
        
        //find all bike ids
        var bikeIDs: [String] = []
        for bike in user.bikes {
            bikeIDs.append(bike.id)
        }
        
        let newMemberData = [
            "fName": user.fName as NSString,
            "lName": user.lName as NSString,
            "address": user.address as NSString,
            "picture": base64String,
            "bikes": bikeIDs as NSArray,
            "phone_number": user.phoneNumber as NSString,
            "email": user.email as NSString
        ]
        
        newRef.setValue(newMemberData)
        
        //also need to register first bike
        key = objects_by_object_id
        newRef = key.child(bikeIDs[0])
        
        
        
        for bike in user.bikes {
            
            //convert picture
            var base64String: NSString!
            let myImage = bike.picture
            let imageData = UIImageJPEGRepresentation(myImage, 0.9)
            base64String = imageData!.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed) as NSString!
            
            let newBikeData = [
                "name": bike.name as NSString,
                "picture": base64String,
                "description": bike.description as NSString,
                "hourly": bike.hourly as NSNumber,
                "daily": bike.daily as NSNumber,
                "address": bike.address as NSString,
                "ownersid": bike.ownersid as NSString,
                "reserved": bike.reserved as NSString,
                "phone": bike.phone as NSString
            ]
            
            newRef.setValue(newBikeData)
        }
        
       
    }
    
    //
    
    /*
     * Adds a user to the database
     *
     * @param user  This is a unique user ID. examples: pennkey, email address, phone number, etc.
     * @param id    This is the id of a cafe, which ranges from "0" to "9"
 
    static func addUser( user: String, cafe id: String) {
        
        // TIP: Think about the multiple steps required to complete this task.
        
        // TIP: Some useful functions required to complete this task are <database_reference>.queryOrderedByValue(), snapshot.exists(), and <database_reference>.removeValue()
        let key = favRef.child(user)
        let ref = key.queryOrderedByValue()
        ref.queryEqual(toValue: id).observeSingleEvent(of: .value, with: {(snapshot) in
            if snapshot.exists() {
                let autoIdStep = snapshot.value as? NSDictionary;
                let autoId: String = autoIdStep?.allKeys[0] as! String
                key.child(autoId).removeValue()
            } else {
                //add value
                key.childByAutoId().setValue(id);
            }
        })
    }
    */
    /*
     * Pulls all the favorites for a given user from the database as Cafe objects. 
     *
     * @param user  This is a unique user ID. examples: pennkey, email address, phone number, etc.
     * @param callback  Function that is called to asynchronously pass data back to the caller of pullFavorites(..)
 
    static func pullFavorites(for user: String, callback: @escaping (Bike) -> ()) {
        
        // TODO: request for cafe IDs that were stored as favorites for given user.
        
        // TODO: for each favorited cafe id (if any), request for the cafe data from the database, and pass this data as a Cafe object into the callback function
        let key = favRef.child(user)
        let ref = key.queryOrderedByValue()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            // TIP: print snapshot here to see what the returned data looks like.
            print(snapshot)
            for case let cafeSnapshot as DataSnapshot in snapshot.children { // for each coffee_shops entry
                //take snapshot value and request for data
                let key = coffeeRef.child(cafeSnapshot.value as! String)
                key.observeSingleEvent(of: .value, with: { (snapshot) in
                    let cafeData = snapshot.value as? NSDictionary;
                    let name = cafeData?["name"] as? String;
                    let addr = cafeData?["address"] as? String;
                    let location = cafeData?["location"] as? NSDictionary;
                    let lat = location?["lat"] as? Double;
                    let lng = location?["lng"] as? Double;
                    let bik = Bike(id: snapshot.key, name: name!, address: addr!, lat: lat!, lng: lng!)
                    callback(bik)
                })
            }
        })
    }
 
    */
    
    

}
