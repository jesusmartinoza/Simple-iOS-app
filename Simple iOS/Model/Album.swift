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
    
    /**
     Create new instance with default values
     */
    init() {
        
    }
    
    /**
     Create new Album instance using dictionary
     
     - Parameter json: Dictionary with info
     */
    init(json: Dictionary<String, Any>) {
        id = json["id"] as! Int
        title = json["title"] as! String
        userId = json["userId"] as! Int
    }
    
    /**
     Get albums from API. Includes pagination.
     
     - Parameter start: Index of first album to retrieve.
     - Parameter onCompletion: Callback with data
     
     #TODO: Handle HTTP error / Parse error
     */
    static func fetch(start: Int = 0, onCompletion : ServiceResponse?)  {
        let params : Parameters = ["_start" : start, "_limit": 10]
        
        Alamofire.request(ApiTools.BASE_URL + "/albums", method: .get, parameters: params)
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
