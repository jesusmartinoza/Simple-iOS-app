//
//  Album.swift
//  Simple iOS
//
//  Created by Jesús Martínez on 4/8/20.
//  Copyright © 2020 Jesús Martínez. All rights reserved.
//

import Foundation
import Alamofire

class Album {
    
    typealias ServiceResponse = (Array<Album>) -> ()
    
    var id: Int = -1
    var title: String?
    var userId: Int = -1
    
    init(json: Dictionary<String, Any>) {
        id = json["id"] as! Int
        title = json["title"] as! String
    }
    
    /**
     * Get all albums from API
     */
    static func getAllFromAPI(start: Int = 0, onCompletion : ServiceResponse?)  {
        let params : Parameters = ["_start" : start, "_limit": 10]
        
        Alamofire.request(ApiTools.url + "albums", method: .get, parameters: params)
            .validate()
            .responseJSON { response in
                var albums = [Album]()
                
                for album in (response.value as? Array<Dictionary<String,Any>>)! {
                    albums.append(Album(json: album))
                }
                
                onCompletion?(albums)
            }
    }
}
