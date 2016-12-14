//
//  TeamViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 14/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import CoreData

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
    @IBOutlet weak var editRosterButton: UIButton!
    
    var selectedRoster = [Player]()
    var selectedTeam : Team? = nil
    var teams = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
        
        teamNameLabel.isHidden = true
        playerOneLabel.isHidden = true
        playerTwoLabel.isHidden = true
        playerThreeLabel.isHidden = true
        playerFourLabel.isHidden = true
        playerFiveLabel.isHidden = true
        playerSixLabel.isHidden = true
        playerSevenLabel.isHidden = true
        playerEightLabel.isHidden = true
        playerNineLabel.isHidden = true
        playerTenLabel.isHidden = true
        editRosterButton.isHidden = true
        
        //generateTestData()
    }
    
    func updateDisplayedRoster() {
        teamNameLabel.isHidden = false
        teamNameLabel.text = selectedTeam?.teamName
        let labelArray = [playerOneLabel, playerTwoLabel, playerThreeLabel, playerFourLabel, playerFiveLabel, playerSixLabel, playerSevenLabel, playerEightLabel, playerNineLabel, playerTenLabel]
        var count : Int = 0
        for player in selectedRoster {
            labelArray[count]?.isHidden = false
            labelArray[count]?.text = "#\(player.playerNumber!). \(player.playerFirstName!) \(player.playerLastName!)"
            count = count + 1
        }
        editRosterButton.isHidden = false
    }
    
    func getPlayers(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "team.teamName == %@", (selectedTeam?.teamName)!)
        do {
            selectedRoster = try context.fetch(fetchRequest) as! [Player]
            updateDisplayedRoster()
        } catch {
            print("error")
        }
    }
    
    func getTeams(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            teams = try context.fetch(Team.fetchRequest()) as! [Team]
        } catch {
            print("error")
        }
    }

    // tableView delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let team = teams[indexPath.row]
        cell.textLabel?.text = team.teamName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTeam = teams[indexPath.row]
        getPlayers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getTeams()
        teamsTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRosterSegue" {
            let nextVC = segue.destination as! RosterViewController
            nextVC.team = selectedTeam!
        }
    }
    
    @IBAction func addTeamTapped(_ sender: Any) {
        performSegue(withIdentifier: "addTeamSegue", sender: nil)
    }
    
    @IBAction func editRosterTapped(_ sender: Any) {
        performSegue(withIdentifier: "editRosterSegue", sender: selectedTeam)
    }
    
    func generateTestData(){
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let team = Team(context: context)
        team.teamName = "Layup Ladies"
        
        let player = Player(context: context)
        player.playerFirstName = "Alyssa"
        player.playerLastName = "Magno"
        player.playerNumber = "30"
        player.playerPosition = "F"
        player.team = team
        
        let player2 = Player(context: context)
        player2.playerFirstName = "Liz"
        player2.playerLastName = "Villa"
        player2.playerNumber = "10"
        player2.playerPosition = "G"
        player2.team = team
        
        let player3 = Player(context: context)
        player3.playerFirstName = "Anna"
        player3.playerLastName = "Casta"
        player3.playerNumber = "20"
        player3.playerPosition = "G"
        player3.team = team
        
        let player4 = Player(context: context)
        player4.playerFirstName = "Casse"
        player4.playerLastName = "V"
        player4.playerNumber = "12"
        player4.playerPosition = "F"
        player4.team = team
        
        let player5 = Player(context: context)
        player5.playerFirstName = "Jodie"
        player5.playerLastName = "Lloyd"
        player5.playerNumber = "8"
        player5.playerPosition = "C"
        player5.team = team
    
        let player6 = Player(context: context)
        player6.playerFirstName = "Nicole"
        player6.playerLastName = "B"
        player6.playerNumber = "2"
        player6.playerPosition = "G"
        player6.team = team
        
        let team2 = Team(context: context)
        team2.teamName = "Scrantonicity"
        
        let player7 = Player(context: context)
        player7.playerFirstName = "Alyssa"
        player7.playerLastName = "Magno"
        player7.playerNumber = "21"
        player7.playerPosition = "F"
        player7.team = team2
        
        let player8 = Player(context: context)
        player8.playerFirstName = "Liz"
        player8.playerLastName = "Villa"
        player8.playerNumber = "13"
        player8.playerPosition = "G"
        player8.team = team2
        
        let player9 = Player(context: context)
        player9.playerFirstName = "Anna"
        player9.playerLastName = "Casta"
        player9.playerNumber = "20"
        player9.playerPosition = "G"
        player9.team = team2
        
        let player10 = Player(context: context)
        player10.playerFirstName = "Will"
        player10.playerLastName = "V"
        player10.playerNumber = "15"
        player10.playerPosition = "F"
        player10.team = team2
        
        let player11 = Player(context: context)
        player11.playerFirstName = "Chris"
        player11.playerLastName = "Casa"
        player11.playerNumber = "10"
        player11.playerPosition = "C"
        player11.team = team2
        
        let player12 = Player(context: context)
        player12.playerFirstName = "Jodie"
        player12.playerLastName = "Lloyd"
        player12.playerNumber = "6"
        player12.playerPosition = "G"
        player12.team = team2
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    

}
