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
    @IBOutlet weak var gameDatePicker: UIDatePicker!
    @IBOutlet weak var periodsPickerView: UIPickerView!
    @IBOutlet weak var lengthPickerView: UIPickerView!
    @IBOutlet weak var saveGameButton: UIButton!
    @IBOutlet weak var opponentNameTextField: UITextField!
    
    var editMode = false
    var preFill = false
    var previousVC = GamesViewController()
    var selectedGame = Game()
    
    var selectedTeam = Team()
    var uuid = ""
    var periodOptions = [2,4]
    var lengthOptions = [10,11,12,13,14,15,16,17,18,19,20]
    var foulsOptions = [4,5,6]
    
    var selectedOpponent = ""
    var selectedLength = ""
    var selectedPeriod = ""
    var selectedDate = ""
    var selectedFoul = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        periodsPickerView.dataSource = self
        periodsPickerView.delegate = self
        lengthPickerView.dataSource = self
        lengthPickerView.delegate = self
        foulPickerView.dataSource = self
        foulPickerView.delegate = self
        saveGameButton.isEnabled = false
        
        if editMode == true {
            opponentNameTextField.text = selectedGame.gameOppTeam
            selectedOpponent = selectedGame.gameOppTeam
            selectedLength = selectedGame.gamePeriodLength
            selectedPeriod = selectedGame.gameNumPeriods
            selectedDate = selectedGame.gameDateTime
            selectedFoul = selectedGame.gameNumFouls
            
            saveGameButton.setTitle("Update", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var numRows = 0
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
        if pickerView == self.periodsPickerView {
            title = String(periodOptions[row])
        }
        if pickerView == self.lengthPickerView {
            title = String(lengthOptions[row])
        }
        if pickerView == self.foulPickerView {
            title = String(foulsOptions[row])
        }
        
        if editMode == true && preFill == false {
            preFill = true
            if pickerView == self.periodsPickerView && row == periodOptions.count-1 {
                periodsPickerView.selectRow(findChosenPeriods(), inComponent: 0, animated: true)
            }
            if pickerView == self.lengthPickerView && row == lengthOptions.count-1 {
                lengthPickerView.selectRow(findChosenLength(), inComponent: 0, animated: true)
            }
            if pickerView == self.foulPickerView && row == foulsOptions.count-1 {
                foulPickerView.selectRow(findChosenFouls(), inComponent: 0, animated: true)
            }
        }
        return title
    }
    
    func findChosenPeriods() -> Int {
        let chosenPeriodIndex = periodOptions.index(of: Int(selectedGame.gameNumPeriods)!)
        return chosenPeriodIndex!
    }
    
    func findChosenLength() -> Int {
        let chosenLengthIndex = lengthOptions.index(of: Int(selectedGame.gamePeriodLength)!)
        return chosenLengthIndex!
    }
    
    func findChosenFouls() -> Int {
        let chosenFoulsIndex = foulsOptions.index(of: Int(selectedGame.gameNumFouls)!)
        return chosenFoulsIndex!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.periodsPickerView {
            selectedPeriod = String(periodOptions[row])
        }
        if pickerView == self.lengthPickerView {
            selectedLength = String(lengthOptions[row])
        }
        if pickerView == self.foulPickerView {
            selectedFoul = String(foulsOptions[row])
        }
        
        if selectedPeriod.isEmpty != true && selectedLength.isEmpty != true && selectedDate.isEmpty != true && selectedFoul.isEmpty != true {
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
        let game = ["gameDate": selectedDate,
                    "gameFouls": selectedFoul,
                    "gameNumPeriods": selectedPeriod,
                    "gameOpponent": opponentNameTextField.text!,
                    "gameOutcome": "undecided",
                    "gamePeriodLength": selectedLength,
                    "gameStatus": "pending"]

        if editMode == true {
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("games").child(selectedTeam.teamID).child(selectedGame.gameID).setValue(game)
            previousVC.viewDidLoad()
        } else {
            let gameResults = createStatsDictionary()
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("games").child(selectedTeam.teamID).child(uuid).setValue(game)
            FIRDatabase.database().reference().child(FIRAuth.auth()!.currentUser!.uid).child("gameResults").child(selectedTeam.teamID).child(uuid).child("opponent").setValue(gameResults)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createStatsDictionary() -> [String:Int] {
        let stats = ["playingTime": 0,
                     "madeOne": 0,
                     "missOne": 0,
                     "madeTwo": 0,
                     "missTwo": 0,
                     "madeThree": 0,
                     "missThree": 0,
                     "assists": 0,
                     "offRebounds": 0,
                     "defRebounds": 0,
                     "steals": 0,
                     "blocks": 0,
                     "fouls": 0,
                     "turnovers": 0]
        return stats
    }
    
}
