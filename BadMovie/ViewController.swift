//
//  ViewController.swift
//  BadMovie
//
//  Created by shou wei on 02/07/16.
//  Copyright © 2016年 shou wei. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import youtube_ios_player_helper

class ViewController: UIViewController {

    
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    
    
    @IBAction func tapSearch(sender: AnyObject) {
        
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        testNetwork()
//        testApi()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func testYoutube()  {
    
    }
    
    
    //test
    func parseData(data: AnyObject)
    {
//        let item = MovieItem()
        let json = JSON(data)
//        item.Country = json["Country"].stringValue
//        item.Genre = json["Genre"].stringValue
    }
    
    func parseSearch(data: AnyObject)  {
        let json = JSON(data)
        let movieItems = json["results"].array
        var movies = Array<MovieItem>()
        for item in movieItems! {
            print("movie type is = \(item.description)\n")
            let movie = MovieItem(dic: item)
            movies.append(movie)
        }
    }
    
    
    func testNetwork(){
        let url = "http://api.themoviedb.org/3/discover/movie?api_key=929a1bc82174d488c8fe8478baf7a6fe"
        //"https://gdata.youtube.com/feeds/api/seasons/GZou3FaPdbw/episodes?v=2"
        //"https://gdata.youtube.com/feeds/api/charts/shows/most_popular?v=2"//"http://www.omdbapi.com/?s=crime&type=movie&r=json&page=1" //"https://www.omdbapi.com"
        let parameters = ["type" : "Movie", "s" : "the", "plot" : "full", "r" : "json" , "page" : 1]
        
        
        Alamofire.request(.GET, url)//, parameters: parameters)
            .validate()
            .responseJSON { response in
                print(response)
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        self.parseSearch(value)
                    }
                    print("Validation Successful")
                case .Failure(let error):
                    print(error)
                }
        }
        

    }
    
    func  parseMovies(data: AnyObject)  {
//        let item = MovieItem()
        let json = JSON(data)
        let movies = json["movies"].array
         print("movie number is = \(movies?.count)")
    }
    
    func  testApi() {
        let url = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ws32mxpd653h5c8zqfvksxw9&limit=10&country=us&genre=crime"
//        http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ws32mxpd653h5c8zqfvksxw9&limit=20&country=us
        Alamofire.request(.GET, url)
            .validate()
            .responseJSON { response in
                print(response)
                
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        self.parseMovies(value)
                    }
                    print("Validation Successful")
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    
    

}

