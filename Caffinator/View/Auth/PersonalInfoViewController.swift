//
//  PersonalInfoViewController.swift
//  Caffinator
//
//  Created by Saur Vasil on 12/2/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import UIKit
import Firebase

class PersonalInfoViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    @IBOutlet weak var firstNameText: UITextField!
    @IBOutlet weak var lastNameText: UITextField!
    @IBOutlet weak var addressLine1: UITextField!
    @IBOutlet weak var addressLine2: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var zipText: UITextField!
    @IBOutlet weak var stateText: UITextField!
    var image: UIImage?;
    static var newMem: Member?;
    
    @IBOutlet weak var phoneNUmber: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takeSelfPhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    @IBOutlet weak var SamplePhoto: UIButton!
    
    @IBAction func choosePhotoLibrary(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        SamplePhoto.setImage(image, for: UIControlState.normal)
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        let fName = firstNameText.text!
        let lName = lastNameText.text!
        let address = addressLine1.text! + " " + addressLine2.text! + " " + cityText.text! + " " + stateText.text!
        let picture = image!
        let phoneNumber = phoneNUmber.text!
        let bikes : [Bike] = []
        let email = Auth.auth().currentUser?.email!
        PersonalInfoViewController.newMem = Member(fName: fName, lName: lName, address: address, picture: picture, phoneNumber: phoneNumber, bikes: bikes, email: email!)
        performSegue(withIdentifier: "toItem", sender: sender)
        
    }
    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toItem") {
            let vc = segue.destination as! ItemNameViewController
            if (PersonalInfoViewController.newMem == nil) {
                print("error")
            } else {
                vc.member = PersonalInfoViewController.newMem
            }
        }
    }
    */

}
