//
//  TeamViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 14/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import CoreData

class TeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

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
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamsTableView.dataSource = self
        teamsTableView.delegate = self
        
        //generateTestData()
        attemptFetch()
        // Do any additional setup after loading the view.
    }
    
    // tableView delegate functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell (cell: UITableViewCell, indexPath: NSIndexPath) {
        if let item = fetchedResultsController?.object(at: indexPath as IndexPath) as? Team {
            cell.textLabel?.text = item.teamName
        }
    }

    @IBAction func addTeamTapped(_ sender: Any) {
        
    }
    @IBAction func editRosterTapped(_ sender: Any) {
        
    }
    
    // core data fetch functions
    func attemptFetch(){
        setFetchedResults()
        
        do{
            try self.fetchedResultsController?.performFetch()
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
        }
    }
    
    func setFetchedResults(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Team")
        let sortDescriptor = NSSortDescriptor(key: "teamName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        fetchedResultsController = controller
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        teamsTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        teamsTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            if let indexPath = newIndexPath {
                teamsTableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                teamsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = teamsTableView.cellForRow(at: indexPath)
                configureCell(cell: cell!, indexPath: indexPath as NSIndexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                teamsTableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                teamsTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
    }
    
    func generateTestData(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let team = NSEntityDescription.insertNewObject(forEntityName: "Team", into: context) as! Team
        team.teamName = "Scrantonicity"
        
        let team2 = NSEntityDescription.insertNewObject(forEntityName: "Team", into: context) as! Team
        team2.teamName = "Layup Ladies"
        
        let team3 = NSEntityDescription.insertNewObject(forEntityName: "Team", into: context) as! Team
        team3.teamName = "Colliders"
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    

}
