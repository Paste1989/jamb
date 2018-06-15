//
//  TableViewCellAddNew.swift
//  Jamb
//
//  Created by Saša Brezovac on 29.01.2018..
//  Copyright © 2018. Saša Brezovac. All rights reserved.
//

import UIKit

class AddNewTableViewCell: UITableViewCell {
    
    //MARK: - Outlets
    @IBOutlet weak var addNewCell: AddNewTableViewCell!
    @IBOutlet weak var scoreTextlabel: UILabel!
    
    var cardsArray : [CardRanking] = []
    var card : CardRanking!
    
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
