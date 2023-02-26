//
//  GameViewController.swift
//  FindNumber
//
//  Created by Рустам Т on 1/6/23.
//

import UIKit

class GameViewController: UIViewController {
    
    
    @IBOutlet var buttons: [UIButton]!//кнопки
    
    @IBOutlet weak var nextDigit: UILabel!//кнопка показывающая цифру
   
    @IBOutlet weak var statusLabel: UILabel! //статус
    @IBOutlet weak var timerLabel: UILabel!//таймер
    
    @IBOutlet weak var newGameButton: UIButton!
    lazy var game = Game(countItems: buttons.count) {[weak self] (status, time) in
        guard let self = self else {return}
        self.timerLabel.text = time.secondToString()
        self.updateInfoGame(with: status)
    } // количество айтемов на экране = количеству кнопок в контроллере. lazy, что бы не было ошибки, т.к. ссылки на кнопки ещё не сделаны
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupScreen()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        game.stopGame()
    }
    
    @IBAction func pressButton(_ sender: UIButton){
        guard let buttonIndex = buttons.firstIndex(of: sender) else {return}// узнаем индекс кнопки, //которую нажали
        
        
        game.check(index:buttonIndex)//замутим функцию, которая будет передавать индекс нажатой кнопки
        
        
        updateUI() //обновляет экран, убирает найденные кнопки и вставляет новую цифру
        
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        sender.isHidden = true
        setupScreen()
    }
    private func setupScreen(){ // пробежать по массиву items и присвоить кнопкам нужное свойство
        for index in game.items.indices{ // будем брать айтем по индексу
            buttons[index].setTitle(game.items[index].title, for: .normal)//берем button -> задаём ему titl
                                                                    // таким образом меняем цифру на кнопке
           // buttons[index].isHidden = false // делаем кнопку видимой
            buttons[index].alpha = 1
            buttons[index].isEnabled = true 
            
            
        }
        nextDigit.text = game.nextItem?.title // помещаем эту суету в функцию, которая присваивает значения кнопкам и задаёт значение той кнопки, которая показывает какую цифру нужно убрать и всё. на этом этапе ничего не меняется!
    }
    
    private func updateUI(){ //обновляет экран, убирает найденные кнопки и вставляет новую цифру
        for index in game.items.indices{
           // buttons[index].isHidden = game.items[index].isFound //если кнопка по индексу скрыта, то в массиве кнопок она считается найденной, а если она найдена то она true, а если она true, то она исключается блять, так как кнопка исчезает и автоматически все кнопки подстраиваются под исчезнувшую кнопку, эту механику нужно изменить
            
            
            buttons[index].alpha = game.items[index].isFound ? 0 : 1 // делает кнопку прозрачной
            buttons[index].isEnabled = !game.items[index].isFound
            if game.items[index].isError{  // если кнопку неправильно нажали - подсветиться красным
                UIView.animate(withDuration:  0.3) {[weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: {[weak self] ( _) in
                    self?.buttons[index].backgroundColor = .white
                    self?.game.items[index].isError = false
                }

            }
            
        }
        nextDigit.text = game.nextItem?.title // эта суета обновляет значение кнопки, которая показывает цифры на экране
        
        updateInfoGame(with: game.status) // передаем эту функцию, что меняет лейбл
        
    }
    
    func updateInfoGame(with status:StatusGame){  //функция меняет лейбл в зависимости от статуса
        switch status{
        case .start:
            statusLabel.text = "Игра началась"
            statusLabel.textColor = .systemPink
            newGameButton.isHidden = true
        case .win:
            statusLabel.text = "Победа"
            statusLabel.textColor = .red
            newGameButton.isHidden = false
            if game.isNewRecord{
                getAlert()
            }else{
                showActionSheet()
            }
        case .loose:
            statusLabel.text = "Проигрыш"
            statusLabel.textColor = .magenta
            newGameButton.isHidden = false
            showActionSheet()
            
        }
    }
    private func getAlert(){
        let alert = UIAlertController(title: "Поздравляю", message: "Вы установили новый рекорд", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showActionSheet(){
        let alert = UIAlertController(title: "Следующее действие?", message: nil, preferredStyle: .actionSheet)
        let newGameAction = UIAlertAction(title: "Начать новую игру?", style: .default) { [weak self] (_) in
            self?.game.newGame()
            self?.setupScreen()
        }
        let showRecord = UIAlertAction(title: "Показать рекорд", style: .default) {[weak self] _ in
            self? .performSegue(withIdentifier: "presentRecord", sender: nil)
        }
        
        let menu = UIAlertAction(title: "Меню", style: .destructive) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
            
        }
        let cancel = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menu)
        alert.addAction(cancel)
        present(alert, animated: true)
        
        if let popover = alert.popoverPresentationController{
            popover.sourceView = statusLabel
            
        }
    }
}



 
