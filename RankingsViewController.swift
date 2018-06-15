//
//  RankingsViewController.swift
//  Jamb
//
//  Created by Saša Brezovac on 23.01.2018..
//  Copyright © 2018. Saša Brezovac. All rights reserved.
//

import UIKit
import AVFoundation

class RankingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: - Outlets
    @IBOutlet weak var rankingTableView: UITableView!
    @IBOutlet weak var rankingLabel: UILabel!
    
    
    @IBOutlet weak var lightBlueBImageView: UIImageView!
    @IBOutlet weak var yelloeRedWhiteBImageView: UIImageView!
    @IBOutlet weak var yellowBImageView: UIImageView!
    @IBOutlet weak var blueBImageView: UIImageView!
    @IBOutlet weak var redBImageView: UIImageView!
    @IBOutlet weak var greenBImageView: UIImageView!
    @IBOutlet weak var orangeBImageView: UIImageView!
    
    var player: AVAudioPlayer!
    var player1: AVAudioPlayer!
    
    var rankings : [CardRanking] = []
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankings = RankingHelper.getData()!
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        
        
        lightBlueBImageView.isHidden = false
        yelloeRedWhiteBImageView.isHidden = false
        yellowBImageView.isHidden = false
        blueBImageView.isHidden = false
        redBImageView.isHidden = false
        greenBImageView.isHidden = false
        orangeBImageView.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        music()
        player.play()
        animationBallons()
        
        super.viewDidAppear(animated)
        rankings = RankingHelper.getData()!
        
        rankings.sort{ $0.finalScore > $1.finalScore}
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.red
        
        let backArrow = UIImage(named: "LeftArrow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backArrow, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.topItem?.title = "Ranking list"
        
        rankingTableView.reloadData()
        RankingHelper.saveData(cards: self.rankings)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        player.stop()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Actions
    func animationBallons() {
        UIView.animate(withDuration: 2.5, animations: {
            self.lightBlueBImageView.frame = CGRect(x: 50, y: 25, width: 576, height: 489)
            self.redBImageView.frame = CGRect(x: -50, y: 25, width: 500, height: 400)
            
        }) { (finished) in
            self.lightBlueBImageView.isHidden = true
            self.redBImageView.isHidden = true
        }
        
        UIView.animate(withDuration: 3.0, animations: {
            self.yellowBImageView.frame = CGRect(x: -50, y: 25, width: 576, height: 489)
            self.orangeBImageView.frame = CGRect(x: -25, y: 25, width: 500, height: 400)
            self.blueBImageView.frame = CGRect(x: 100, y: 100, width: 350, height: 300)
            
        }) { (finished) in
            self.yellowBImageView.isHidden = true
            self.orangeBImageView.isHidden = true
            self.blueBImageView.isHidden = true
        }
        
        UIView.animate(withDuration: 4.5, animations: {
            
            self.yelloeRedWhiteBImageView.frame = CGRect(x: -50, y: 40, width: 300, height: 400)
            self.greenBImageView.frame = CGRect(x: -100, y: 25, width: 600, height: 500)
        }) { (finished) in
            self.yelloeRedWhiteBImageView.isHidden = true
            self.greenBImageView.isHidden = true
        }
    }
    
    
    
    @objc func backAction(){
        print("Back Button Clicked")
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankings.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        let rank = rankings[indexPath.row]
        cell.textLabel?.text = "\(indexPath.row + 1)." + " " + "\(rank.name!.uppercased())," + " " + "Score: \(rank.finalScore!)"
        
        
        cell.layer.borderWidth = 1
        let color = UIColor.black.cgColor
        cell.layer.borderColor = color
        cell.layer.cornerRadius = cell.frame.height / 2
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        cell.layer.shadowOpacity = 1.0
        cell.layer.shadowRadius = 5.0
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        let rank = rankings[indexPath.row]
        if rank.finalScore > rank.finalScore {
            cell.textLabel?.text = "\(rank.name!)," + " " + "Your score is: \(rank.finalScore!)"
        }
        return true
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            player1.play()
            rankings.remove(at: indexPath.row)
            tableView.reloadData()
            RankingHelper.saveData(cards: self.rankings)
        }
    }
    
    
    func music() {
        let path = Bundle.main.path(forResource: "champion", ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        
        let path1 = Bundle.main.path(forResource: "paperSmash", ofType: "wav")!
        let url1 = URL(fileURLWithPath: path1)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            
            player1 = try AVAudioPlayer(contentsOf: url1)
            player1.prepareToPlay()
        }catch let error as NSError{
            print(error.description)
        }
    }
}
