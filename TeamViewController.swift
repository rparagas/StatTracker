//
//  TeamViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 14/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var playerThreeLabel: UILabel!
    @IBOutlet weak var playerFourLabel: UILabel!
    @IBOutlet weak var playerFiveLabel: UILabel!
    @IBOutlet weak var playerSixLabel: UILabel!
    @IBOutlet weak var playerSevenLabel: UILabel!
    @IBOutlet weak var playerEightLabel: UILabel!
    @IBOutlet weak var playerNineLabel: UILabel!
    @IBOutlet weak var playerTenLabel: UILabel!
    @IBOutlet weak var teamsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func addTeamTapped(_ sender: Any) {
        
    }
    @IBAction func editRosterTapped(_ sender: Any) {
        
    }

}
