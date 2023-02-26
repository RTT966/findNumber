//
//  Settings.swift
//  FindNumber
//
//  Created by Рустам Т on 2/25/23.
//

import Foundation


enum Keys{
    static let settingsGame = "settingsGame"
    static let recordGame = "recordGame"
}


struct SettingsGame: Codable{
    var timerState: Bool
    var timeForGame: Int
}


class Settings{
    
    static var shared = Settings()
    let defaultSettings = SettingsGame(timerState: true, timeForGame: 30)
    var currentSettings: SettingsGame{
        get{
            if let data = UserDefaults.standard.object(forKey: Keys.settingsGame) as? Data{
                return try! PropertyListDecoder().decode(SettingsGame.self, from: data)
            }else{
                if let data = try? PropertyListEncoder().encode(defaultSettings){
                    UserDefaults.standard.set(data, forKey: Keys.settingsGame )
                }
                return defaultSettings
            }
            
        }
        set{
            if let data = try? PropertyListEncoder().encode(newValue){
                UserDefaults.standard.set(data, forKey: Keys.settingsGame )
            }
                
        }
    }
    
    
    func resetSettings(){
        currentSettings = defaultSettings 
    }
}
