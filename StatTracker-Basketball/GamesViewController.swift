//
//  GamesViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 31/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import Firebase

class GamesViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var gamesTableView: UITableView!
    @IBOutlet weak var teamsPickerView: UIPickerView!
    @IBOutlet weak var newGameButton: UIBarButtonItem!
    
    var teams = [Team]()
    var selectedTeamGames = [Game]()
    var selectedTeam : Team? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamsPickerView.delegate = self
        teamsPickerView.dataSource = self
        gamesTableView.delegate = self
        gamesTableView.dataSource = self
        getTeams()
        newGameButton.isEnabled = false

        // Do any additional setup after loading the view.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return teams.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let team = teams[row]
        return team.teamName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTeam = teams[row]
        if selectedTeam != nil {
            newGameButton.isEnabled = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTeamGames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let game = Game()
        cell.textLabel?.text = "\(game.oppTeam) - \(game.gameDateTime)"
        return cell
    }
    
    func getTeams() {
        FIRDatabase.database().reference().child("teams").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let team = Team()
            team.teamID = snapshot.key
            team.teamName = (snapshot.value as! NSDictionary)["teamName"] as! String
            self.teams.append(team)
            self.teamsPickerView.reloadAllComponents()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! AddGameViewController
        nextVC.selectedTeam = sender as! Team
    }
    
    @IBAction func newGameTapped(_ sender: Any) {
        performSegue(withIdentifier: "newGameSegue", sender: selectedTeam)
    }
    
}
