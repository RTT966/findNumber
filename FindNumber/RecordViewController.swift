//
//  RecordViewController.swift
//  FindNumber
//
//  Created by Рустам Т on 2/25/23.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let record = UserDefaults.standard.integer(forKey: Keys.recordGame)
        if record != 0{
            recordLabel.text = "Ваш рекорд - \(record)"
        }else{
            recordLabel.text = "Рекорд не установлен"
        }
       
    }
    

    
    @IBAction func dis(_ sender: Any) {
        dismiss(animated: true )
    }
    
    
}
