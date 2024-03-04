//
//  ViewController.swift
//  Capture The Calo
//
//  Created by Ahmed Emrah Calayır on 2.03.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    
    
    @IBOutlet weak var kenny1: UIImageView!
    @IBOutlet weak var kenny2: UIImageView!
    @IBOutlet weak var kenny3: UIImageView!
    @IBOutlet weak var kenny4: UIImageView!
    @IBOutlet weak var kenny5: UIImageView!
    @IBOutlet weak var kenny6: UIImageView!
    @IBOutlet weak var kenny7: UIImageView!
    @IBOutlet weak var kenny8: UIImageView!
    @IBOutlet weak var kenny9: UIImageView!
    
    var timer = Timer()
    var kennyTimer = Timer()
    var counter = 10
    var score = 0
    var highScore = 0
    var kennysArray = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //highscore check
        
        let storedHighscore = UserDefaults.standard.object(forKey: "highscore")
        if storedHighscore == nil {
            highScore = 0
            highscoreLabel.text = "Highscore: \(highScore)"
        }
        
        if let newScore = storedHighscore as? Int {
            highScore = newScore
            highscoreLabel.text = "Highscore: \(highScore)"
        }
        
        timerLabel.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounter), userInfo: nil, repeats: true)
        kennyTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(kennyHidden), userInfo: nil, repeats: true)
        
        scoreLabel.text = "Score: \(score)"
        kennysArray = [kenny1,kenny2,kenny3,kenny4,kenny5,kenny6,kenny7,kenny8,kenny9]

    
        for kenny in kennysArray{
            makeKennysActive(kenny: kenny, name: "kennyRecognized")
        }
       
        kennyHidden()
    }
    
    @objc func kennyHidden(){
        for kenny in kennysArray{
            kenny.isHidden = true
        }
        
        let random = Int(arc4random_uniform(UInt32(kennysArray.count - 1)))
        kennysArray[random].isHidden = false
    }
    
    func makeKennysActive(kenny: UIImageView, name: String)
    {
        kenny.isUserInteractionEnabled = true
        let name = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        kenny.addGestureRecognizer(name)
    }
    
    @objc func increaseScore(){
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    @objc func timeCounter(){
        timerLabel.text = "\(counter)"
        counter -= 1
        if(counter < 0){
            timer.invalidate()
            kennyTimer.invalidate()
            if score > highScore {
                highScore = score
                highscoreLabel.text = "Highscore: \(highScore)"
                UserDefaults.standard.setValue(highScore, forKey: "highscore")
            }
            for kenny in kennysArray{
                kenny.isHidden = true
            }
            gameFinished(title: "Time's Up!", message: "Dou you want to play again?")
        }
    }

    func gameFinished(title: String, message: String)
    {
        let gameFinishAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { UIAlertAction in
            //replay button
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
            self.counter = 10
            self.timerLabel.text = String(self.counter)
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeCounter), userInfo: nil, repeats: true)
            self.kennyTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.kennyHidden), userInfo: nil, repeats: true)
        }
        gameFinishAlert.addAction(okButton)
        gameFinishAlert.addAction(replayButton)
        self.present(gameFinishAlert, animated: true, completion: nil)
    }
}
