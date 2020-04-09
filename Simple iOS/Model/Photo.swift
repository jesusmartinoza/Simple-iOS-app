//
//  Photo.swift
//  Simple iOS
//
//  Created by Jesús Martínez on 4/9/20.
//  Copyright © 2020 Jesús Martínez. All rights reserved.
//

import Foundation
import Alamofire

class Photo {
    
    typealias ServiceResponse = (Array<Photo>) -> ()
    
    var id: Int = -1
    var albumId: Int = -1
    var title: String?
    var url: String?
    var thumbnailUrl: String?
    
    /**
     Create new instance with default values
    */
    init() {
        
    }
    
    /**
     Create new instance of Photo using dictionary that represents JSON
     
     - Parameter json: Dictionary with info
     */
    init(json: Dictionary<String, Any>) {
        id = json["id"] as! Int
        albumId = json["albumId"] as! Int
        title = json["title"] as! String
        url = json["url"] as! String
        thumbnailUrl = json["thumbnailUrl"] as! String
    }
    
    /**
     Get photos from API. Includes pagination.
     
     - Parameter start: Index of first photo to retrieve.
     - Parameter onCompletion: Callback with data
     
     #TODO: Handle HTTP error / Parse error
     */
    static func fetch(start: Int = 0, albumId: Int = 0, onCompletion : ServiceResponse?)  {
        let params : Parameters = ["albumId": albumId, "_start" : start, "_limit": 10]
        
        Alamofire.request(ApiTools.BASE_URL + "/photos", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                var photos = [Photo]()
                
                for photo in (response.value as? Array<Dictionary<String,Any>>)! {
                    photos.append(Photo(json: photo))
                }
                
                onCompletion?(photos)
        }
    }
}
