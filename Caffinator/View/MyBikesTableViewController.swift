//
//  MyBikesTableViewController.swift
//  Caffinator
//
//  Created by Saur Vasil on 12/5/17.
//  Copyright © 2017 cis195. All rights reserved.
//

import UIKit
import Firebase

class MyBikesTableViewController: UITableViewController {
    
    //var bikes = ViewController.bikes;
    var ownersBikes: [Bike] = [];
    //var firstTime = true;

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.hideKeyboardWhenTappedAround() 
        //now have all bikes for the user, so display.
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
       // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func loadList(){
        //load data here
        self.tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ownersBikes = []
        var done = false;
        // Perform an action that will only be done once
        var bikes:[Bike] = [];
        
        
        FirebaseDataManager.pullObjects {[weak self] (bike) in
            //make markers
            if (!bikes.contains(bike)) {
                bikes.append(bike)
            }
            
            DispatchQueue.main.async {
                if (done == true) {
                    return;
                }
                for bike in bikes {
                    if (bike.ownersid == Auth.auth().currentUser?.uid) {
                        //then this bike is an owners bike, add to owners bike array
                        self?.ownersBikes.append(bike)
                    }
                }
                self?.tableView.reloadData()
                done = true;
                return;
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ownersBikes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOwn", for: indexPath)
        cell.textLabel?.text = ownersBikes[indexPath.row].name
        cell.imageView?.image = ownersBikes[indexPath.row].picture
        if (ownersBikes[indexPath.row].reserved == "0") {
             cell.detailTextLabel?.text = "Not reserved."
        } else {
            cell.detailTextLabel?.text = "Reserved."
        }
        return cell
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        //add new bike
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FirebaseDataManager.removeBike(bike: ownersBikes[indexPath.row])
            ownersBikes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
