//
//  HomeViewController.swift
//  Jamb
//
//  Created by Saša Brezovac on 23.01.2018..
//  Copyright © 2018. Saša Brezovac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HomeViewController: UIViewController {
    
    var scoreArrays = [[String]]()
    var savedData = RankingHelper.getArrayData()!
    
    
    //MARK: - Outlets
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var rulesBtn: UIButton!
    @IBOutlet weak var rankingsBtn: UIButton!
    
    var player: AVAudioPlayer!
    var playerIntroSong: AVAudioPlayer!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        savedData.removeAll()
        
        self.navigationController?.isNavigationBarHidden = true
        
        
        
        playBtn.layer.shadowColor = UIColor.black.cgColor
        playBtn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        playBtn.layer.shadowOpacity = 1.0
        playBtn.layer.shadowRadius = 10.0
        
        rulesBtn.layer.shadowColor = UIColor.black.cgColor
        rulesBtn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        rulesBtn.layer.shadowOpacity = 1.0
        rulesBtn.layer.shadowRadius = 10.0
        
        rankingsBtn.layer.shadowColor = UIColor.black.cgColor
        rankingsBtn.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        rankingsBtn.layer.shadowOpacity = 1.0
        rankingsBtn.layer.shadowRadius = 10.0
        
        
        coverImageView.layer.shadowColor = UIColor.black.cgColor
        coverImageView.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        coverImageView.layer.shadowOpacity = 1.0
        coverImageView.layer.shadowRadius = 120.0
        
        
        let path = Bundle.main.path(forResource: "click", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        
        let path1 = Bundle.main.path(forResource: "introSong", ofType: "wav")!
        let url1 = URL(fileURLWithPath: path1)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            
            playerIntroSong = try AVAudioPlayer(contentsOf: url1)
            playerIntroSong.prepareToPlay()
        }catch let error as NSError{
            print(error.description)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        playBtn.transform = CGAffineTransform.identity
        rulesBtn.transform = CGAffineTransform.identity
        rankingsBtn.transform = CGAffineTransform.identity
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        playerIntroSong.stop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playerIntroSong.play()
        playerIntroSong.numberOfLoops = -1
        
        super.viewDidAppear(animated)
        
        
        if savedData.capacity == 0 {
            savedData = RankingHelper.getArrayData()!
            print("capability is 0")
            print("savedData in homeVC \(savedData)")
        }
        else {
            print("capability is not 0")
            print("savedData in homeVC \(savedData)")
        }
        
        self.navigationController?.isNavigationBarHidden = true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        playBtn.transform = CGAffineTransform.identity
        rulesBtn.transform = CGAffineTransform.identity
        rankingsBtn.transform = CGAffineTransform.identity
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Actions
    @IBAction func playBtnPressed(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        player.play()
        
        
        
        if savedData.capacity == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let destination = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            navigationController?.pushViewController(destination, animated: true)
        }
        else {
            savedData = RankingHelper.getArrayData()!
            let downData : [String] = savedData[0]
            let upDownData : [String] = savedData[1]
            let upData : [String] = savedData[2]
            let najavaData : [String] = savedData[3]
            let scoreData : [String] = savedData[4]
            
            
            if downData != [""]  && upDownData != [""] && upData != [""] && najavaData != [""] && scoreData != [""]{
                let alert = UIAlertController(title: "HEY!", message: "Do you want to RESUME previous game?", preferredStyle: UIAlertControllerStyle.alert)
                
                let resumeAction = UIAlertAction(title: "Resume game", style: UIAlertActionStyle.default) {
                    UIAlertAction in NSLog("Resume game Pressed")
                    RankingHelper.saveArrayData(data: self.savedData)
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let destination = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                    self.navigationController?.pushViewController(destination, animated: true)
                    //print("I resumed game! \(self.scoreArrays)")
                    //print("arraySum RESUMED \(arraySum)")
                }
                
                let newGameAction = UIAlertAction(title: "New game", style: UIAlertActionStyle.cancel){
                    UIAlertAction in NSLog("New game Pressed")
                    RankingHelper.deleteArrayData()
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let destination = storyboard.instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                    self.navigationController?.pushViewController(destination, animated: true)
                    //print("I chose new game! \(self.scoreArrays)")
                    //print("arraySum NEW \(arraySum)")
                }
                alert.addAction(resumeAction)
                alert.addAction(newGameAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func rulesBtnPressed(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        player.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "RulesViewController") as! RulesViewController
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    @IBAction func rankingsBtnPressed(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        player.play()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "RankingsViewController") as! RankingsViewController
        
        navigationController?.pushViewController(destination, animated: true)
    }
    
}
