//
//  RulesViewController.swift
//  Jamb
//
//  Created by Saša Brezovac on 23.01.2018..
//  Copyright © 2018. Saša Brezovac. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var rulesText: UITextView!
    @IBOutlet weak var diceImageView: UIImageView!
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        rulesText.layer.shadowColor = UIColor.black.cgColor
        rulesText.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        rulesText.layer.shadowOpacity = 1.0
        rulesText.layer.shadowRadius = 40.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        navigationController?.navigationBar.barTintColor = UIColor.red
        let rollingDiceImage = UIImage(named: "rollingDice.gif")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: rollingDiceImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backAction))
        
        let backArrow = UIImage(named: "LeftArrow")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backArrow, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.topItem?.title = "Rules"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        animationDice()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    
    //MARK: - Actions
    func animationDice() {
        let width = diceImageView.bounds.width
        let height = diceImageView.bounds.height
        
        UIView.animate(withDuration: 4, animations: {
            self.diceImageView.frame = CGRect(x: UIScreen.main.bounds.width - 2 * width , y: UIScreen.main.bounds.height - 1.5 * height , width: 55, height: 55)
        }) { (finished) in
            UIView.animate(withDuration: 4, animations: {
                self.diceImageView.frame = CGRect(x: width , y: UIScreen.main.bounds.height - 1.5 * height , width: 55, height: 55)
            }) { (finished) in
                self.animationDice()
            }
        }
    }
    
    
    @objc func backAction(){
        print("Back Button Clicked")
        self.navigationController?.popToRootViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func backToMain(){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        navigationController?.pushViewController(destination, animated: false)
        self.navigationController?.isNavigationBarHidden = false
    }
}
