//
//  ItemNameViewController.swift
//  Caffinator
//
//  Created by Saur Vasil on 12/1/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import UIKit
import Firebase

class ItemNameViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var bikeNameText: UITextField!
    @IBOutlet weak var bikeDescText: UITextView!
    @IBOutlet weak var bikePhotoButton: UIButton!
    @IBOutlet weak var perHourPicker: UITextField!
    @IBOutlet weak var perDayPicker: UITextField!
    var image: UIImage?;
    var hourlyPickerData: [String] = []
    var dailyPickerData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        /*
        hourlyPickerData = ["$1", "$5", "$10", "$15", "$20", "$25", "$30"]
        dailyPickerData = ["$5", "$10", "$20", "$25", "$30", "$35", "$40"]
        */
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    @IBAction func photoLibrary(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var SamplePhoto: UIButton!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        SamplePhoto.setImage(image, for: UIControlState.normal)
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        let name = bikeNameText.text!
        let picture = image!
        let description = bikeDescText.text!
        let hourly = Double(perHourPicker.text!)
        let daily = Double(perDayPicker.text!)
        let address = (PersonalInfoViewController.newMem?.address)!
        let ownersid = Auth.auth().currentUser?.uid
        let phone = PersonalInfoViewController.newMem?.phoneNumber
        
        //create bike object
        let newBike = Bike(name: name, picture: picture, description: description, hourly: hourly!, daily: daily!, address: address, ownersid: ownersid!, reserved: "0", phone: phone!)
        
        //use to finish new member
        PersonalInfoViewController.newMem?.bikes.append(newBike)
        
        //push new member to cloud associated with this user account
        FirebaseDataManager.addUser(user: PersonalInfoViewController.newMem!)
        
        //go to main view controller
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabView")
        self.present(vc!, animated: true, completion: nil)
        
    }
    
    @IBAction func skip(_ sender: UIButton) {
        //push new member to cloud associated with this user account
        FirebaseDataManager.addUser(user: PersonalInfoViewController.newMem!)
        
        //go to main view controller
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabView")
        self.present(vc!, animated: true, completion: nil)
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
