//
//  PhotoViewCell.swift
//  Simple iOS
//
//  Created by Jesús Martínez on 4/9/20.
//  Copyright © 2020 Jesús Martínez. All rights reserved.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {

    @IBOutlet weak var image: UIImageView!
    var photo = Photo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(photo: Photo) {
        image.loadImagesUsingCacheWithUrlString(urlString: photo.thumbnailUrl ?? "")
    }
}
