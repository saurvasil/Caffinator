//
//  MyReservationViewController.swift
//  Caffinator
//
//  Created by Saur Vasil on 12/5/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import UIKit
import Firebase

class MyReservationViewController: UIViewController {
    
    @IBOutlet weak var reservationLabel: UILabel!
    @IBOutlet weak var ownerView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var bikeView: UIView!
    @IBOutlet weak var costView: UIView!
    @IBOutlet weak var bikeNameLabel: UILabel!
    @IBOutlet weak var haveReservedLabel: UILabel!
    @IBOutlet weak var bikePhoto: UIButton!
    @IBOutlet weak var bikeDesLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var ownerPhoto: UIButton!
    @IBOutlet weak var ownerNumber: UILabel!
    @IBOutlet weak var costPerHourLabel: UILabel!
    @IBOutlet weak var titleCostPerHour: UILabel!
    @IBOutlet weak var titleCostPerDay: UILabel!
    @IBOutlet weak var costPerDayLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var members: [Member] = [Member]()
    let bikes = ViewController.bikes;
    var ownersBikes: [Bike] = [];
    var theBike:Bike? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        haveReservedLabel.isHidden = true;
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Perform an action that will only be done once
        let bikes = ViewController.bikes;
        for bike in bikes {
            if (bike.reserved == Auth.auth().currentUser?.uid) {
                theBike = bike;
                //change visibility
                haveReservedLabel.isHidden = true;
                bikeNameLabel.isHidden = false;
                bikePhoto.isHidden = false;
                bikeDesLabel.isHidden = false;
                ownerLabel.isHidden = false;
                ownerPhoto.isHidden = false;
                costPerDayLabel.isHidden = false;
                costPerHourLabel.isHidden = false;
                titleCostPerDay.isHidden = false;
                titleCostPerHour.isHidden = false;
                button.isHidden = false;
                ownerView.isHidden = false;
                bikeView.isHidden = false;
                costView.isHidden = false;
                reservationLabel.isHidden = false;
                buttonView.isHidden = false;
                
                //then user has reserved a bike, show bike
                bikeNameLabel.text = bike.name
                bikePhoto.setImage(bike.picture, for: UIControlState.normal)
                bikeDesLabel.text = bike.description
                costPerHourLabel.text = String((bike.hourly))
                costPerDayLabel.text = String((bike.daily))
                
                //get owner from id
                let owner = bike.ownersid;
                FirebaseDataManager.pullOwner {[weak self] (mem) in
                    self?.members.append(mem)
                    if (mem.id == owner) {
                        self?.ownerPhoto.setImage(mem.picture, for: UIControlState.normal)
                        self?.ownerLabel.text = mem.fName + " " + mem.lName
                        self?.ownerNumber.text = mem.phoneNumber
                    }
                }
                break
            } else {
                //show that user has not reserved bike
                haveReservedLabel.isHidden = false;
                bikeNameLabel.isHidden = true;
                bikePhoto.isHidden = true;
                bikeDesLabel.isHidden = true;
                ownerLabel.isHidden = true;
                ownerPhoto.isHidden = true;
                costPerDayLabel.isHidden = true;
                costPerHourLabel.isHidden = true;
                titleCostPerDay.isHidden = true;
                titleCostPerHour.isHidden = true;
                button.isHidden = true;
                ownerView.isHidden = true;
                bikeView.isHidden = true;
                costView.isHidden = true;
                reservationLabel.isHidden = true;
                buttonView.isHidden = true;

            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func endReservation(_ sender: UIButton) {
        
        FirebaseDataManager.reserve(bike: theBike!, user: "")
        //refresh app
        haveReservedLabel.isHidden = false;
        bikeNameLabel.isHidden = true;
        bikePhoto.isHidden = true;
        bikeDesLabel.isHidden = true;
        ownerLabel.isHidden = true;
        ownerPhoto.isHidden = true;
        costPerDayLabel.isHidden = true;
        costPerHourLabel.isHidden = true;
        titleCostPerDay.isHidden = true;
        titleCostPerHour.isHidden = true;
        button.isHidden = true;
        ownerView.isHidden = true;
        bikeView.isHidden = true;
        costView.isHidden = true;
        reservationLabel.isHidden = true;
        buttonView.isHidden = true;
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
