//
//  RosterViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 14/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class RosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var positionTextField: UITextField!
    @IBOutlet weak var rosterTableView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    
    var selectedPlayer : Player? = nil
    var roster = [Player]()
    var team : Team? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        numberTextField.isHidden = true
        positionTextField.isHidden = true
        updateButton.isHidden = true
        rosterTableView.dataSource = self
        rosterTableView.delegate = self
        rosterTableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roster.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let player = roster[indexPath.row]
        cell.textLabel?.text = "#\(player.playerNumber). \(player.playerFirstName) \(player.playerLastName)"
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlayer = roster[indexPath.row]
        firstNameTextField.isHidden = false
        firstNameTextField.text = selectedPlayer?.playerFirstName
        lastNameTextField.isHidden = false
        lastNameTextField.text = selectedPlayer?.playerLastName
        numberTextField.isHidden = false
        numberTextField.text = selectedPlayer?.playerNumber
        positionTextField.isHidden = false
        positionTextField.text = selectedPlayer?.playerPosition
        updateButton.isHidden = false
    }

    /* FIX
    @IBAction func updateTapped(_ sender: Any) {
        selectedPlayer?.playerFirstName = firstNameTextField.text
        selectedPlayer?.playerLastName = lastNameTextField.text
        selectedPlayer?.playerNumber = numberTextField.text
        selectedPlayer?.playerPosition = positionTextField.text
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        rosterTableView.reloadData()
    }
    */
}
