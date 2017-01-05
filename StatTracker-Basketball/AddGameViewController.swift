//
//  AddGameViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 31/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import Firebase

class AddGameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var foulPickerView: UIPickerView!
    @IBOutlet weak var opponentPickerView: UIPickerView!
    @IBOutlet weak var gameDatePicker: UIDatePicker!
    @IBOutlet weak var periodsPickerView: UIPickerView!
    @IBOutlet weak var lengthPickerView: UIPickerView!
    @IBOutlet weak var saveGameButton: UIButton!
    
    var selectedTeam = Team()
    var uuid = ""
    var periodOptions = [2,4]
    var lengthOptions = [10,11,12,13,14,15,16,17,18,19,20]
    var opponentOptions : [Team] = []
    var foulsOptions = [4,5,6]
    
    
    var selectedOpponent = ""
    var selectedLength = ""
    var selectedPeriod = ""
    var selectedDate = ""
    var selectedFoul = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        opponentPickerView.dataSource = self
        opponentPickerView.delegate = self
        periodsPickerView.dataSource = self
        periodsPickerView.delegate = self
        lengthPickerView.dataSource = self
        lengthPickerView.delegate = self
        foulPickerView.dataSource = self
        foulPickerView.delegate = self
        getTeams()
        saveGameButton.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    func getTeams() {
        FIRDatabase.database().reference().child("teams").observe(FIRDataEventType.childAdded, with: {(snapshot) in
            let team = Team()
            if (snapshot.value as! NSDictionary)["teamName"] as! String != self.selectedTeam.teamName {
                team.teamID = snapshot.key
                team.teamName = (snapshot.value as! NSDictionary)["teamName"] as! String
                self.opponentOptions.append(team)
                self.opponentPickerView.reloadAllComponents()
            }
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numRows = 0
        if pickerView == self.opponentPickerView {
            numRows = opponentOptions.count
        }
        if pickerView == self.periodsPickerView {
            numRows = periodOptions.count
        }
        if pickerView == self.lengthPickerView {
            numRows = lengthOptions.count
        }
        if pickerView == self.foulPickerView {
            numRows = foulsOptions.count
        }
        return numRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        if pickerView == self.opponentPickerView {
            title = opponentOptions[row].teamName
        }
        if pickerView == self.periodsPickerView {
            title = String(periodOptions[row])
        }
        if pickerView == self.lengthPickerView {
            title = String(lengthOptions[row])
        }
        if pickerView == self.foulPickerView {
            title = String(foulsOptions[row])
        }
        return title
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.opponentPickerView {
            selectedOpponent = opponentOptions[row].teamID
        }
        if pickerView == self.periodsPickerView {
            selectedPeriod = String(periodOptions[row])
        }
        if pickerView == self.lengthPickerView {
            selectedLength = String(lengthOptions[row])
        }
        if pickerView == self.foulPickerView {
            selectedFoul = String(foulsOptions[row])
        }
        
        if selectedOpponent.isEmpty != true && selectedPeriod.isEmpty != true && selectedLength.isEmpty != true && selectedDate.isEmpty != true && selectedFoul.isEmpty != true {
            saveGameButton.isEnabled = true
        }
    }
    
    @IBAction func dateSelected(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: gameDatePicker.date)
        self.selectedDate = strDate
    }

    
    @IBAction func saveGameTapped(_ sender: Any) {
        uuid = NSUUID().uuidString
        let game = ["gameOpponent": selectedOpponent, "gameDate": selectedDate, "gameNumPeriods": selectedPeriod, "gamePeriodLength": selectedLength, "gameFouls": selectedFoul, "gameStatus": "pending"]
        print(game)
        FIRDatabase.database().reference().child("games").child(selectedTeam.teamID).child(uuid).setValue(game)
        navigationController?.popViewController(animated: true)
    }
    
}
