//
//  AddBikeViewController.swift
//  Caffinator
//
//  Created by Saur Vasil on 12/5/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import UIKit
import Firebase

class AddBikeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var bikeNameText: UITextField!
    @IBOutlet weak var bikeDescText: UITextView!
    @IBOutlet weak var bikePhotoButton: UIButton!
    @IBOutlet weak var perHourPicker: UITextField!
    @IBOutlet weak var perDayPicker: UITextField!
    var members: [Member] = [Member]()
    var image: UIImage?;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        
        let name = self.bikeNameText.text!
        let picture = self.image!
        let description = self.bikeDescText.text!
        let hourly = Double(self.perHourPicker.text!)
        let daily = Double(self.perDayPicker.text!)
        
        DispatchQueue.main.async {
            FirebaseDataManager.pullOwner {[weak self] (mem) in
                self?.members.append(mem)
                if (mem.email == Auth.auth().currentUser?.email) {
                    let newMem = mem
                    
                    let address = newMem.address
                    let ownersid = Auth.auth().currentUser?.uid
                    let phone = newMem.phoneNumber
                    
                    //create bike object
                    let newBike = Bike(name: name, picture: picture, description: description, hourly: hourly!, daily: daily!, address: address, ownersid: ownersid!, reserved: "0", phone: phone)
                    
                    FirebaseDataManager.addBike(bike: newBike, userid: (Auth.auth().currentUser?.uid)!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil)
                    self?.dismiss(animated:true, completion: nil)
                }
            }
        }
        
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
