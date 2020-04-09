//
//  AlbumViewCell.swift
//  Simple iOS
//
//  Created by Jesús Martínez on 4/8/20.
//  Copyright © 2020 Jesús Martínez. All rights reserved.
//

import UIKit

class AlbumViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(album: Album) {
        title.text = album.title
    }
    
}
