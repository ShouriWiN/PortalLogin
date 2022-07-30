//
//  MainTableViewCell.swift
//  PortalLogin
//
//  Created by Shouri on 2022/06/11.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
