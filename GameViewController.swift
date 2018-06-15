//
//  ViewController.swift
//  Jamb
//
//  Created by Saša Brezovac on 13.12.2017..
//  Copyright © 2017. Saša Brezovac. All rights reserved.
//

import UIKit
import AVFoundation
import QuartzCore

protocol GameControllerDelegate : class{
    func cardAdded(card : CardRanking)
}

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var table1: UITableView!
    @IBOutlet weak var table2: UITableView!
    @IBOutlet weak var table3: UITableView!
    @IBOutlet weak var table4: UITableView!
    @IBOutlet weak var table5: UITableView!
    @IBOutlet weak var table6: UITableView!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    @IBOutlet weak var diceIntroImageView: UIImageView!
    
    
    var savedData = RankingHelper.getArrayData()!
    var downData : [String] = []
    var upDownData : [String] = []
    var upData : [String] = []
    var najavaData : [String] = []
    var scoreData : [String] = []
    
    var actionToEnable : UIAlertAction?
    var textFieldString:String = ""
    
    
    var res1: Int = 0
    var res2: Int = 0
    var res3: Int = 0
    var res4: Int = 0
    var res5: Int = 0
    
    var najavaSelectedIndexPath:IndexPath? = nil
    var finalRes : [Int] = []
    var resSum : Int = 0
    
    let firstColumn = ["1", "2", "3", "4", "5", "6", "∑", "Max", "Min", "∑", "S", "F", "P", "Y", "∑"]
    var downModel:JambDataHolder = JambDataHolder()
    var upDownModel:JambDataHolder = JambDataHolder(withType: ModelType.upDown)
    var upModel:JambDataHolder = JambDataHolder(withType: ModelType.up)
    var najavaModel:JambDataHolder = JambDataHolder(withType: ModelType.najava)
    var scoreModel: JambDataHolder = JambDataHolder(withType: ModelType.score)
    
    var playerRoll: AVAudioPlayer!
    var playerWrite: AVAudioPlayer!
    var PlayerUse: AVAudioPlayer!
    var PlayerPutDown: AVAudioPlayer!
    var PlayerNajava: AVAudioPlayer!
    var PlayerGameOver: AVAudioPlayer!
    
    var card : CardRanking!
    weak var delegate : GameControllerDelegate?
    
    var dataSaver: [[String]] = []
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RankingHelper.saveArrayData(data: self.savedData)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.topItem?.title = "JAMB"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "EXIT", style: .done, target: self, action: #selector(GameViewController.showQuitAlert))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        
        self.resetData()
        
        diceSound()
        
        btn1.isEnabled = false
        btn2.isEnabled = false
        btn3.isEnabled = false
        btn4.isEnabled = false
        btn5.isEnabled = false
        
        btn1.isHidden = true
        btn2.isHidden = true
        btn3.isHidden = true
        btn4.isHidden = true
        btn5.isHidden = true
        
        
        notAllowedSelection()
        
        self.navigationItem.hidesBackButton = true
        
        btnPlay.layer.shadowColor = UIColor.black.cgColor
        btnPlay.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btnPlay.layer.shadowOpacity = 1.0
        btnPlay.layer.shadowRadius = 10.0
        
        btn1.layer.shadowColor = UIColor.black.cgColor
        btn1.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn1.layer.shadowOpacity = 1.0
        btn1.layer.shadowRadius = 5.0
        btn2.layer.shadowColor = UIColor.black.cgColor
        btn2.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn2.layer.shadowOpacity = 1.0
        btn2.layer.shadowRadius = 5.0
        btn3.layer.shadowColor = UIColor.black.cgColor
        btn3.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn3.layer.shadowOpacity = 1.0
        btn3.layer.shadowRadius = 5.0
        btn4.layer.shadowColor = UIColor.black.cgColor
        btn4.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn4.layer.shadowOpacity = 1.0
        btn4.layer.shadowRadius = 5.0
        btn5.layer.shadowColor = UIColor.black.cgColor
        btn5.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        btn5.layer.shadowOpacity = 1.0
        btn5.layer.shadowRadius = 5.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        savedData = RankingHelper.getArrayData()!
        print("savedData in gameVC \(self.savedData)")
        
        navigationController?.navigationBar.barTintColor = UIColor.red
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        reloadData()
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        btnPlay.isEnabled = false
        if savedData.count == 0 {
            let width = btn1.bounds.width
            self.diceIntroImageView.isHidden = false
            
            UIView.animate(withDuration: 0.5, animations: {
                self.diceIntroImageView.frame = CGRect(x: 2 *  width , y: 0, width: 75, height: 75)
                self.btn1.isHidden = false
                self.PlayerPutDown.play()
            }) { (finished) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.diceIntroImageView.frame = CGRect(x: 3 * width, y: 0, width: 75, height: 75)
                    self.btn2.isHidden = false
                    self.PlayerPutDown.play()
                }) { (finished) in
                    UIView.animate(withDuration: 0.5, animations: {
                        self.diceIntroImageView.frame = CGRect(x: 4.5 * width , y: 0, width: 75, height: 75)
                        self.btn3.isHidden = false
                        self.PlayerPutDown.play()
                    }) { (finished) in
                        UIView.animate(withDuration: 0.5, animations: {
                            self.diceIntroImageView.frame = CGRect(x: 6 * width, y: 0, width: 75, height: 75)
                            self.btn4.isHidden = false
                            self.PlayerPutDown.play()
                        }) { (finished) in
                            UIView.animate(withDuration: 0.5, animations: {
                                self.diceIntroImageView.frame = CGRect(x: 8 * width, y: 0, width: 75, height: 75)
                                self.btn5.isHidden = false
                                self.PlayerPutDown.play()
                            }) { (finished) in
                                UIView.animate(withDuration: 0.5, animations: {
                                    self.diceIntroImageView.isHidden = true
                                    self.btnPlay.isEnabled = true
                                })
                            }
                        }
                    }
                }
            }
        }
        else {
            self.diceIntroImageView.isHidden = true
            self.btn1.isHidden = false
            self.btn2.isHidden = false
            self.btn3.isHidden = false
            self.btn4.isHidden = false
            self.btn5.isHidden = false
            btnPlay.isEnabled = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Actions
    @objc func backAction(){
        print("Back Button Clicked")
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    //Data reset
    func resetData(){
        for _ in firstColumn {
            downModel.dataHolder.append("")
            upDownModel.dataHolder.append("")
            upModel.dataHolder.append("")
            najavaModel.dataHolder.append("")
            scoreModel.dataHolder.append("")
            table2.allowsSelection = true
            table3.allowsSelection = true
            table4.allowsSelection = true
            table5.allowsSelection = true
        }
    }
    
    
    //TableViews Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //        print(scrollView.contentOffset)
        scrollView.contentOffset.x = 0
        if table1 == scrollView {
            table2.contentOffset = table1.contentOffset
            table3.contentOffset = table2.contentOffset
            table4.contentOffset = table3.contentOffset
            table5.contentOffset = table4.contentOffset
            table6.contentOffset = table5.contentOffset
        }else if table2 == scrollView {
            table1.contentOffset = table2.contentOffset
            table3.contentOffset = table2.contentOffset
            table4.contentOffset = table3.contentOffset
            table5.contentOffset = table4.contentOffset
            table6.contentOffset = table5.contentOffset
        }else if table3 == scrollView {
            table1.contentOffset = table2.contentOffset
            table2.contentOffset = table3.contentOffset
            table4.contentOffset = table3.contentOffset
            table5.contentOffset = table4.contentOffset
            table6.contentOffset = table5.contentOffset
        }else if table4 == scrollView {
            table1.contentOffset = table2.contentOffset
            table2.contentOffset = table3.contentOffset
            table3.contentOffset = table4.contentOffset
            table5.contentOffset = table4.contentOffset
            table6.contentOffset = table5.contentOffset
        }else if table5 == scrollView {
            table1.contentOffset = table2.contentOffset
            table2.contentOffset = table3.contentOffset
            table3.contentOffset = table4.contentOffset
            table4.contentOffset = table5.contentOffset
            table6.contentOffset = table5.contentOffset
        }else if table6 == scrollView {
            table1.contentOffset = table2.contentOffset
            table2.contentOffset = table3.contentOffset
            table3.contentOffset = table4.contentOffset
            table4.contentOffset = table5.contentOffset
            table5.contentOffset = table6.contentOffset
        }
    }
    
    
    func diceSound(){
        let path = Bundle.main.path(forResource: "RollDice", ofType: "wav")!
        let url = URL(fileURLWithPath: path)
        
        let path1 = Bundle.main.path(forResource: "write", ofType: "wav")!
        let url1 = URL(fileURLWithPath: path1)
        
        let path2 = Bundle.main.path(forResource: "downSound", ofType: "wav")!
        let url2 = URL(fileURLWithPath: path2)
        
        let path3 = Bundle.main.path(forResource: "useDice", ofType: "wav")!
        let url3 = URL(fileURLWithPath: path3)
        
        let path4 = Bundle.main.path(forResource: "charge", ofType: "wav")!
        let url4 = URL(fileURLWithPath: path4)
        
        let path5 = Bundle.main.path(forResource: "letsGo", ofType: "wav")!
        let url5 = URL(fileURLWithPath: path5)
        do {
            playerRoll = try AVAudioPlayer(contentsOf: url)
            playerRoll.prepareToPlay()
            
            playerWrite = try AVAudioPlayer(contentsOf: url1)
            playerWrite.prepareToPlay()
            
            PlayerUse = try AVAudioPlayer(contentsOf: url2)
            PlayerUse.prepareToPlay()
            
            PlayerPutDown = try AVAudioPlayer(contentsOf: url3)
            PlayerPutDown.prepareToPlay()
            
            PlayerGameOver = try AVAudioPlayer(contentsOf: url4)
            PlayerGameOver.prepareToPlay()
            
            PlayerNajava = try AVAudioPlayer(contentsOf: url5)
            PlayerNajava.prepareToPlay()
        }catch let error as NSError{
            print(error.description)
        }
    }
    
    
    
    //MARK: TableView funcs
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.firstColumn.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        cell.layer.borderWidth = 1
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        if counter == 0 && upDownModel.dataHolder.contains("") == false && downModel.dataHolder.contains("") == false && upModel.dataHolder.contains("") == false && najavaModel.dataHolder.contains("") == false {
            showAlert()
            PlayerGameOver.play()
        }
        
        if counter == 0 {
            table2.allowsSelection = false
            table3.allowsSelection = false
            table4.allowsSelection = false
            table5.allowsSelection = false
            table5.allowsSelection = false
        }
        
        
        if (indexPath.row == 6) || (indexPath.row == 9) || (indexPath.row == 14) {
            cell.backgroundColor = UIColor.lightGray
            cell.textLabel?.textColor = UIColor.white
            cell.isUserInteractionEnabled = false
            if table6 == tableView {
                if indexPath.row == 14 {
                    cell.textLabel?.textColor = UIColor.black
                }
            }
        }
        
        if indexPath.row == 7 && indexPath.row == 8 {
            if cell.textLabel?.text != "" {
                scoreTwo()
                if resSum != 0 {
                    scoreModel.dataHolder.insert("\(resSum)", at: 9)
                }
            }
        }
        
        
        
        if table1 == tableView {
            cell.textLabel?.text = firstColumn[indexPath.row]
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            cell.textLabel?.textColor = UIColor.black
        }
        
        if table2 == tableView {
            cell.textLabel?.text = String(downModel.dataHolder[indexPath.row])
            
            cell.isUserInteractionEnabled = false
            if indexPath.row == 0 {
                cell.isUserInteractionEnabled = true
            }
            else{
                let previousValue = downModel.dataHolder[indexPath.row - 1]
                if previousValue.count > 0 {
                    cell.isUserInteractionEnabled = true
                }
            }
            
            if indexPath.row == 7 && downModel.dataHolder[5] == "" {
                cell.isUserInteractionEnabled = false
            }
            else if indexPath.row == 7 && downModel.dataHolder[5] != "" {
                cell.isUserInteractionEnabled = true
            }
            
            if indexPath.row == 10 && downModel.dataHolder[8] == "" {
                cell.isUserInteractionEnabled = false
            }
            else if indexPath.row == 10 && downModel.dataHolder[8] != "" {
                cell.isUserInteractionEnabled = true
            }
            
            if cell.textLabel?.text != "" {
                cell.isUserInteractionEnabled = false
            }
        }
        
        if table3 == tableView {
            cell.textLabel?.text = String(upDownModel.dataHolder[indexPath.row])
            if cell.textLabel?.text != "" {
                cell.isUserInteractionEnabled = false
            }
        }
        
        if table4 == tableView {
            cell.textLabel?.text = String(upModel.dataHolder[indexPath.row])
            if cell.textLabel?.text != "" {
                cell.isUserInteractionEnabled = false
            }
            
            cell.isUserInteractionEnabled = false
            if indexPath.row == 13 {
                cell.isUserInteractionEnabled = true
            }
            
            if indexPath.row == 12 && upModel.dataHolder[13] != "" {
                cell.isUserInteractionEnabled = true
            }
            if indexPath.row == 11 && upModel.dataHolder[12] != "" {
                cell.isUserInteractionEnabled = true
            }
            if indexPath.row == 10 && upModel.dataHolder[11] != "" {
                cell.isUserInteractionEnabled = true
            }
            
            if indexPath.row == 8 && upModel.dataHolder[10] != "" {
                cell.isUserInteractionEnabled = true
                
            }
            if indexPath.row == 7 && upModel.dataHolder[8] != "" {
                cell.isUserInteractionEnabled = true
            }
            
            if indexPath.row == 5 && upModel.dataHolder[7] != "" {
                cell.isUserInteractionEnabled = true
            }
            
            if indexPath.row == 4 && upModel.dataHolder[5] != "" {
                cell.isUserInteractionEnabled = true
            }
            
            if indexPath.row == 3 && upModel.dataHolder[4] != "" {
                cell.isUserInteractionEnabled = true
            }
            if indexPath.row == 2 && upModel.dataHolder[3] != "" {
                cell.isUserInteractionEnabled = true
            }
            if indexPath.row == 1 && upModel.dataHolder[2] != "" {
                cell.isUserInteractionEnabled = true
            }
            if indexPath.row == 0 && upModel.dataHolder[1] != "" {
                cell.isUserInteractionEnabled = true
            }
            if cell.textLabel?.text != "" {
                cell.isUserInteractionEnabled = false
            }
        }
        
        if table5 == tableView {
            if counter == 1 && downModel.dataHolder[indexPath.row] != "" && upDownModel.dataHolder[indexPath.row] != "" && upModel.dataHolder[indexPath.row] != "" && najavaSelectedIndexPath != nil {
                btnPlay.isEnabled = true
            }
            else if counter == 1 && downModel.dataHolder[13] != ""  && upModel.dataHolder[0] != "" && najavaSelectedIndexPath == nil && upDownModel.dataHolder[0] != "" && upDownModel.dataHolder[0] != "" && upDownModel.dataHolder[1] != "" && upDownModel.dataHolder[2] != "" && upDownModel.dataHolder[3] != "" && upDownModel.dataHolder[4] != "" && upDownModel.dataHolder[5] != "" && upDownModel.dataHolder[7] != "" && upDownModel.dataHolder[8] != "" && upDownModel.dataHolder[10] != "" && upDownModel.dataHolder[11] != "" && upDownModel.dataHolder[12] != "" && upDownModel.dataHolder[13] != ""{
                btnPlay.isEnabled = false
                let alert = UIAlertController(title: "Message!", message: "Please announce!", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel) {
                    UIAlertAction in NSLog("Ok Pressed")
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
            
            if counter == 2 && najavaSelectedIndexPath != nil{
                table5.allowsSelection = false
                table4.allowsSelection = false
                table3.allowsSelection = false
                table2.allowsSelection = false
            }
            
            if najavaModel.dataHolder[indexPath.row] != "" && counter == 0 {
                counterIsDone()
            }
            
            cell.textLabel?.text = String(najavaModel.dataHolder[indexPath.row])
            if cell.textLabel?.text != "" {
                cell.isUserInteractionEnabled = false
            }
            
            
            if counter == 2 || counter == 3 && najavaSelectedIndexPath == nil {
                cell.isUserInteractionEnabled = false
                table5.isScrollEnabled = true
            }
        }
        
        
        if table6 == tableView {
            if (indexPath.row == 0) || (indexPath.row == 1) || (indexPath.row == 2) || (indexPath.row == 3)
                || (indexPath.row == 4) || (indexPath.row == 5) || (indexPath.row == 7) || (indexPath.row == 8) || (indexPath.row == 10) || (indexPath.row == 11) || (indexPath.row == 12) || (indexPath.row == 13){
                cell.layer.borderWidth = 0
            }
            if indexPath.row  == 6 {
                scoreOne()
                if resSum != -100 {
                    cell.textLabel?.text = String(scoreModel.dataHolder[6])
                }
            }
            if indexPath.row == 9 {
                scoreTwo()
                if resSum != -100 {
                    cell.textLabel?.text = String(scoreModel.dataHolder[9])
                }
            }
            if indexPath.row == 14 {
                scoreThree()
                if resSum != -1 {
                    cell.textLabel?.text = String(scoreModel.dataHolder[14])
                    cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
                }
            }
        }
        
        
        if savedData.count != 0 {
            downData = savedData[0]
            upDownData = savedData[1]
            upData = savedData[2]
            najavaData = savedData[3]
            scoreData = savedData[4]
            
            
            
            if (indexPath.row == 6) || (indexPath.row == 9) || (indexPath.row == 14) {
                cell.backgroundColor = UIColor.lightGray
                cell.textLabel?.textColor = UIColor.white
                cell.isUserInteractionEnabled = false
            }
            
            
            if table2 == tableView{
                if downData[indexPath.row] != "" {
                    downModel.dataHolder[indexPath.row] = downData[indexPath.row]
                    let one = Int(downModel.dataHolder[0]) ?? 00
                    let two = Int(downModel.dataHolder[1]) ?? 00
                    let three = Int(downModel.dataHolder[2]) ?? 00
                    let four = Int(downModel.dataHolder[3]) ?? 00
                    let five = Int(downModel.dataHolder[4]) ?? 00
                    let six = Int(downModel.dataHolder[5]) ?? 00
                    
                    let columnAdd = one + two + three + four + five + six
                    downModel.insertElement(index: 6, value: "\(columnAdd)")
                    if resSum != Int("") {
                        cell.textLabel?.text = downModel.dataHolder[indexPath.row]
                        cell.isUserInteractionEnabled = false
                    }
                    
                    if downModel.dataHolder[indexPath.row] != String("") {
                        cell.isUserInteractionEnabled = false
                    }
                    
                }
            }
            
            
            if table3 == tableView{
                if upDownData[indexPath.row] != "" {
                    upDownModel.dataHolder[indexPath.row] = upDownData[indexPath.row]
                    let one = Int(upDownModel.dataHolder[0]) ?? 00
                    let two = Int(upDownModel.dataHolder[1]) ?? 00
                    let three = Int(upDownModel.dataHolder[2]) ?? 00
                    let four = Int(upDownModel.dataHolder[3]) ?? 00
                    let five = Int(upDownModel.dataHolder[4]) ?? 00
                    let six = Int(upDownModel.dataHolder[5]) ?? 00
                    
                    let columnAdd = one + two + three + four + five + six
                    upDownModel.insertElement(index: 6, value: "\(columnAdd)")
                    if resSum != Int("") {
                        cell.textLabel?.text = upDownModel.dataHolder[indexPath.row]
                        cell.isUserInteractionEnabled = false
                    }
                    
                    if upDownModel.dataHolder[indexPath.row] != String("") {
                        cell.isUserInteractionEnabled = false
                    }
                }
            }
            
            if table4 == tableView{
                if upData[indexPath.row] != "" {
                    upModel.dataHolder[indexPath.row] = upData[indexPath.row]
                    let one = Int(upModel.dataHolder[0]) ?? 00
                    let two = Int(upModel.dataHolder[1]) ?? 00
                    let three = Int(upDownModel.dataHolder[2]) ?? 00
                    let four = Int(upModel.dataHolder[3]) ?? 00
                    let five = Int(upModel.dataHolder[4]) ?? 00
                    let six = Int(upModel.dataHolder[5]) ?? 00
                    
                    let columnAdd = one + two + three + four + five + six
                    upModel.insertElement(index: 6, value: "\(columnAdd)")
                    if resSum != Int("") {
                        cell.textLabel?.text = upModel.dataHolder[indexPath.row]
                        cell.isUserInteractionEnabled = false
                    }
                    
                    if upModel.dataHolder[indexPath.row] != String("") {
                        cell.isUserInteractionEnabled = false
                    }
                }
            }
            
            if table5 == tableView{
                if najavaData[indexPath.row] != "" {
                    
                    najavaModel.dataHolder[indexPath.row] = najavaData[indexPath.row]
                    let one = Int(najavaModel.dataHolder[0]) ?? 00
                    let two = Int(najavaModel.dataHolder[1]) ?? 00
                    let three = Int(najavaModel.dataHolder[2]) ?? 00
                    let four = Int(najavaModel.dataHolder[3]) ?? 00
                    let five = Int(najavaModel.dataHolder[4]) ?? 00
                    let six = Int(najavaModel.dataHolder[5]) ?? 00
                    
                    let columnAdd = one + two + three + four + five + six
                    najavaModel.insertElement(index: 6, value: "\(columnAdd)")
                    
                    if resSum != Int("") {
                        cell.textLabel?.text = najavaModel.dataHolder[indexPath.row]
                        cell.isUserInteractionEnabled = false
                    }
                    
                    
                    
                    if najavaModel.dataHolder[indexPath.row] != String("") {
                        cell.isUserInteractionEnabled = false
                    }
                }
            }
            
            if table6 == tableView{
                if indexPath.row == 6 {
                    if scoreData[6] != "" {
                        scoreModel.dataHolder[indexPath.row] = scoreData[indexPath.row]
                        scoreOne()
                        if resSum != -100 {
                            downModel.insertElement(index: indexPath.row, value: "\(resSum)")
                        }
                    }
                }
                
                if indexPath.row == 9 {
                    if scoreData[9] != "" {
                        scoreModel.dataHolder[indexPath.row] = scoreData[indexPath.row]
                        scoreTwo()
                    }
                }
                if indexPath.row == 14 {
                    if scoreData[14] != "" {
                        scoreModel.dataHolder[indexPath.row] = scoreData[indexPath.row]
                        scoreThree()
                    }
                }
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        RankingHelper.saveArrayData(data: savedData)
        //        print("saved\(savedData)")
        //        print("dataSaver\(dataSaver)")
        
        
        resSum = 0
        
        if (indexPath.row < 6) {
            for dice in finalRes {
                if dice == Int(firstColumn[indexPath.row]){
                    resSum += dice
                }
            }
            reloadData()
        }
        
        if table2 == tableView{
            if indexPath.row == 0 {
                downModel.insertElement(index: indexPath.row, value: String(resSum))
                counterIsDone()
                usedDice()
                btnPlay.isEnabled = true
                btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                playerWrite.play()
            }
            else{
                let previousValue = downModel.dataHolder[indexPath.row - 1]
                if previousValue.count > 0 {
                    playerWrite.play()
                    if indexPath.row < 6 {
                        downModel.insertElement(index: indexPath.row, value: String(resSum))
                        counterIsDone()
                        usedDice()
                        btnPlay.isEnabled = true
                        btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                    }
                    
                    
                    if indexPath.row == 7 && downModel.dataHolder[5] != "" {
                        max()
                        if resSum != 0 {
                            downModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    
                    if indexPath.row == 8 {
                        min()
                        if resSum != 0 {
                            downModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    
                    if indexPath.row == 10 && downModel.dataHolder[8] != "" {
                        scale()
                        if resSum != 100 {
                            downModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    
                    if indexPath.row == 11 {
                        fullHouse()
                        if resSum != 100 {
                            downModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    
                    if (indexPath.row == 12) {
                        poker()
                        if resSum != 100 {
                            downModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    if (indexPath.row == 13) {
                        jamb()
                        if resSum != 100 {
                            downModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                }
            }
            reloadData()
            finalRes.removeAll()
            //print(downModel.dataHolder)
        }
        
        
        if table3 == tableView {
            counterIsDone()
            usedDice()
            btnPlay.isEnabled = true
            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
            playerWrite.play()
            if indexPath.row < 6 {
                upDownModel.insertElement(index: indexPath.row, value: String(resSum))
                
            }
            if indexPath.row == 7 {
                max()
                if resSum != 0 {
                    upDownModel.insertElement(index: indexPath.row, value: String(resSum))
                }
            }
            if indexPath.row == 8 {
                min()
                if resSum != 0 {
                    upDownModel.insertElement(index: indexPath.row, value: String(resSum))
                }
            }
            if indexPath.row == 10 {
                scale()
                if resSum != 100 {
                    upDownModel.insertElement(index: indexPath.row, value: String(resSum))
                }
            }
            if indexPath.row == 11 {
                fullHouse()
                if resSum != 100 {
                    upDownModel.insertElement(index: indexPath.row, value: String(resSum))
                }
            }
            if indexPath.row == 12 {
                poker()
                if resSum != -100 {
                    upDownModel.insertElement(index: indexPath.row, value: String(resSum))
                }
            }
            if indexPath.row == 13 {
                jamb()
                if resSum != 100 {
                    upDownModel.insertElement(index: indexPath.row, value: String(resSum))
                }
            }
            self.table3.reloadData()
            finalRes.removeAll()
            //print(upDownModel.dataHolder)
        }
        
        if table4 == tableView{
            if indexPath.row == 13 {
                jamb()
                if resSum != 100 {
                    upModel.insertElement(index: indexPath.row, value: String(resSum))
                    counterIsDone()
                    usedDice()
                    btnPlay.isEnabled = true
                    btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                    playerWrite.play()
                }
            }
            else{
                let previousValue = upModel.dataHolder[indexPath.row + 1]
                if previousValue.count > 0 {
                    playerWrite.play()
                    if (indexPath.row == 12) {
                        poker()
                        if resSum != 100 {
                            upModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    if indexPath.row == 11 {
                        fullHouse()
                        if resSum != 100 {
                            upModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    if indexPath.row == 10 {
                        scale()
                        if resSum != 100 {
                            upModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    if indexPath.row == 8 && upModel.dataHolder[10] != ""  {
                        min()
                        if resSum != 0 {
                            upModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    if indexPath.row == 7 {
                        max()
                        if resSum != 0 {
                            upModel.insertElement(index: indexPath.row, value: String(resSum))
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        }
                    }
                    if indexPath.row <= 5 && upModel.dataHolder[7] != "" {
                        upModel.insertElement(index: indexPath.row, value: String(resSum))
                        counterIsDone()
                        usedDice()
                        btnPlay.isEnabled = true
                        btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                    }
                }
            }
            reloadData()
            finalRes.removeAll()
            //print(upModel.dataHolder)
        }
        
        
        if (table5 == tableView) {
            PlayerNajava.play()
            
            if resSum == 0  && counter == 1 {
                self.najavaSelectedIndexPath = indexPath
                self.najavaModel.insertElement(index: indexPath.row, value: "")
            }
            else if indexPath.row < 6 {
                self.najavaSelectedIndexPath = indexPath
                self.najavaModel.insertElement(index: indexPath.row, value: String(self.resSum))
            }
            
            
            let announceAlert = UIAlertController(title: "Announce", message: "Want to announce \(firstColumn[indexPath.row])?", preferredStyle: UIAlertControllerStyle.alert)
            announceAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {  (action: UIAlertAction!) in
                
                if self.najavaSelectedIndexPath != nil && self.counter == 1 {
                    self.table5.reloadData()
                    
                    
                    if indexPath.row == 7 {
                        self.max()
                        if self.resSum != 0 {
                            self.najavaModel.insertElement(index: indexPath.row, value: String(self.resSum))
                        }
                    }
                    if indexPath.row == 8 {
                        self.min()
                        if self.resSum != 0 {
                            self.najavaModel.insertElement(index: indexPath.row, value: String(self.resSum))
                        }
                    }
                    if indexPath.row == 10 {
                        self.najavaModel.insertElement(index: indexPath.row, value: "?")
                        self.scale()
                        if self.resSum == 45 || self.resSum == 55 {
                            self.najavaModel.insertElement(index: indexPath.row, value: "\(self.resSum)")
                            self.playerWrite.play()
                            self.counterIsDone()
                            self.usedDice()
                            self.btnPlay.isEnabled = true
                            self.btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                            self.najavaSelectedIndexPath = nil
                        }
                    }
                    if indexPath.row == 11 {
                        self.najavaModel.insertElement(index: indexPath.row, value: "?")
                        self.fullHouse()
                        if self.resSum != 0 {
                            self.najavaModel.insertElement(index: indexPath.row, value: "\(self.resSum)")
                            self.playerWrite.play()
                            self.counterIsDone()
                            self.usedDice()
                            self.btnPlay.isEnabled = true
                            self.btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                            self.najavaSelectedIndexPath = nil
                        }
                    }
                    if indexPath.row == 12 {
                        self.najavaModel.insertElement(index: indexPath.row, value: "?")
                        self.poker()
                        if self.resSum == 44 || self.resSum == 48 || self.resSum == 52 || self.resSum == 56 || self.resSum == 60 || self.resSum == 64 {
                            self.najavaModel.insertElement(index: indexPath.row, value: "\(self.resSum)")
                            self.playerWrite.play()
                            self.counterIsDone()
                            self.usedDice()
                            self.btnPlay.isEnabled = true
                            self.btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                            self.najavaSelectedIndexPath = nil
                        }
                    }
                    if indexPath.row == 13 {
                        self.najavaModel.insertElement(index: indexPath.row, value: "?")
                        self.jamb()
                        if self.resSum == 80 || self.resSum  == 75 || self.resSum == 70 || self.resSum == 65 || self.resSum == 60 || self.resSum == 55 {
                            self.najavaModel.insertElement(index: indexPath.row, value: "\(self.resSum)")
                            self.playerWrite.play()
                            self.counterIsDone()
                            self.usedDice()
                            self.btnPlay.isEnabled = true
                            self.btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                            self.najavaSelectedIndexPath = nil
                        }
                    }
                    self.table2.allowsSelection = false
                    self.table3.allowsSelection = false
                    self.table4.allowsSelection = false
                    self.table5.allowsSelection = false
                }
                
                if self.counter == 2 {
                    self.table5.reloadData()
                    if indexPath.row == 10 {
                        self.scale()
                        if self.resSum != -1 {
                            self.najavaModel.insertElement(index: indexPath.row, value: "?")
                        }
                    }
                    if indexPath.row == 11 {
                        self.fullHouse()
                        if self.resSum != -1 {
                            self.najavaModel.insertElement(index: indexPath.row, value: "?")
                        }
                    }
                    if indexPath.row == 12 {
                        self.poker()
                        if self.resSum != -1 {
                            self.najavaModel.insertElement(index: indexPath.row, value: "?")
                        }
                    }
                    if indexPath.row == 13 {
                        self.jamb()
                        if self.resSum != -1 {
                            self.najavaModel.insertElement(index: indexPath.row, value: "?")
                        }
                    }
                }
                
                if self.counter == 3 {
                    self.resSum = 0
                    self.finalRes.removeAll()
                }
            }))
            announceAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                self.najavaModel.insertElement(index: indexPath.row, value: "")
                self.najavaSelectedIndexPath = nil
                self.reloadData()
            }))
            present(announceAlert, animated: true, completion: nil)
        }
        reloadData()
    }
    
    
    func najava() {
        resSum = 0
        
        if let indexPath = najavaSelectedIndexPath  {
            if counter == 0 {
                if resSum != 0 {
                    najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                }
            }
            
            
            if counter == 1 {
                if indexPath.row == 7 {
                    max()
                    if resSum != 0 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                if indexPath.row == 8 {
                    min()
                    if resSum != 0 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                if indexPath.row == 10 {
                    scale()
                    if resSum != 0 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        counterIsDone()
                        usedDice()
                        btnPlay.isEnabled = true
                        btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        najavaSelectedIndexPath = nil
                    }
                }
                if indexPath.row == 11 {
                    fullHouse()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        counterIsDone()
                        usedDice()
                        btnPlay.isEnabled = true
                        btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        najavaSelectedIndexPath = nil
                    }
                }
                if indexPath.row == 12 {
                    poker()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        counterIsDone()
                        usedDice()
                        btnPlay.isEnabled = true
                        btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                        najavaSelectedIndexPath = nil
                    }
                }
                if indexPath.row == 13 {
                    jamb()
                    if self.resSum == 80 || self.resSum  == 75 || self.resSum == 70 || self.resSum == 65 || self.resSum == 60 || self.resSum == 55 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        if resSum != 0 {
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                            najavaSelectedIndexPath = nil
                        }
                    }
                }
            }
            
            if counter == 2 {
                if indexPath.row < 6 {
                    for dice in finalRes {
                        if dice == Int(firstColumn[indexPath.row]) {
                            resSum += dice
                            najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        }
                        else if dice != Int(firstColumn[indexPath.row]) {
                            najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        }
                    }
                    reloadData()
                }
                if indexPath.row == 7 {
                    max()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                if indexPath.row == 8 {
                    min()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                if indexPath.row == 10 {
                    scale()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        if resSum != 0 {
                            self.playerWrite.play()
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                            najavaSelectedIndexPath = nil
                        }
                    }
                }
                if indexPath.row == 11 {
                    fullHouse()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        if resSum != 0 {
                            self.playerWrite.play()
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                            najavaSelectedIndexPath = nil
                        }
                    }
                }
                if indexPath.row == 12 {
                    poker()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        if resSum != 0 {
                            self.playerWrite.play()
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                            najavaSelectedIndexPath = nil
                        }
                    }
                }
                if indexPath.row == 13 {
                    jamb()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        if resSum != 0 {
                            self.playerWrite.play()
                            counterIsDone()
                            usedDice()
                            btnPlay.isEnabled = true
                            btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                            najavaSelectedIndexPath = nil
                        }
                    }
                }
            }
            
            
            if counter == 3 {
                playerWrite.play()
                if indexPath.row < 6 {
                    for dice in finalRes {
                        if dice == Int(firstColumn[indexPath.row]) {
                            resSum += dice
                            najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        }
                        else if dice != Int(firstColumn[indexPath.row]) {
                            najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                        }
                    }
                    reloadData()
                }
                if indexPath.row == 7 {
                    max()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                if indexPath.row == 8 {
                    min()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                if indexPath.row == 10 {
                    scale()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                if indexPath.row == 11 {
                    fullHouse()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                if indexPath.row == 12 {
                    poker()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                if indexPath.row == 13 {
                    jamb()
                    if resSum != -1 {
                        najavaModel.insertElement(index: indexPath.row, value: String(resSum))
                    }
                }
                counterIsDone()
                usedDice()
                btnPlay.isEnabled = true
                btnPlay.setTitle("Roll dice", for: UIControlState.normal)
                najavaSelectedIndexPath = nil
                //print(najavaModel.dataHolder)
            }
        }
        table5.reloadData()
    }
    
    
    
    
    func scoreOne(){
        let score1 = Int(downModel.dataHolder[6]) ?? 00
        let score2 = Int(upModel.dataHolder[6]) ?? 00
        let score3 = Int(upDownModel.dataHolder[6]) ?? 00
        let score4 = Int(najavaModel.dataHolder[6]) ?? 00
        resSum = score1 + score2 + score3 + score4
        scoreModel.dataHolder[6] = "\(resSum)"
    }
    
    func scoreTwo() {
        let score1 = Int(downModel.dataHolder[9]) ?? 00
        let score2 = Int(upModel.dataHolder[9]) ?? 00
        let score3 = Int(upDownModel.dataHolder[9]) ?? 00
        let score4 = Int(najavaModel.dataHolder[9]) ?? 00
        resSum = score1 + score2 + score3 + score4
        scoreModel.dataHolder[9] = "\(resSum)"
    }
    
    func scoreThree() {
        let score1 = Int(downModel.dataHolder[14]) ?? 00
        let score2 = Int(upModel.dataHolder[14]) ?? 00
        let score3 = Int(upDownModel.dataHolder[14]) ?? 00
        let score4 = Int(najavaModel.dataHolder[14]) ?? 00
        let score5 = Int(scoreModel.dataHolder [6]) ?? 00
        let score6 = Int(scoreModel.dataHolder[9]) ?? 00
        let resSum = score1 + score2 + score3 + score4 + score5 + score6
        scoreModel.dataHolder[14] = "\(resSum)"
        //        print("Score array: \(scoreModel.dataHolder)")
    }
    
    
    
    func max(){
        resSum = res1 + res2 + res3 + res4 + res5
    }
    
    func min(){
        resSum = res1 + res2 + res3 + res4 + res5
    }
    
    func scale(){
        if finalRes.contains(1) && finalRes.contains(2) && finalRes.contains(3) && finalRes.contains(4) && finalRes.contains(5){
            resSum = 30 + 15
        }else if finalRes.contains(2) && finalRes.contains(3) && finalRes.contains(4) && finalRes.contains(5) && finalRes.contains(6){
            resSum = 40 + 15
        }
        reloadData()
    }
    
    func fullHouse() {
        let threeEquals = (finalRes).filter{ (n) in finalRes.filter{$0==n}.count == 3 }
        let twoEquals = (finalRes).filter{ (n) in finalRes.filter{$0==n}.count == 2 }
        if threeEquals.count == 3 && twoEquals.count == 2 {
            resSum = threeEquals.first! * 3 + twoEquals.first! * 2 + 30
        }
        else{
            resSum = 0
        }
    }
    
    func poker() {
        let fourEquals = (finalRes).filter{ (n) in finalRes.filter{$0==n}.count == 4 }
        let fiveEquals = (finalRes).filter{ (n) in finalRes.filter{$0==n}.count == 5 }
        
        if fourEquals.count == 4 {
            resSum = fourEquals.first! * 4 + 40
        }
        else if fiveEquals.count == 5 {
            resSum = fiveEquals.first! * 4 + 40
        }
    }
    
    func jamb(){
        if res1 == res2  && res2 == res3 && res3 == res4 && res4 == res5 {
            resSum = res1 * 5 + 50
        }
    }
    
    
    var counter : Int = 0{
        didSet{
            if (counter == 1){
                btnPlay.setTitle("Roll 2 more times!", for: UIControlState.normal)}
            finalRes = [(res1), (res2), (res3), (res4), (res5)]
            table5.isUserInteractionEnabled = true
            
            if (counter == 2){
                btnPlay.setTitle("Roll 1 more time!", for: UIControlState.normal)}
            finalRes = [(res1), (res2), (res3), (res4), (res5)]
            
            if(counter == 3){
                btnPlay.setTitle("Finished!", for: UIControlState.normal)
                btnPlay.isEnabled = false
                finalRes = [(res1), (res2), (res3), (res4), (res5)]
            }
        }
    }
    
    
    
    func counterIsDone(){
        counter = 0
        btn1.isSelected = false
        btn1.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        btn2.isSelected = false
        btn2.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        btn3.isSelected = false
        btn3.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        btn4.isSelected = false
        btn4.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        btn5.isSelected = false
        btn5.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        btn1.isEnabled = false
        btn2.isEnabled = false
        btn3.isEnabled = false
        btn4.isEnabled = false
        btn5.isEnabled = false
        
        table2.allowsSelection = true
        table3.allowsSelection = true
        table4.allowsSelection = true
        table5.allowsSelection = true
    }
    
    func notAllowedSelection(){
        table1.allowsSelection = false
        table2.allowsSelection = false
        table3.allowsSelection = false
        table4.allowsSelection = false
        table5.allowsSelection = false
        table6.allowsSelection = false
    }
    
    func reloadData(){
        self.table2.reloadData()
        self.table3.reloadData()
        self.table4.reloadData()
        self.table5.reloadData()
        self.table6.reloadData()
    }
    
    func clearAll(){
        downModel.dataHolder.removeAll()
        upDownModel.dataHolder.removeAll()
        upModel.dataHolder.removeAll()
        najavaModel.dataHolder.removeAll()
        scoreModel.dataHolder.removeAll()
        self.resetData()
        reloadData()
    }
    
    
    func usedDice(){
        if btn1.isSelected == true {
            finalRes.swapAt(res1, res1)
        }
        if btn2.isSelected == true {
            finalRes.swapAt(res2, res2)
        }
        if btn3.isSelected == true {
            finalRes.swapAt(res3, res3)
        }
        if btn4.isSelected == true {
            finalRes.swapAt(res4, res4)
        }
        if btn5.isSelected == true {
            finalRes.swapAt(res5, res5)
        }
    }
    
    
    func RollDice(){
        if btn1.isSelected == false {
            res1 = Int(arc4random_uniform(6))+1
            btn1.setImage(UIImage (named: "\(res1)"), for: UIControlState.normal)
        }
        
        if btn2.isSelected == false {
            res2 = Int(arc4random_uniform(6))+1
            btn2.setImage(UIImage (named: "\(res2)"), for: UIControlState.normal)
        }
        
        if btn3.isSelected == false {
            res3 = Int(arc4random_uniform(6))+1
            btn3.setImage(UIImage (named: "\(res3)"), for: UIControlState.normal)
        }
        
        if btn4.isSelected == false {
            res4 = Int(arc4random_uniform(6))+1
            btn4.setImage(UIImage (named: "\(res4)"), for: UIControlState.normal)
        }
        
        if btn5.isSelected == false {
            res5 = Int(arc4random_uniform(6))+1
            btn5.setImage(UIImage (named: "\(res5)"), for: UIControlState.normal)
        }
    }
    
    
    
    @objc func showQuitAlert() {
        
        self.dataSaver.append(self.downModel.dataHolder)
        self.dataSaver.append(self.upDownModel.dataHolder)
        self.dataSaver.append(self.upModel.dataHolder)
        self.dataSaver.append(self.najavaModel.dataHolder)
        self.dataSaver.append(self.scoreModel.dataHolder)
        
        
        let alert = UIAlertController(title: "WARNING!", message: "Want to quit the game?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in NSLog("OK Pressed"); _ = self.navigationController?.popToRootViewController(animated: false)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in NSLog("Cancel Pressed")
        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
        reloadData()
        //print(dataSaver)
        
        RankingHelper.saveArrayData(data: dataSaver)
    }
    
    
    @objc func textChanged(sender:UITextField) {
        if let alertController = self.presentedViewController as? UIAlertController {
            if !(sender.text?.isEmpty)! {
                alertController.actions[0].isEnabled = true
                self.textFieldString = sender.text!
            }else{
                alertController.actions[0].isEnabled = false
            }
        }
    }
    
    
    func showAlert() {
        scoreThree()
        let alert = UIAlertController(title: "Game over! \nSCORE: \n\(scoreModel.dataHolder[14])", message: "Your score will be saved at Ranking list!" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField {(textField:UITextField) in
            textField.placeholder = "Enter your name"
            textField.addTarget(self, action: #selector(self.textChanged(sender:)),for: UIControlEvents.editingChanged)
        }
        
        self.actionToEnable = UIAlertAction(title: "Ok", style: .default, handler: {(action) -> Void in
            let score:Int = Int(self.scoreModel.dataHolder[14]) ?? 00
            
            let cardRanking = CardRanking(name: self.textFieldString, finalScore: score)
            var storedRatings = RankingHelper.getData()
            storedRatings?.append(cardRanking)
            RankingHelper.saveData(cards: storedRatings!)
            self.goToRankingList()
            self.clearAll()
            self.savedData.removeAll()
        })
        
        self.actionToEnable!.isEnabled = false
        alert.addAction(self.actionToEnable!)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func goToRankingList(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "RankingsViewController") as! RankingsViewController
        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    
    @objc func exitToHomePage() {
        dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    
    
    @IBAction func btnPlayPressed(_ sender: UIButton) {
        playerRoll.play()
        RollDice()
        counter = counter + 1
        najava()
        
        btn1.isEnabled = true
        btn2.isEnabled = true
        btn3.isEnabled = true
        btn4.isEnabled = true
        btn5.isEnabled = true
        
        table2.allowsSelection = true
        table3.allowsSelection = true
        table4.allowsSelection = true
        table5.allowsSelection = true
    }
    
    
    @IBAction func btnPressed(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.layer.shadowColor = UIColor.black.cgColor
            sender.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            sender.layer.shadowOpacity = 1.0
            sender.layer.shadowRadius = 10.0
            
            PlayerUse.play()
            sender.isSelected = true
            sender.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        }else {
            sender.layer.shadowColor = UIColor.black.cgColor
            sender.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            sender.layer.shadowOpacity = 1.0
            sender.layer.shadowRadius = 5.0
            
            PlayerPutDown.play()
            sender.isSelected = false
            sender.transform = CGAffineTransform.identity
        }
    }
}
