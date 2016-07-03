//
//  BMRequestManager.swift
//  BadMovie
//
//  Created by shou wei on 03/07/16.
//  Copyright © 2016年 shou wei. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Genre {
    let id: String
    let name: String
}


class BMRequestManager {
    
    let discovery = "http://api.themoviedb.org/3/discover/movie?"
    let videosApi = "http://api.themoviedb.org/3/movie/441/videos?api_key=929a1bc82174d488c8fe8478baf7a6fe"
    let movieApi:String = "http://api.themoviedb.org/3/movie/id"
    let key = "api_key=929a1bc82174d488c8fe8478baf7a6fe"
    
    //    year
    //    with_keywords
    //    with_genres
    //    sort_by  vote_count.asc    vote_count.desc     popularity.asc popularity.desc
    
    class var sharedInstance: BMRequestManager {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: BMRequestManager? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = BMRequestManager()
        }
        return Static.instance!
    }
    

    
//    func getGenreList() -> Array<Genre>? {
//        let genreApi = "http://api.themoviedb.org/3/genre/movie/list?api_key=929a1bc82174d488c8fe8478baf7a6fe"
//         var results:[Genre]? = nil
//        
//        Alamofire.request(.GET, genreApi)
//            .validate()
//            .responseJSON { response in
//                print(response)
//                
//                switch response.result {
//                case .Success:
//                    if let value = response.result.value {
//                        results = self.parseGenre(value)
//                    }
//                    print("Validation Successful")
//                case .Failure(let error):
//                    print(error)
//                }
//        }
//        return results
//    }
    


    func parseGenre(data: AnyObject) -> [Genre]
    {
        let json = JSON(data)
        let movieItems = json["genres"].array
        var results = Array<Genre>()
        for item in movieItems! {
            print("movie type is = \(item.description)\n")
            let genreId = item["id"].stringValue
            let name = item["name"].stringValue
            let  genre =  Genre(id: genreId, name: name)
            results.append(genre)
        }
        return results
    }
    

    
    func parseSearch(data: AnyObject) -> [MovieItem]  {
        let json = JSON(data)
        let movieItems = json["results"].array
        var movies = Array<MovieItem>()
        for item in movieItems! {
            print("movie type is = \(item.description)\n")
            let movie = MovieItem(dic: item)
            movies.append(movie)
        }
        return movies
    }
    

}