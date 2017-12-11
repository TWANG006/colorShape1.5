//
//  PauseViewController.swift
//  colorShape1.0
//
//  Created by Student on 24/1/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit

class PauseViewController: UIViewController {
    var screenWidth = UIScreen.main.bounds.width
    var screenHeight = UIScreen.main.bounds.height
    
    @IBOutlet weak var continueButtonView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var homeButtonView: UIView!
    @IBOutlet weak var homeButton: UIButton!
    
    //var continueButton = UIButton()
    //var homeButton = UIButton()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        settingButtonsInPAV()
    }
    
    func settingButtonsInPAV(){
        continueButtonView.center = CGPoint(x:self.view.center.x-55,y:self.view.center.y-200)
        continueButtonView.backgroundColor = UIColor(red:1,green:1,blue:0.5,alpha:0.0)
        continueButton.frame = CGRect(x:20,y:20,width:60,height:60)
        continueButton.addTarget(self, action: #selector(self.continueButtonTouched), for: UIControlEvents.touchUpInside)
        
        homeButtonView.center = CGPoint(x:self.view.center.x + 55,y:self.view.center.y-200)
        homeButtonView.backgroundColor = UIColor(red:1,green:1,blue:0.5,alpha:0.0)
        homeButton.frame = CGRect(x:20,y:20,width:60,height:60)
        homeButton.addTarget(self, action: #selector(self.homeButtonTouched), for: UIControlEvents.touchUpInside)
    }
    
    func continueButtonTouched(){
        print("continue button is touched")
        dismiss(animated: false, completion: nil)
        audioPlayer?.play()
    }
    
    func homeButtonTouched(){
        //homeButtonView.startCanvasAnimation()
        print("home button is touched")
        let originalV = UIStoryboard(name:"Main",bundle:nil)
        let HV = originalV.instantiateViewController(withIdentifier: "HomeView") as! HomeViewController
        self.present(HV, animated: false, completion: nil)
    }
}

