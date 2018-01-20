//
//  ReserveViewController.swift
//  Caffinator
//
//  Created by Saur Vasil on 12/4/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class ReserveViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    var bike: Bike? = nil;
    @IBOutlet weak var bikeNameLabel: UILabel!
    @IBOutlet weak var ownerNumber: UILabel!
    @IBOutlet weak var bikePhoto: UIButton!
    @IBOutlet weak var bikeDesLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var ownerPhoto: UIButton!
    @IBOutlet weak var costPerHourLabel: UILabel!
    @IBOutlet weak var costPerDayLabel: UILabel!
    var members: [Member] = [Member]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        if (bike != nil) {
            bikeNameLabel.text = bike?.name
            bikePhoto.setImage(bike?.picture, for: UIControlState.normal)
            bikeDesLabel.text = bike?.description
            costPerHourLabel.text = String((bike?.hourly)!)
            costPerDayLabel.text = String((bike?.daily)!)
        }
        
        //get owner from id
        let owner = bike?.ownersid;
        FirebaseDataManager.pullOwner {[weak self] (mem) in
            self?.members.append(mem)
            if (mem.id == owner) {
                self?.ownerPhoto.setImage(mem.picture, for: UIControlState.normal)
                self?.ownerLabel.text = mem.fName + " " + mem.lName
                self?.ownerNumber.text = mem.phoneNumber
            }
        }
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reserveButton(_ sender: UIButton) {
        
        
        let phoneNumber = bike?.phone;
        //make sure to change value of reserved
        FirebaseDataManager.reserve(bike: bike!, user: (Auth.auth().currentUser?.uid)!)
        
        //notify person
        sendSMSText(phoneNumber: phoneNumber!)
        
    }
    
    func sendSMSText(phoneNumber: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [phoneNumber]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        //... handle sms screen actions
        self.dismiss(animated: true, completion: {
            //alert that you have reserved!
            let alertController = UIAlertController(title: "Success", message: "Item has been reserved, and the member has been notified!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                //change view controller
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabView")
                self.present(vc!, animated: true, completion: nil)
                
                
                //self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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
