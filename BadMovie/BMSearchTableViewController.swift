//
//  BMSearchTableViewController.swift
//  BadMovie
//
//  Created by shou wei on 02/07/16.
//  Copyright © 2016年 shou wei. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import FontAwesomeKit
import FontAwesomeIconFactory
import MJRefresh
import SVProgressHUD


class BMSearchTableViewController: BMMainTableViewController, UISearchBarDelegate {

    
    @IBOutlet var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.becomeFirstResponder()
    }
    
    override func setup() {
        setupNav()
        setupTableView()
        setupComboxGenre()
        setupComboxYear()
    }
    
    override func setupNav() {
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.titleView = searchBar
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    override func resetRequestUrlAndParams() {
        api = BMRequestManager.sharedInstance.searchApi
        params = BMRequestManager.sharedInstance.searchParams(pageNumber, key: searchWords, year: searhYear)
    }
    

    
    //Mark: - filter
    override func selectedGenre(genre: String) {

        sortMovies = movies.sort { $0.vote_average.compare($1.vote_average) == .OrderedAscending }
    }
    

    
    override func tapSortHelper(type: SortType) {
        updateSortMovies()
    }
    

    
    //MARK: - Search Bar
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        self.searchWords = searchText
        startRequest()
    }

    
    
    //MARK: - TABLE
    override func getSortMovies() -> [MovieItem] {
        return sortMovies
    }
    override  func updateSortMovies() {
        if sortType == SortType.PooPoo {
            sortMovies = movies.sort { $0.vote_average.compare($1.vote_average) == .OrderedAscending }
        }
        else
        {
            sortMovies = movies.sort { $0.vote_average.compare($1.vote_average) == .OrderedDescending }
        }
        tableView.reloadData()
//        let filteredArray = objects.filter() {
//            if let type = ($0 as PFObject)["Type"] as String {
//                return type.rangeOfString("Sushi") != nil
//            } else {
//                return false
//            }
//        }
        
//        //filter
//        if searchGenre.characters.count > 0 {
//            $0.vote_average.
//            sortMovies = movies.filter(){
//                if let type = ($0 as PFObject)["Type"] as String {
//                    return type.rangeOfString("Sushi") != nil
//                } else {
//                    return false
//                }
//            }
//        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return  sortView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 86
    }
    
}
