//
//  SignUpViewController.swift
//  Caffinator
//
//  Created by Saur Vasil on 12/1/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit
import FacebookLogin

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var dict : [String : AnyObject]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnFacebookLogic(_ sender: UIButton) {
            let loginManager = LoginManager()
            loginManager.logOut()
        loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: self) { loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                    
                case .cancelled:
                    print("User cancelled login.")
                    
                case .success(let grantedPermissions, _ , _):
                    if (FBSDKAccessToken.current()?.userID != nil) {
                        if grantedPermissions.contains("email") {
                            
                            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"first_name,last_name, email, picture.type(large),id,name,hometown,locale,timezone,gender,birthday"])
                            graphRequest.start(completionHandler: { (connection, result, error) in
                                if (error != nil) {
                                    print("Error \(String(describing: error))")
                                    
                                } else {
                                    print("values received from FB are : \(String(describing: result))")
                                    if let values = result as? NSDictionary {
                                        let email = values.object(forKey: "email") as? NSString
                                        let gender = values.object(forKey: "gender")
                                        let userName = values.object(forKey: "name")
                                        let socialId = values.object(forKey: "id") as! NSString
                                        
                                        //here we should go to next view controller with information prefilled.
                                        
                                        
                                       // print("Email id == \(String(describing: email)) Gender == \(String(describing: gender)) UserName == \(String(describing: userName)) SocialId == \(socialId)")
                                    }
                                }
                            })
                            }
                        }
                    }
                }
            }
    
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func createAccount(_ sender: UIButton) {
        //check if both fields have items entered
        if (emailTextField.text! == "" || passwordTextField.text! == "") {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
                //check for any errors
                if (error == nil) {
                    //send email verification
                    Auth.auth().currentUser?.sendEmailVerification { (error) in
                        if (error == nil) {
                            //present next step
                            //use when implementing background threads..
                            DispatchQueue.main.async {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "personalView")
                                self.present(vc!, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    //Tells the user that there is an error and then gets firebase to tell them the error
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
