//
//  ContainerViewController.swift
//  colorShape1.0
//
//  Created by Student on 24/1/17.
//  Copyright © 2017 Student. All rights reserved.
//

import UIKit
import AVFoundation

var soungEffectPlayer: AVAudioPlayer?

protocol dataTransferProtocol{
    func levelTransfer(level:Int,timeUpTag:Bool)
    func edgesTransfer(edges:Int)
    func timeTransfer(time:Float)
}

class ContainerViewController: UIView {
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    var levelNumber = Int()
    var edgesNumber = Int()
    var outerMargin = CGFloat(8)
    var innerMargin = CGFloat(1)
    var rowCount = CGFloat(2)
    var columnCount = CGFloat()
    var tileSize = CGFloat()
    var time = Float()
    var angle = CGFloat()
    var buttons:[[myButton]] = [[myButton()]]
    var delegate:dataTransferProtocol? = nil
    
    var randomRow = Int()
    var randomColumn = Int()
    var randomRed = Int()
    var randomGreen = Int()
    var randomBlue = Int()
    var randomPath = Int()
    var randomRegularPath = Int()
    var randomPathCaches = [Int]()
    var chosenPath = Int()
    let defaultFrame = CGRect(x: 0, y: 0, width: 140, height: 40)
    var gameOver = false
    var timeUpTag = false
    var timeReduce = Int()
    
