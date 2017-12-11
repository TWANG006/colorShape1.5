//
//  PlayViewController.swift
//  colorShape1.0
//
//  Created by Student on 24/1/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import Canvas
import AVFoundation
import PCLBlurEffectAlert

var audioPlayer: AVAudioPlayer?
var rightButtonTapped = false

class PlayViewController: UIViewController,dataTransferProtocol{
    var container = ContainerViewController()//(level:Int(),gameOverOrNot:Bool())
    let screenWidth = min(UIScreen.main.bounds.width,UIScreen.main.bounds.height)
    let screenHeight = max(UIScreen.main.bounds.width,UIScreen.main.bounds.height)
    var alertOfTimeUp = UIAlertController()
    var counter = Timer()
    var timer = Float()
    var timerLabelText = String()
    let timeStep = 0.1
    var musicOn = false
    
    


    @IBOutlet weak var timeChangeView: CSAnimationView!
    @IBOutlet weak var homeButtonView: UIView!
    @IBOutlet weak var pauseButtonView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var timeChangeLabel: UILabel!
    @IBOutlet weak var timeReduceLabelView: CSAnimationView!
    @IBOutlet weak var timeReduceLabel: UILabel!
    @IBOutlet weak var musicButton = UIButton()
    var timerLabel = UILabel()
    var levelLabel = UILabel()
    var colorLabel = UILabel()
    var edgesLabel = UILabel()
    var gameOverTag = false
    var edgesNumber = Int()
    
