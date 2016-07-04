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
    
    func toDic()->NSDictionary
    {
        return ["id" : id, "name" : name];
    }
}

enum SortType {
    case PooPoo
    case Poo
}

struct VideoItem {
    let id: String
    let name: String
    let key: String
    let site: String
    let type: String
    let size: String
    let iso_639_1:String
    
    init(dic: JSON)
    {
        id = dic["id"].stringValue
        name = dic["name"].stringValue
        key = dic["key"].stringValue
        site = dic["site"].stringValue
        type = dic["type"].stringValue
        size = dic["size"].stringValue
        iso_639_1 = dic["iso_639_1"].stringValue
    }
    
    func getYoutubeTrailerKey() -> String? {
        if site == "YouTube" {
            return key
        }
        return nil
    }
    
}




class BMRequestManager {
    let genreApi = "http://api.themoviedb.org/3/genre/movie/list?api_key=929a1bc82174d488c8fe8478baf7a6fe"
    let discovery = "http://api.themoviedb.org/3/discover/movie"
    let searchApi = "http://api.themoviedb.org/3/search/movie"
    
    var genres:[Genre] = [Genre]()
    let defaultGenre = Genre(id:"", name: "All Genres")
    
    


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
    


    func parseGenre(data: AnyObject) -> [Genre]
    {
        let json = JSON(data)
        let movieItems = json["genres"].array
        var results = Array<Genre>()
        for item in movieItems! {
            let genreId = item["id"].stringValue
            let name = item["name"].stringValue
            let  genre =  Genre(id: genreId, name: name)
            results.append(genre)
        }
        genres = results
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
    
    //Mark: - genre
    func getFullOptionNames() -> [String]
    {
        var genreOps:[String] = [String]()
        genreOps.append(defaultGenre.name)
        for item in genres {
            genreOps.append(item.name)
        }
        return genreOps
    }
    
    func getFullOptionIds() -> [String]
    {
        var genreOps:[String] = [String]()
        genreOps.append(defaultGenre.id)
        for item in genres {
            genreOps.append(item.id)
        }
        return genreOps
    }
    

    func discoveryParams(number: Int, sortType: SortType, key: String, genre: String, year: String) -> [String:AnyObject]
    {
        let sortString = (sortType == .PooPoo) ? "vote_count.asc" : "vote_count.desc"
        
        if year == "" {
            let dic = ["page":String(number),
                       "sort_by" : sortString,
                       "with_keywords":key,
                       "with_genres": genre,
                       "api_key": "929a1bc82174d488c8fe8478baf7a6fe"]
            return dic
        }
        
        let  dic = ["page":String(number),
                    "sort_by" : sortString,
                    "year":year,
                    "with_keywords":key,
                    "with_genres": genre,
                    "api_key": "929a1bc82174d488c8fe8478baf7a6fe"]
        return dic
    }
    
    //MARK: - Video
    func videoApi(movieId: String) -> String {
            let videosApi = "http://api.themoviedb.org/3/movie/" + movieId + "/videos?api_key=929a1bc82174d488c8fe8478baf7a6fe"
        return videosApi
    }
    

    func parseVideo(data: AnyObject) -> [VideoItem] {
        let json = JSON(data)
        let movieItems = json["results"].array
        var movies = Array<VideoItem>()
        for item in movieItems! {
            print("movie type is = \(item.description)\n")
            let movie = VideoItem(dic: item)
            movies.append(movie)
        }
        return movies
    }
    
    
    //MARK: - Search
    func searchParams(pageNumber: Int, key: String, year: String) -> [String:AnyObject]
    {
        let dic = ["page":String(pageNumber),
                   "year" : year,
                   "query":key,
                   "api_key": "929a1bc82174d488c8fe8478baf7a6fe"]
        return dic
        
    }
}