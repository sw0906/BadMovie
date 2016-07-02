//
//  MovieItem.swift
//  BadMovie
//
//  Created by shou wei on 02/07/16.
//  Copyright © 2016年 shou wei. All rights reserved.
//

import UIKit

//"adult": false,
//"backdrop_path": "/cUfGqafAVQkatQ7N4y08RNV3bgu.jpg",
//"genre_ids": [
//28,
//18,
//53
//],
//"id": 254128,
//"original_language": "en",
//"original_title": "San Andreas",
//"overview": "In the aftermath of a massive earthquake in California, a rescue-chopper pilot makes a dangerous journey across the state in order to rescue his estranged daughter.",
//"release_date": "2015-05-29",
//"poster_path": "/6iQ4CMtYorKFfAmXEpAQZMnA0Qe.jpg",
//"popularity": 25.002,
//"title": "San Andreas",
//"video": false,
//"vote_average": 6.2,
//"vote_count": 234


import SwiftyJSON

class MovieItem: NSObject {
    var movieId:Int!
    var title:String!
    var original_language:String? = nil
    var genre_ids:Array<Int>? = nil
    
    var backdrop_path:NSString? = nil
    var poster_path:NSString? = nil
    var overview:NSString? = nil
    
    var vote_count:NSInteger!
    var vote_average:Float = 0.0
    var popularity:Float = 0.0
    
    var video:NSURL? = nil
    var release_date:String? = nil
    
    let imagePath = "http://image.tmdb.org/t/p/w500/"
    
    
    init(dic: JSON) {
        movieId = dic["id"].int
        title = dic["title"].stringValue
        original_language = dic["original_language"].stringValue
        
        if let genre_idsJson = dic["genre_ids"].array {
            genre_ids = Array<Int>()
            for genreId in genre_idsJson {
                genre_ids?.append(genreId.int!)
            }
        }

        
        backdrop_path = dic["backdrop_path"].stringValue
        poster_path = dic["poster_path"].stringValue
        overview = dic["overview"].stringValue
        
        vote_count = dic["vote_count"].int
        vote_average = dic["vote_average"].float!
        popularity = dic["id"].float!
        
//        video = NSURL dic["video"].stringValue
        release_date = dic["release_date"].stringValue
    }
    
    
    func getReleaseDate() -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"/* find out and place date format from http://userguide.icu-project.org/formatparse/datetime */
        return dateFormatter.dateFromString(release_date!)!
    }
    
}
