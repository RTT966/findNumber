//
//  TimeTableViewController.swift
//  FindNumber
//
//  Created by Рустам Т on 2/25/23.
//

import UIKit

class TimeTableViewController: UITableViewController {

    var data: [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeCell", for: indexPath)
        cell.textLabel?.text = String(data[indexPath.row])
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        Settings.shared.currentSettings.timeForGame = data[indexPath.row ]
        navigationController?.popViewController(animated: true )
    }
  
}