    var levelNumber = Int(){
        didSet{
            levelLabel.text = "level: " + String(container.levelNumber)//everytime the level upgrade, the levelLabel would refresh
            //it can be written like this: levelLabel.text = "level: " + String(levelNumber)
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingButtonsInPLV()
        //settingTimer()//start counting as soon as the view loaded
        settingContainer()
        if musicOn {
            settingMusic()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        settingTimer()//in order to restart when reappear from pauseViewController,if setted in viewDidLoad, the would hold still after reapear from oause view
    }
    
    func settingMusic(){
        let bunde = Bundle.main
        let path:String = bunde.path(forResource: "myGameMusic",ofType:"mp3")!
        let url:NSURL = NSURL(fileURLWithPath:path)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
            
        }
        catch{
            print(error)
        }
        audioPlayer!.numberOfLoops = -1//cycling
        audioPlayer!.prepareToPlay()
        audioPlayer?.play()
    }
    
    func settingButtonsInPLV(){
        homeButtonView.center = CGPoint(x:self.view.center.x-130,y:self.view.center.y-280)
        homeButtonView.backgroundColor = UIColor(red:1,green:1,blue:0.5,alpha:0)
        homeButton.frame = CGRect(x:30,y:30,width:40,height:40)
        homeButton.addTarget(self, action: #selector(self.homeButtonTouched), for: UIControlEvents.touchUpInside)
        
        pauseButtonView.center = CGPoint(x:self.view.center.x + 130,y:self.view.center.y-280)
        pauseButtonView.backgroundColor = UIColor(red:1,green:1,blue:0,alpha:0)
        pauseButton.frame = CGRect(x:45,y:30,width:40,height:40)
        pauseButton.addTarget(self, action: #selector(self.pauseButtonTouched), for: UIControlEvents.touchUpInside)
        musicButton?.center = CGPoint(x:self.view.center.x + 130,y:self.view.center.y-280)
        musicButton?.backgroundColor = UIColor(red:1,green:1,blue:0,alpha:0)
        musicButton?.frame = CGRect(x:0,y:30,width:40,height:40)
        musicButton?.addTarget(self, action: #selector(self.musicButtonTouched), for: UIControlEvents.touchUpInside)
        
        timerLabel.frame = CGRect(x:10,y:100,width:130,height:30)
        timerLabel.backgroundColor = UIColor(red:0.6,green:0.7,blue:0.7,alpha:1.0)
        timerLabel.layer.cornerRadius = 4
        timerLabel.layer.masksToBounds = true
        self.view.addSubview(timerLabel)
        
        levelLabel.frame = CGRect(x:screenWidth/2 - 50,y:50,width:100,height:30)
        levelLabel.backgroundColor = UIColor(red:0.6,green:0.7,blue:0.7,alpha:1.0)
        levelLabel.text = "level: " + String(levelNumber)
        levelLabel.layer.cornerRadius = 4
        levelLabel.layer.masksToBounds = true
        self.view.addSubview(levelLabel)
        
        edgesLabel.frame = CGRect(x:screenWidth - 140,y:100,width:130,height:30)
        edgesLabel.backgroundColor = UIColor(red:0.6,green:0.7,blue:0.7,alpha:1.0)
        edgesLabel.text = "edges: lucky try" //+ String(container.edgesNumber)
        edgesLabel.layer.cornerRadius = 4
        edgesLabel.layer.masksToBounds = true
        self.view.addSubview(edgesLabel)
        
    }
    
    func homeButtonTouched(){
        print("home button is touched")
        counter.invalidate()
        let originalV = UIStoryboard(name:"Main",bundle:nil)
        let HV = originalV.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
        self.present(HV, animated: false, completion: nil)
        audioPlayer?.stop()
    }
    
    func pauseButtonTouched(){
        print("pause button is touched")
        let originalV = UIStoryboard(name:"Main",bundle:nil)
        let PAV = originalV.instantiateViewController(withIdentifier: "PauseView") as! PauseViewController
        self.present(PAV,animated:false,completion: nil)
        
        counter.invalidate()
        audioPlayer?.pause()
    }
    
    func musicButtonTouched(){
        let alert = PCLBlurEffectAlert.Controller(title: "music", message: "", effect: UIBlurEffect(style:.extraLight), style: .alert)
        let musicOnBtn = PCLBlurEffectAlert.AlertAction(title: "ON", style: .default, handler: {
            action in
            self.musicOn = true
            self.settingMusic()
        })
        let musicOffBtn = PCLBlurEffectAlert.AlertAction(title: "OFF", style: .default, handler:{
            action in
            self.musicOn = false
            audioPlayer?.stop()
            
        })
        
        alert.addAction(musicOnBtn)
        alert.addAction(musicOffBtn)
        alert.configure(cornerRadius:10)
        alert.configure(overlayBackgroundColor: UIColor(red:0.5,green:0.5,blue:0.5,alpha:0.5))
        alert.configure(titleFont:UIFont.systemFont(ofSize:30),titleColor:UIColor.blue)
        alert.configure(messageFont: UIFont.systemFont(ofSize: 28), messageColor: UIColor.brown)
        alert.show()

    }
    
    func settingTimer(){
        if !counter.isValid {
            counter = Timer.scheduledTimer(timeInterval: timeStep, target: self, selector: #selector(PlayViewController.timerCountDown), userInfo: nil, repeats: true)
        }
    }
    
    func timerCountDown() {
        timerLabelText = String(format:"%.1f",timer)
        timerLabel.text = "time left: " + timerLabelText
        
        if timer >= 0.1 {
            timer -= 0.1
        }
        if (timer < 0.1) {
            
            timer = 0.0
            counter.invalidate()
            container.gameOver = true
            
            alertOfTimeUp = UIAlertController(title: "Time's up", message: "Please try again", preferredStyle: UIAlertControllerStyle.alert)
            let menuAction = UIAlertAction(title: "menu", style: UIAlertActionStyle.default, handler:
                { action in
                    let originalV = UIStoryboard(name:"Main",bundle:nil)
                    let HV = originalV.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
                    self.present(HV, animated: false, completion: nil)
            })
            /*
            let retryAction = UIAlertAction(title: "retry", style: UIAlertActionStyle.default, handler:
                { action in
                    self.levelNumber = 0
                    self.timer = 60.0
                    let originalV = UIStoryboard(name:"Main",bundle:nil)
                    let HV = originalV.instantiateViewController(withIdentifier: "PlayView") as! PlayViewController
                    self.present(HV, animated: false, completion: nil)
            })
            let saveAction = UIAlertAction(title: "save record", style: UIAlertActionStyle.default, handler:
                { action in
                    
            })*/
            alertOfTimeUp.addAction(menuAction)
            //alertOfTimeUp.addAction(retryAction)
            //alertOfTimeUp.addAction(saveAction)
            self.present(alertOfTimeUp, animated: true, completion:nil)
            audioPlayer?.stop()
        }
    }
    
    func levelTransfer(level:Int,timeUpTag:Bool){
        levelNumber = level
        if gameOverTag != timeUpTag{
            self.present(alertOfTimeUp, animated: true, completion:nil)//if time is up,everytime the button is tapped,the alert would present
        }
        gameOverTag = timeUpTag
    }
    
    func edgesTransfer(edges:Int){
        edgesNumber = edges
        edgesLabel.text = "edges: " + String(container.edgesNumber)
    }
    
    func timeTransfer(time:Float){
        timer += time
        if timer < 0{
            timer = 0.0
        }
    
        //myTimeTag = time
        if time > 0{
            timeChangeView.startCanvasAnimation()
        }
        
        if time < 0 && !rightButtonTapped{
            
            //timeReduceLabelView.startCanvasAnimation()
            
        }
    }
    
    func settingContainer(){
        container = ContainerViewController()//(level:levelNumber,gameOverOrNot:gameOver)
        container.delegate = self
        container.frame = CGRect(x:0,y:screenHeight/2-screenWidth/2,width:screenWidth,height:screenWidth)
        container.backgroundColor = UIColor(red:0.8,green:1,blue:1,alpha:1.0)
        container.layer.cornerRadius = 6
        container.layer.masksToBounds = true
        self.view.addSubview(container)
        
    }
}

