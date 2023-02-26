//
//  SettingsTableViewController.swift
//  FindNumber
//
//  Created by Рустам Т on 2/25/23.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    @IBOutlet weak var switchTimer: UISwitch!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
    }

    @IBAction func switchTimerState(_ sender: UISwitch) {
        Settings.shared.currentSettings.timerState = sender.isOn
    }
    
    @IBAction func defaultSettings(_ sender: UIButton) {
        Settings.shared.resetSettings()
        loadSettings()
    }
    
    
    func loadSettings(){
        timeLabel.text = "\(Settings.shared.currentSettings.timeForGame) сек"
        switchTimer.isOn = Settings.shared.currentSettings.timerState
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "selectTime" else {return}
        let vc = segue.destination as? TimeTableViewController
        vc?.data = [10,20,30,40,50,60,70,80,90,100,110,120]
    }

    

}
