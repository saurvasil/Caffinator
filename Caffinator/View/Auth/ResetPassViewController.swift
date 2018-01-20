//
//  ResetPassViewController.swift
//  Caffinator
//
//  Created by Saur Vasil on 12/1/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import UIKit
import Firebase

class ResetPassViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
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
    
    @IBAction func resetPassAction(_ sender: UIButton) {
        
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { (error) in
            if (error == nil) {
                let alertController = UIAlertController(title: "Password Reset", message: "Please look in your email to reset your password.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        dismiss(animated: true, completion: nil)
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
