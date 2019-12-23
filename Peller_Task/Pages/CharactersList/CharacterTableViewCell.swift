//
//  CharacterTableViewCell.swift
//  Peller_Task
//
//  Created by User on 12/19/19.
//  Copyright © 2019 GagikMelikyan. All rights reserved.
//

import UIKit
import STWebImage

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var characterImg: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        characterName.text = ""
        self.backgroundColor = .clear
        characterName.textColor = .white
    }
    
    override func prepareForReuse() {
        characterImg.image = UIImage(named: "01")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = .yellow
            characterName.textColor = .black
        } else {
            contentView.backgroundColor = UIColor.clear
            self.characterName.textColor = .white
        }
    }
    
}
