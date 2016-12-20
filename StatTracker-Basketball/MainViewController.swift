//
//  ViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 14/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {
    
    var selectedRoster = [Player]()
    var selectedTeam : Team? = nil
    var teams = [Team]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getPlayers(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Player")
        fetchRequest.predicate = NSPredicate(format: "team.teamName == %@", (selectedTeam?.teamName)!)
        do {
            selectedRoster = try context.fetch(fetchRequest) as! [Player]
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
    
    

}

