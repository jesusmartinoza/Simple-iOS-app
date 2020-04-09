//
//  Extensions.swift
//  Simple iOS
//
//  Created by Jesús Martínez on 4/9/20.
//  Copyright © 2020 Jesús Martínez. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    /**
    Fetch image from url and use cache when possible
    */
    func loadImagesUsingCacheWithUrlString(urlString : String)
    {
        self.image = nil
        
        if let chacheImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = chacheImage
            return
        }
        
        if let url = URL(string: urlString) {
            let request = URLRequest(url:url)
            URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
                
                if error != nil{
                    print(error!)
                    return
                }
                
                DispatchQueue.main.async {
                    if let dowloandedImage = UIImage(data: data!){
                        imageCache.setObject(dowloandedImage, forKey: urlString as AnyObject)
                        self.image = dowloandedImage
                    }
                }
            }).resume()
        }
    }
}
