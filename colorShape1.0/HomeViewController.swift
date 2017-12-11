//
//  ViewController.swift
//  colorShape1.0
//
//  Created by Student on 24/1/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import PCLBlurEffectAlert
import Canvas

enum Mode{
    case mode0
    case mode1
    case mode2
    case mode3
    case mode4
    case mode5
}

var mode = Mode.mode1
var musicOn = false
//var soundEffect = true

class HomeViewController: UIViewController {

    @IBOutlet weak var menuView: UIImageView!
    @IBOutlet weak var playButtonView: CSAnimationView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeButtonView: CSAnimationView!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var soundButtonView: CSAnimationView!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var recordButtonView: CSAnimationView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var modeButtonView: CSAnimationView!
    @IBOutlet weak var modeButton: UIButton!
    
    var timeLabel = UILabel()
    var modeLabel = UILabel()
    var timeLimitation = Float(30.0){
        didSet{
            timeLabel.text = "time: " + String(self.timeLimitation)
        }
    }
    var modeText = "edges"{
        didSet{
            
            modeLabel.text = "mode: " + modeText
        }
    }
    //var start = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingMenu()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HtoPL"{
            let timeAndMusicPasser:PlayViewController = segue.destination as! PlayViewController
            timeAndMusicPasser.timer = timeLimitation
            timeAndMusicPasser.musicOn = musicOn
        }
    }
    
    func settingMenu(){
        menuView.center = CGPoint(x:self.view.center.x,y:self.view.center.y)
        menuView.image = UIImage(named:"menuImage2")?.tint(color: UIColor(red:0.6,green:0.7,blue:0.7,alpha:1),blendMode:.destinationIn)
        
        playButtonView.center = CGPoint(x:self.view.center.x,y:self.view.center.y)
        playButtonView.backgroundColor = UIColor(red:1,green:1,blue:0,alpha:0)
        playButtonView.type = "pop"
        playButtonView.duration = 0.2
        playButtonView.delay = 0
        playButton.frame = CGRect(x:0,y:0,width:100,height:100)
        
        timeButtonView.center = CGPoint(x:self.view.center.x - 44.0,y:self.view.center.y - 78.0)
        timeButtonView.backgroundColor = UIColor(red:1,green:1,blue:0,alpha:0)
        timeButtonView.type = "pop"
        timeButtonView.duration = 0.2
        timeButtonView.delay = 0
        timeButton.frame = CGRect(x:20,y:20,width:60,height:60)
        
        soundButtonView.center = CGPoint(x:self.view.center.x + 43.0,y:self.view.center.y - 78.0)
        soundButtonView.backgroundColor = UIColor(red:1,green:1,blue:0,alpha:0)
        soundButtonView.type = "pop"
        soundButtonView.duration = 0.2
        soundButtonView.delay = 0
        soundButton.frame = CGRect(x:20,y:20,width:60,height:60)
        
        recordButtonView.center = CGPoint(x:self.view.center.x - 44.0,y:self.view.center.y + 78.0)
        recordButtonView.backgroundColor = UIColor(red:1,green:1,blue:0,alpha:0)
        recordButtonView.type = "pop"
        recordButtonView.duration = 0.2
        recordButtonView.delay = 0
        recordButton.frame = CGRect(x:20,y:20,width:60,height:60)
        
        modeButtonView.center = CGPoint(x:self.view.center.x + 43.0,y:self.view.center.y + 78.0)
        modeButtonView.backgroundColor = UIColor(red:1,green:1,blue:0,alpha:0)
        modeButtonView.type = "pop"
        modeButtonView.duration = 0.2
        modeButtonView.delay = 0
        modeButton.frame = CGRect(x:20,y:20,width:60,height:60)
        
        timeLabel.frame = CGRect(x:self.view.center.x-50,y:view.center.y + 140.0,width:100,height:30)
        timeLabel.backgroundColor = UIColor(red:0.6,green:0.7,blue:0.7,alpha:1.0)
        timeLabel.text = "time: " + "30.0"//String(self.timeLimitation)
        timeLabel.layer.cornerRadius = 4
        timeLabel.layer.masksToBounds = true
        self.view.addSubview(timeLabel)

        modeLabel.frame = CGRect(x:self.view.center.x-100,y:view.center.y + 180.0,width:200,height:30)
        modeLabel.backgroundColor = UIColor(red:0.6,green:0.7,blue:0.7,alpha:1.0)
        modeLabel.text = "mode: " + modeText
        modeLabel.layer.cornerRadius = 4
        modeLabel.layer.masksToBounds = true
        self.view.addSubview(modeLabel)
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        playButtonView.startCanvasAnimation()
        //if start{
            self.performSegue(withIdentifier: "HtoPL", sender: nil)
       /* }else {
            let alert = PCLBlurEffectAlert.Controller(title: "choose time first", message: "", effect: UIBlurEffect(style:.extraLight), style: .alert)
            let timeBtn = PCLBlurEffectAlert.AlertAction(title: "cancel", style: .cancel, handler: nil)
            alert.addAction(timeBtn)
            alert.configure(cornerRadius:10)
            alert.configure(overlayBackgroundColor: UIColor(red:0.5,green:0.5,blue:0.5,alpha:0.5))
            alert.configure(titleFont:UIFont.systemFont(ofSize:30),titleColor:UIColor.blue)
            alert.configure(messageFont: UIFont.systemFont(ofSize: 28), messageColor: UIColor.brown)
            alert.show()
        }*/
        
        
    }
    
    @IBAction func timeButtonTapped(_ sender: UIButton) {
        timeButtonView.startCanvasAnimation()
        let alert = PCLBlurEffectAlert.Controller(title: "TIME", message: "", effect: UIBlurEffect(style:.extraLight), style: .alert)
        let time20Btn = PCLBlurEffectAlert.AlertAction(title: "20sec", style: .default, handler: {
            action in
            self.timeLimitation = 20
            //self.start = true
            //print(self.timeLimitation)
        })
        alert.addAction(time20Btn)
        
        let time30Btn = PCLBlurEffectAlert.AlertAction(title: "30sec", style: .default, handler: {
            action in
            self.timeLimitation = 30
            //self.start = true
            //print(self.timeLimitation)
        })
        alert.addAction(time30Btn)
        
        let time60Btn = PCLBlurEffectAlert.AlertAction(title: "60sec", style: .default, handler: {
            action in
            self.timeLimitation = 60
            //self.start = true
            //print(self.timeLimitation)
        })
        alert.addAction(time60Btn)
        
        alert.configure(cornerRadius:10)
        alert.configure(overlayBackgroundColor: UIColor(red:0.5,green:0.5,blue:0.5,alpha:0.5))
        alert.configure(titleFont:UIFont.systemFont(ofSize:30),titleColor:UIColor.blue)
        alert.configure(messageFont: UIFont.systemFont(ofSize: 28), messageColor: UIColor.brown)
        alert.show()

        
    }

    @IBAction func soundButtonTapped(_ sender: UIButton) {
        soundButtonView.startCanvasAnimation()
        
        /*
        let originalV = UIStoryboard(name:"Main",bundle:nil)
        let SV = originalV.instantiateViewController(withIdentifier: "SoundView") as! SoundViewController
        self.present(SV,animated:false,completion: nil)
        */
        let alert = PCLBlurEffectAlert.Controller(title: "music", message: "", effect: UIBlurEffect(style:.extraLight), style: .alert)
        let musicOnBtn = PCLBlurEffectAlert.AlertAction(title: "ON", style: .default, handler: {
            action in
            musicOn = true
        })
        let musicOffBtn = PCLBlurEffectAlert.AlertAction(title: "OFF", style: .default, handler:{
            action in
            musicOn = false
            
        })
        
        alert.addAction(musicOnBtn)
        alert.addAction(musicOffBtn)
        alert.configure(cornerRadius:10)
        alert.configure(overlayBackgroundColor: UIColor(red:0.5,green:0.5,blue:0.5,alpha:0.5))
        alert.configure(titleFont:UIFont.systemFont(ofSize:30),titleColor:UIColor.blue)
        alert.configure(messageFont: UIFont.systemFont(ofSize: 28), messageColor: UIColor.brown)
        alert.show()
        /*
        let alert2 = PCLBlurEffectAlert.Controller(title: "sound effect", message: "", effect: UIBlurEffect(style:.extraLight), style: .alert)
        let effectOnBtn = PCLBlurEffectAlert.AlertAction(title: "ON", style: .default, handler: {
            action in
            soundEffect = true
        })
        let effectOffBtn = PCLBlurEffectAlert.AlertAction(title: "OFF", style: .default, handler:nil)
        
        alert2.addAction(effectOnBtn)
        alert2.addAction(effectOffBtn)
        alert2.configure(cornerRadius:10)
        alert2.configure(overlayBackgroundColor: UIColor(red:0.5,green:0.5,blue:0.5,alpha:0.5))
        alert2.configure(titleFont:UIFont.systemFont(ofSize:30),titleColor:UIColor.blue)
        alert2.configure(messageFont: UIFont.systemFont(ofSize: 28), messageColor: UIColor.brown)
        alert2.show()*/
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        recordButtonView.startCanvasAnimation()
    }
    
    
    @IBAction func modeButtonTapped(_ sender: UIButton) {
        modeButtonView.startCanvasAnimation()
        
        let alert = PCLBlurEffectAlert.Controller(title: "MODE", message: "", effect: UIBlurEffect(style:.extraLight), style: .alert)
        let mode0Btn = PCLBlurEffectAlert.AlertAction(title: "colors", style: .default, handler: {
            action in
            mode = Mode.mode0
            self.modeText = "colors"
        })
        let mode1Btn = PCLBlurEffectAlert.AlertAction(title: "edges", style: .default, handler: {
            action in
            mode = .mode1
            self.modeText = "edges"
        })
        let mode2Btn = PCLBlurEffectAlert.AlertAction(title: "polygonal colors", style: .default, handler:{
            action in
            mode = .mode2
            self.modeText = "polygonal colors"
        })
        let mode3Btn = PCLBlurEffectAlert.AlertAction(title: "rotating edges", style: .default, handler:{
            action in
            mode = .mode3
            self.modeText = "rotating edges"
        })
        let mode4Btn = PCLBlurEffectAlert.AlertAction(title: "rotating colors 1", style: .default, handler:{
            action in
            mode = .mode4
            self.modeText = "rotating shift"
        })
        let mode5Btn = PCLBlurEffectAlert.AlertAction(title: "rotating colors 2", style: .default, handler:{
            action in
            mode = .mode5
            self.modeText = "rotating shift"
        })
        
        alert.addAction(mode0Btn)
        alert.addAction(mode1Btn)
        alert.addAction(mode2Btn)
        alert.addAction(mode3Btn)
        alert.addAction(mode4Btn)
        alert.addAction(mode5Btn)
        
        alert.configure(cornerRadius:10)
        alert.configure(overlayBackgroundColor: UIColor(red:0.5,green:0.5,blue:0.5,alpha:0.5))
        alert.configure(titleFont:UIFont.systemFont(ofSize:30),titleColor:UIColor.blue)
        alert.configure(messageFont: UIFont.systemFont(ofSize: 28), messageColor: UIColor.brown)
        alert.show()
 
    }
}