    init() {
        super.init(frame:defaultFrame)
        settingTiles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func soundEffect(){
        let bunde = Bundle.main
        let path:String = bunde.path(forResource: "yeahEffect",ofType:"mp3")!
        let url:NSURL = NSURL(fileURLWithPath:path)
        do {
            soungEffectPlayer = try AVAudioPlayer(contentsOf: url as URL)
            
        }
        catch{
            print(error)
        }
        soungEffectPlayer!.numberOfLoops = 1//cycling
        soungEffectPlayer!.prepareToPlay()
        soungEffectPlayer?.play()
    }
    
    func settingTiles(){
        timeReduce = levelNumber/6 + 3
        rowCount = CGFloat(levelNumber/3 + 2)
        columnCount = CGFloat(levelNumber/3 + 2)
        tileSize = (screenWidth-16 - (columnCount-1)*innerMargin)/CGFloat(rowCount)
        buttons = [[myButton]](repeating: [myButton](repeating: myButton(),count: Int(columnCount) ), count: Int(rowCount))
        randomPathCaches = [Int](repeating:Int(),count:Int(columnCount) * Int(rowCount))
        
        let myPath = UIBezierPath()
        myPath.move(to: CGPoint(x:0.0,y:0.0))
        myPath.addLine(to: CGPoint(x:0.0,y:tileSize))
        myPath.addLine(to: CGPoint(x:tileSize,y:tileSize))
        myPath.addLine(to: CGPoint(x:tileSize,y:0))
        
        //init buttons
        if mode == .mode0 {
            randomDataGenerater()
            for i in 0 ..< buttons.count {
                for j in 0 ..< buttons[i].count {
                    buttons[i][j] = myButton()
                    buttons[i][j].frame = CGRect(x:outerMargin + CGFloat(i)*(tileSize + innerMargin),y:outerMargin + CGFloat(j)*(tileSize + innerMargin),width:tileSize,height:tileSize)
                    buttons[i][j].path = myPath
                    //buttons[i][j].pathTag = randomPath
                    buttons[i][j].backgroundColor = UIColor(red:CGFloat(randomRed)/250,green:CGFloat(randomGreen)/250,blue:CGFloat(randomBlue)/250,alpha:1.0)
                    buttons[i][j].layer.cornerRadius = 4
                    buttons[i][j].layer.masksToBounds = true
                    buttons[i][j].layer.borderColor = UIColor(red:1,green:1,blue:1,alpha:1.0).cgColor
                    buttons[i][j].layer.borderWidth = 1
                    buttons[i][j].addTarget(self, action: #selector(self.wrongButtonTouched), for: UIControlEvents.touchUpInside)
                    self.addSubview(buttons[i][j])
                }
            }
            
            buttons[randomRow][randomColumn].backgroundColor =  UIColor(red:(CGFloat(randomRed) + 10)/250,green:(CGFloat(randomGreen) + 10)/250,blue:(CGFloat(randomBlue) + 10)/250,alpha:1.0)
            buttons[randomRow][randomColumn].addTarget(self, action: #selector(self.theChoosenButtonTouched), for: UIControlEvents.touchUpInside)
        }
        
        if mode == .mode1 {
            for i in 0 ..< buttons.count {
                for j in 0 ..< buttons[i].count {
                    randomDataGenerater()
                    buttons[i][j] = myButton()
                    buttons[i][j].frame = CGRect(x:outerMargin + CGFloat(i)*(tileSize + innerMargin),y:outerMargin + CGFloat(j)*(tileSize + innerMargin),width:tileSize,height:tileSize)
                    buttons[i][j].path = self.getPath(eum:randomPath)
                    buttons[i][j].pathTag = randomPath
                    buttons[i][j].backgroundColor = UIColor(red:CGFloat(randomRed)/250,green:CGFloat(randomGreen)/250,blue:CGFloat(randomBlue)/250,alpha:1.0)
                    buttons[i][j].addTarget(self, action: #selector(self.wrongButtonTouched), for: UIControlEvents.touchUpInside)
                    self.addSubview(buttons[i][j])
                    randomPathCaches[i * Int(columnCount) + j] = randomPath
                }
            }
            
            let randomBtnNo = Int(arc4random_uniform(UInt32(rowCount * columnCount)))
            chosenPath = randomPathCaches[randomBtnNo]
            edgesNumber = chosenPath
            
            for i in 0 ..< buttons.count {
                for j in 0 ..< buttons[i].count {
                    if buttons[i][j].pathTag == chosenPath{
                        print("the chosen path is \(chosenPath)")
                        buttons[i][j].addTarget(self, action: #selector(self.theChoosenButtonTouched), for: UIControlEvents.touchUpInside)
                    }
                }
            }
            delegate?.edgesTransfer(edges:edgesNumber)
        }
        
        if mode == .mode2{
            randomDataGenerater()
            for i in 0 ..< buttons.count {
                for j in 0 ..< buttons[i].count {
                    buttons[i][j] = myButton()
                    buttons[i][j].frame = CGRect(x:outerMargin + CGFloat(i)*(tileSize + innerMargin),y:outerMargin + CGFloat(j)*(tileSize + innerMargin),width:tileSize,height:tileSize)
                    buttons[i][j].path = self.getPath(eum:randomPath)
                    buttons[i][j].pathTag = randomPath
                    buttons[i][j].backgroundColor = UIColor(red:CGFloat(randomRed)/250,green:CGFloat(randomGreen)/250,blue:CGFloat(randomBlue)/250,alpha:1.0)
                    buttons[i][j].addTarget(self, action: #selector(self.wrongButtonTouched), for: UIControlEvents.touchUpInside)
                    self.addSubview(buttons[i][j])
                    randomPathCaches[i * Int(columnCount) + j] = randomPath
                }
            }
            
            let randomBtnNo = Int(arc4random_uniform(UInt32(rowCount * columnCount)))
            chosenPath = randomPathCaches[randomBtnNo]
            edgesNumber = chosenPath
          
            buttons[randomRow][randomColumn].backgroundColor = UIColor(red:CGFloat(randomRed+10)/250,green:CGFloat(randomGreen+10)/250,blue:CGFloat(randomBlue+10)/250,alpha:1.0)
            buttons[randomRow][randomColumn].addTarget(self, action: #selector(self.theChoosenButtonTouched), for: UIControlEvents.touchUpInside)
            
            delegate?.edgesTransfer(edges:edgesNumber)
        }
        
        if mode == .mode3 {
            for i in 0 ..< buttons.count {
                for j in 0 ..< buttons[i].count {
                    randomDataGenerater()
                    buttons[i][j] = myButton()
                    buttons[i][j].frame = CGRect(x:outerMargin + CGFloat(i)*(tileSize + innerMargin),y:outerMargin + CGFloat(j)*(tileSize + innerMargin),width:tileSize,height:tileSize)
                    buttons[i][j].path = self.getPath(eum:randomPath)
                    buttons[i][j].pathTag = randomPath
                    buttons[i][j].backgroundColor = UIColor(red:CGFloat(randomRed)/250,green:CGFloat(randomGreen)/250,blue:CGFloat(randomBlue)/250,alpha:1.0)
                    buttons[i][j].addTarget(self, action: #selector(self.wrongButtonTouched), for: UIControlEvents.touchUpInside)
                    self.addSubview(buttons[i][j])
                    randomPathCaches[i * Int(columnCount) + j] = randomPath
                    
                    for _ in 0...3 {
                        UIView.animate(withDuration: 8, animations: {
                            self.buttons[i][j].transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                        })
                        UIView.animate(withDuration: 8, animations: {
                            self.buttons[i][j].transform = CGAffineTransform(rotationAngle: 0)
                        })
                    }
                    
                }
            }
            
            let randomBtnNo = Int(arc4random_uniform(UInt32(rowCount * columnCount)))
            chosenPath = randomPathCaches[randomBtnNo]
            edgesNumber = chosenPath
            
            for i in 0 ..< buttons.count {
                for j in 0 ..< buttons[i].count {
                    if buttons[i][j].pathTag == chosenPath{
                        print("the chosen path is \(chosenPath)")
                        buttons[i][j].addTarget(self, action: #selector(self.theChoosenButtonTouched), for: UIControlEvents.touchUpInside)
                    }
                }
            }
            delegate?.edgesTransfer(edges:edgesNumber)
            
            
        }
        
        if mode == .mode4 {
            randomDataGenerater()
            for i in 0 ..< buttons.count {
                for j in 0 ..< buttons[i].count {
                    
                    buttons[i][j] = myButton()
                    buttons[i][j].frame = CGRect(x:outerMargin + CGFloat(i)*(tileSize + innerMargin),y:outerMargin + CGFloat(j)*(tileSize + innerMargin),width:tileSize,height:tileSize)
                    buttons[i][j].path = self.getPath(eum:randomPath)
                    buttons[i][j].pathTag = randomPath
                    buttons[i][j].backgroundColor = UIColor(red:CGFloat(randomRed)/250,green:CGFloat(randomGreen)/250,blue:CGFloat(randomBlue)/250,alpha:1.0)
                    buttons[i][j].addTarget(self, action: #selector(self.wrongButtonTouched), for: UIControlEvents.touchUpInside)
                    self.addSubview(buttons[i][j])
                    for _ in 0...3 {
                        UIView.animate(withDuration: 8, animations: {
                            self.buttons[i][j].transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                        })
                        UIView.animate(withDuration: 8, animations: {
                            self.buttons[i][j].transform = CGAffineTransform(rotationAngle: 0)
                        })
                    }
                    randomPathCaches[i * Int(columnCount) + j] = randomPath
                }
            }
            
            let randomBtnNo = Int(arc4random_uniform(UInt32(rowCount * columnCount)))
            chosenPath = randomPathCaches[randomBtnNo]
            edgesNumber = chosenPath
            
            buttons[randomRow][randomColumn].backgroundColor = UIColor(red:CGFloat(randomRed+10)/250,green:CGFloat(randomGreen+10)/250,blue:CGFloat(randomBlue+10)/250,alpha:1.0)
            buttons[randomRow][randomColumn].addTarget(self, action: #selector(self.theChoosenButtonTouched), for: UIControlEvents.touchUpInside)
            
            delegate?.edgesTransfer(edges:edgesNumber)
        }
 
        if mode == .mode5{
            randomDataGenerater()
            for i in 0 ..< buttons.count {
                for j in 0 ..< buttons[i].count {
                    
                    buttons[i][j] = myButton()
                    buttons[i][j].frame = CGRect(x:outerMargin + CGFloat(i)*(tileSize + innerMargin),y:outerMargin + CGFloat(j)*(tileSize + innerMargin),width:tileSize,height:tileSize)
                    buttons[i][j].path = self.getPath(eum:randomRegularPath)
                    buttons[i][j].pathTag = randomRegularPath
                    buttons[i][j].backgroundColor = UIColor(red:CGFloat(randomRed)/250,green:CGFloat(randomGreen)/250,blue:CGFloat(randomBlue)/250,alpha:1.0)
                    buttons[i][j].addTarget(self, action: #selector(self.wrongButtonTouched), for: UIControlEvents.touchUpInside)
                    self.addSubview(buttons[i][j])
                    for _ in 0...3 {
                        UIView.animate(withDuration: 8, animations: {
                            self.buttons[i][j].transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                        })
                        UIView.animate(withDuration: 8, animations: {
                            self.buttons[i][j].transform = CGAffineTransform(rotationAngle: 0)
                        })
                    }
                    
                    randomPathCaches[i * Int(columnCount) + j] = randomRegularPath
                }
            }
            
            let randomBtnNo = Int(arc4random_uniform(UInt32(rowCount * columnCount)))
            chosenPath = randomPathCaches[randomBtnNo]
            edgesNumber = chosenPath
            
            buttons[randomRow][randomColumn].backgroundColor = UIColor(red:CGFloat(randomRed+10)/250,green:CGFloat(randomGreen+10)/250,blue:CGFloat(randomBlue+10)/250,alpha:1.0)
            buttons[randomRow][randomColumn].addTarget(self, action: #selector(self.theChoosenButtonTouched), for: UIControlEvents.touchUpInside)
            
            delegate?.edgesTransfer(edges:edgesNumber)
        }
    }
    
    func theChoosenButtonTouched(){
        if !gameOver{
            levelNumber += 1
            
            for tiles in self.subviews{
                tiles.removeFromSuperview()
                
            }
            settingTiles()
            print("the level is \(levelNumber)now" )
        }
        if gameOver {//under the situation that the time is up,if button is tapped then timeUpTag change,it result to present UIAlertController(this class is UIView,so it can not present UIAlertController directly )
            timeUpTag = !timeUpTag
        }
        
        if musicOn{
            soundEffect()
        }
        
        delegate?.levelTransfer(level:levelNumber,timeUpTag: timeUpTag)
        delegate?.timeTransfer(time:(Float(timeReduce)) + 3)
    }
    
    func wrongButtonTouched(){
        
        delegate?.timeTransfer(time:-(Float(timeReduce)))
    }
    
    
    func randomDataGenerater(){
        randomRow = Int(arc4random_uniform(UInt32(rowCount)))
        randomColumn = Int(arc4random_uniform(UInt32(columnCount)))
        randomRed = Int(arc4random_uniform(UInt32(230)))
        randomGreen = Int(arc4random_uniform(UInt32(230)))
        randomBlue = Int(arc4random_uniform(UInt32(230)))
        randomPath = Int(arc4random_uniform(UInt32(6))) + 3
        randomRegularPath = Int(arc4random_uniform(UInt32(5))) + 9
    }
    
    func getPath(eum:Int) -> UIBezierPath {
        let path = UIBezierPath()
        switch eum {
        case 3://path points are constrained in the frame defined earlier.
            path.move(to: CGPoint(x:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3,y:0.0))
            path.addLine(to: CGPoint(x:0.0,y:CGFloat(arc4random_uniform(UInt32(tileSize)))))
            path.addLine(to: CGPoint(x:tileSize,y:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3))
            path.close()
            break
        case 4:
            path.move(to: CGPoint(x:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3,y:0.0))
            path.addLine(to: CGPoint(x:0.0,y:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3))
            path.addLine(to: CGPoint(x:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3,y:tileSize))
            path.addLine(to: CGPoint(x:tileSize,y:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3))
            path.close()
            break
        case 5:
            let randomDown1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomDown2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomDownLong = randomDown1 + tileSize/2
            let randomDownShort = randomDown2
            path.move(to: CGPoint(x:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3,y:0.0))
            path.addLine(to: CGPoint(x:0.0,y:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3))
            path.addLine(to: CGPoint(x:randomDownShort,y:tileSize))
            path.addLine(to: CGPoint(x:randomDownLong,y:tileSize))
            path.addLine(to: CGPoint(x:tileSize,y:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3))
            path.close()
            break
        case 6:
            let randomUp1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomUp2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomDown1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomDown2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomUpLong = randomUp1 + tileSize/2
            let randomUpShort = randomUp2
            let randomDownLong = randomDown1 + tileSize/2
            let randomDownShort = randomDown2
            path.move(to: CGPoint(x:randomUpLong,y:0))
            path.addLine(to: CGPoint(x:randomUpShort,y:0))
            path.addLine(to: CGPoint(x:0.0,y:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3))
            path.addLine(to: CGPoint(x:randomDownShort,y:tileSize))
            path.addLine(to: CGPoint(x:randomDownLong,y:tileSize))
            path.addLine(to: CGPoint(x:tileSize,y:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3))
            path.close()
            break
        case 7:
            let randomUp1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomUp2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomRight1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomRight2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomDown1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomDown2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomUpLong = randomUp1 + tileSize/2
            let randomUpShort = randomUp2
            let randomDownLong = randomDown1 + tileSize/2
            let randomDownShort = randomDown2
            let randomRightLong = randomRight1 + tileSize/2
            let randomRightShort = randomRight2
            path.move(to: CGPoint(x:randomUpLong,y:0.0))
            path.addLine(to: CGPoint(x:randomUpShort,y:0.0))
            path.addLine(to: CGPoint(x:0.0,y:CGFloat(arc4random_uniform(UInt32(tileSize-3)))+3))
            path.addLine(to: CGPoint(x:randomDownShort,y:tileSize))
            path.addLine(to: CGPoint(x:randomDownLong,y:tileSize))
            path.addLine(to: CGPoint(x:tileSize,y:randomRightLong))
            path.addLine(to: CGPoint(x:tileSize,y:randomRightShort))
            path.close()
            break
        case 8:
            let randomUp1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomUp2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomRight1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomRight2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomDown1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomDown2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomLeft1 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomLeft2 = CGFloat(arc4random_uniform(UInt32(tileSize/2 - 2))) + 2
            let randomUpLong = randomUp1 + tileSize/2
            let randomUpShort = randomUp2
            let randomDownLong = randomDown1 + tileSize/2
            let randomDownShort = randomDown2
            let randomRightLong = randomRight1 + tileSize/2
            let randomRightShort = randomRight2
            let randomLeftLong = randomLeft1 + tileSize/2
            let randomLeftShort = randomLeft2
            path.move(to: CGPoint(x:randomUpLong,y:0.0))
            path.addLine(to: CGPoint(x:randomUpShort,y:0.0))
            path.addLine(to: CGPoint(x:0.0,y:randomLeftShort))
            path.addLine(to: CGPoint(x:0.0,y:randomLeftLong))
            path.addLine(to: CGPoint(x:randomDownShort,y:tileSize))
            path.addLine(to: CGPoint(x:randomDownLong,y:tileSize))
            path.addLine(to: CGPoint(x:tileSize,y:randomRightLong))
            path.addLine(to: CGPoint(x:tileSize,y:randomRightShort))
            path.close()
            break
        case 9://regular triangle
            path.move(to: CGPoint(x:tileSize/2,y:0))
            path.addLine(to: CGPoint(x:0.268*tileSize/4,y:3*tileSize/4))
            path.addLine(to: CGPoint(x:3.732*tileSize/4,y:3*tileSize/4))
            path.close()
            break
        case 10://regular rectangle
            path.move(to: CGPoint(x:tileSize/2,y:0.0))
            path.addLine(to: CGPoint(x:0.0,y:tileSize/2))
            path.addLine(to: CGPoint(x:tileSize/2,y:tileSize))
            path.addLine(to: CGPoint(x:tileSize,y:tileSize/2))
            path.close()
            break
        case 11://regular pentagon
            path.move(to: CGPoint(x:tileSize/2,y:0.0))
            path.addLine(to: CGPoint(x:0.05*tileSize,y:0.345*tileSize))
            path.addLine(to: CGPoint(x:0.206*tileSize,y:0.905*tileSize))
            path.addLine(to: CGPoint(x:0.794*tileSize,y:0.905*tileSize))
            path.addLine(to: CGPoint(x:0.95*tileSize,y:0.345*tileSize))
            path.close()
            break
        case 12://regular hexagon
            path.move(to: CGPoint(x:0,y:tileSize/2))
            path.addLine(to: CGPoint(x:tileSize/4,y:tileSize*3.732/4))
            path.addLine(to: CGPoint(x:tileSize*3/4,y:tileSize*3.732/4))
            path.addLine(to: CGPoint(x:tileSize,y:tileSize/2))
            path.addLine(to: CGPoint(x:tileSize*3/4,y:tileSize*0.268/4))
            path.addLine(to: CGPoint(x:tileSize/4,y:tileSize*0.268/4))
            path.close()
            break
        case 13://regular octagon
            path.move(to: CGPoint(x:0.329*tileSize,y:0.03*tileSize))
            path.addLine(to: CGPoint(x:0.03*tileSize,y:tileSize*0.329))
            path.addLine(to: CGPoint(x:0.03*tileSize,y:tileSize*0.671))
            path.addLine(to: CGPoint(x:0.329*tileSize,y:0.97*tileSize))
            path.addLine(to: CGPoint(x:tileSize*0.671,y:0.97*tileSize))
            path.addLine(to: CGPoint(x:0.97*tileSize,y:tileSize*0.671))
            path.addLine(to: CGPoint(x:0.97*tileSize,y:tileSize*0.329))
            path.addLine(to: CGPoint(x:tileSize*0.671,y:0.03*tileSize))
            path.close()
            break
        default:
            break
        }
        return path
    }

}
