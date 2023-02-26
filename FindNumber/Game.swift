//
//  Game.swift
//  FindNumber
//
//  Created by Рустам Т on 1/6/23.
//

import Foundation



enum StatusGame{
    case start
    case win
    case loose
}

class Game{
    
    struct Item{  // все кнопки здесь
        
        var title:String  // имена кнопок
        var isFound = false // нашли/не нашли
        var isError = false // отображение ошибки
        
    }
    
    
    private let data = Array(1...99) // массив чисел, которые используем для игры
    
    var items:[Item] = [] // массив с кнопками, в котором столько кнопок, сколько нужно на экране
    private var countItems:Int // для того, чтобы знать сколько создавать айтемов, создаем свойство, которое                        //будем передавать в ините
    var nextItem:Item? // ? т.к. в конце игры чисел не будет, а будет nil
    
    var timer:Timer? //время на игру
    
    private var updateTimer: ( (StatusGame, Int)->Void)
    
    var isNewRecord = false
    
    var status:StatusGame = .start{
        didSet{
            if status != .start{// если статус изменился, остановить таймер
                if status == .win{
                   let newRecord = timeForGame - secondsGame
                     
                    let record = UserDefaults.standard.integer(forKey: Keys.recordGame)
                    if record == 0 || newRecord < record {
                        UserDefaults.standard.set(newRecord, forKey: Keys.recordGame)
                         isNewRecord = true
                    }
                }
                
                stopGame()
            }
        }
    }
    private var timeForGame:Int
    
    private var secondsGame :Int{
        didSet{
            if secondsGame  == 0{
                status = .loose
            }
            updateTimer(status, secondsGame )
        }
    }
    //в инит передает функцию, которая принимает статус игры и время
    init(countItems: Int, updateTimer:@escaping ( _ status:StatusGame, _ seconds:Int)->Void) {
        self.countItems = countItems
        self.timeForGame = Settings.shared.currentSettings.timeForGame
        self.secondsGame = self.timeForGame
        self.updateTimer = updateTimer
        setupGame()
    }
    
    private func setupGame(){   //функция создает неповторяющиеся айтемы в количестве countItems
        isNewRecord = false
        var digits = data.shuffled() //берем числа о 1..99 и перемешиваем
        items.removeAll()
        while items.count < countItems{
            let item = Item(title: String(digits.removeFirst())) // берем числа с массива digits, и преобразуем их в строку, так как тайтл - стринг и убираем первое число, что бы они не повторялись
            items.append(item)
        }
        nextItem = items.shuffled().first //задаём следующую кнопку
        
        updateTimer(status, secondsGame )
        
        if Settings.shared.currentSettings.timerState{
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] (_) in
                self?.secondsGame  -= 1
            })
        }
    }
    
    func newGame(){  // настраиваю кнопку новая игра
        status = .start
        self.secondsGame = self.timeForGame
        setupGame() // создать айтемы заново
    }
    
    func check(index:Int){ // функция проверяет нашли ли мы нужную кнопку
        guard status == .start else{return}
        if items[index].title == nextItem?.title{ // если индекс массива = кнопки которая горит по центру то
            //прячем найденные кнопки
            items[index].isFound = true
            nextItem = items.shuffled().first(where: {(item) -> Bool in // достаём следующий айтем из тех,
                item.isFound == false}) //что еще не были использованны!
            
        }else{
            items[index].isError = true
        }
        
        if nextItem == nil{  //если следующий айтем = нил, статус - победа, теперь этот статус нужно засунуть в контроллер
            status = .win
        }
    }
     func stopGame(){
        timer?.invalidate()
    }
    
}

extension Int{
    func secondToString()->String{
        let minutes = self / 60
        let seconds = self % 60 // узнаем остаток сек
         
        return String(format: "%d:%02d", minutes, seconds)
    }
}
