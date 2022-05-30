//
//  CellMovingListTableViewCell.swift
//  DragAndDropCollectionView
//
//  Created by 신의연 on 2022/05/28.
//

import UIKit
import SnapKit

class CellMovingListTableViewCell: UITableViewCell {

    lazy var label: UILabel = {
        var label = UILabel()
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(label)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
