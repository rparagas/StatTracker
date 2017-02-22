//
//  AddTeamViewController.swift
//  StatTracker-Basketball
//
//  Created by Ray Paragas on 14/12/16.
//  Copyright © 2016 Ray Paragas. All rights reserved.
//

import UIKit
import Firebase


class AddTeamViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamTypeTextField: UITextField!
    @IBOutlet weak var teamDivisionTextField: UITextField!
    @IBOutlet weak var seasonPickerView: UIPickerView!
    @IBOutlet weak var yearPickerView: UIPickerView!
    @IBOutlet weak var addUpdateButton: CustomButton!
    
    var editMode = false
    var preFill = false
    var previousVC = TeamViewController()
    var selectedTeam = Team()
    var seasonOptions = ["Summer", "Autumn", "Winter", "Spring"]
    var yearOptions = [String]()
    
    var selectedSeason = ""
    var selectedYear = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        seasonPickerView.dataSource = self
        seasonPickerView.delegate = self
        yearPickerView.dataSource = self
        yearPickerView.delegate = self
 
        generateYears()
        
        if editMode == true {
            teamNameTextField.text = "\(selectedTeam.teamName)"
            teamTypeTextField.text = "\(selectedTeam.teamType)"
            teamDivisionTextField.text = "\(selectedTeam.teamDivision)"
            selectedYear = selectedTeam.teamYear
            selectedSeason = selectedTeam.teamSeason
            
            addUpdateButton.setTitle("Update", for: .normal)
        }
    }
    
    func findChosenYear() -> Int {
        let chosenYearIndex = yearOptions.index(of: "\(selectedTeam.teamYear)")
        return chosenYearIndex!
    }
    
    func findChosenSeason() -> Int {
        let chosenSeasonIndex = seasonOptions.index(of: "\(selectedTeam.teamSeason)")
        return chosenSeasonIndex!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numRows = 0
        if pickerView == self.seasonPickerView {
            numRows = seasonOptions.count
        }
        if pickerView == self.yearPickerView {
            numRows = 50
        }
        return numRows
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = ""
        if pickerView == self.seasonPickerView {
            title = String(seasonOptions[row])
        }
        if pickerView == self.yearPickerView {
            title = String(yearOptions[row])
        }
        
        if editMode == true && preFill == false {
            preFill = true
            if pickerView == self.seasonPickerView && row == seasonOptions.count-1 {
                seasonPickerView.selectRow(findChosenSeason(), inComponent: 0, animated: true)
            }
            if pickerView == self.yearPickerView && row == yearOptions.count-1 {
                yearPickerView.selectRow(findChosenYear(), inComponent: 0, animated: true)
            }
        }
    
        return title
    }
    
    func generateYears() {
        var year = 16
        for _ in 0...49 {
            yearOptions.append(String(year))
            year += 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.seasonPickerView {
            selectedSeason = String(seasonOptions[row])
        }
        if pickerView == self.yearPickerView {
            selectedYear = String(yearOptions[row])
        }
        
    }
    
    @IBAction func addTeamTapped(_ sender: Any) {
        let uuid = NSUUID().uuidString
        let team = ["teamName":teamNameTextField.text!, "teamType":teamTypeTextField.text!, "teamDivision": teamDivisionTextField.text!, "teamYear": selectedYear, "teamSeason":selectedSeason]
        if editMode == true {
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("teams").child(selectedTeam.teamID).setValue(team)
            previousVC.viewDidLoad()
        } else {
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("teams").child(uuid).setValue(team)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
