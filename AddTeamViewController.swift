//
//  AddTeamViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 14/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import Firebase

class AddTeamViewController: UIViewController {
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamTypeTextField: UITextField!
    @IBOutlet weak var teamDivisionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTeamTapped(_ sender: Any) {
        let uuid = NSUUID().uuidString
        let team = ["teamName":teamNameTextField.text!, "teamType":teamTypeTextField.text!]
        FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("teams").child(uuid).setValue(team)
        navigationController?.popViewController(animated: true)
    }
}
