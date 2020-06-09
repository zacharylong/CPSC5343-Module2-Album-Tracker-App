//
//  AlbumTableViewCell.swift
//  AlbumTracker
//
//  Created by Zachary Long on 6/7/20.
//  Copyright © 2020 Zachary Long. All rights reserved.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
