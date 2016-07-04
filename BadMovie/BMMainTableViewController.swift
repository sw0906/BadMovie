//
//  BMMainTableViewController.swift
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


class BMMainTableViewController: UITableViewController,SWComboxViewDelegate {
    let filterItem:UIBarButtonItem = UIBarButtonItem()
    var movies:[MovieItem] = [MovieItem]()
    var sortMovies:[MovieItem] = [MovieItem]()
    var sortType: SortType = .PooPoo
    var searchWords: String = ""
    var searchGenre: String = ""
    var searhYear : String = ""
    var sectionHight:CGFloat = 86
    
    var comboxViewGenre:SWComboxView!
    var comboxViewYear:SWComboxView!
    var yearNumbers: [String] = []
    
    var pageNumber:Int = 1;
    var api = ""
    var params:[String:AnyObject] = [:]
    
    @IBOutlet weak var yearOptionsContainner: UIView!
    
    @IBOutlet weak var genreOptionsContainner: UIView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet var sortView: UIView!
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearNumbers.append("All Years")
        for i in 1920...2016 {
            let value = 2016 - i + 1920
            yearNumbers.append(String(value))
        }
        setup()
    }
    
    func setup() {
        setupNav()
        setupTableView()
        startGetGenreList()
        startRequest()
    }
    
    func resetRequestUrlAndParams() {
        api = BMRequestManager.sharedInstance.discovery
        params = BMRequestManager.sharedInstance.discoveryParams(pageNumber, sortType: sortType, key: searchWords, genre: searchGenre, year: searhYear)
    }
    
    
    func setupSortView()
    {
        if comboxViewYear == nil {
            filterItem.enabled = true;
            setupComboxGenre()
            setupComboxYear()
        }
    }
    
    func setupNav()
    {
        addFilter()
        addSearch()
    }
    
    func addSearch() {
        let fac:NIKFontAwesomeIconFactory = NIKFontAwesomeIconFactory.barButtonItemIconFactory()
        let searchItem:UIBarButtonItem = UIBarButtonItem()
        searchItem.image = fac.createImageForIcon(NIKFontAwesomeIcon.Search)
        searchItem.action = #selector(BMMainTableViewController.tapSearch)
        searchItem.target = self
        searchItem.enabled = true
        searchItem.style = UIBarButtonItemStyle.Done
        
        navItem.rightBarButtonItem = searchItem
    }
    
    func addFilter()
    {
        let fac:NIKFontAwesomeIconFactory = NIKFontAwesomeIconFactory.barButtonItemIconFactory()
        filterItem.image = fac.createImageForIcon(NIKFontAwesomeIcon.Filter)
        filterItem.action = #selector(BMMainTableViewController.tapFilter)
        filterItem.target = self
        filterItem.enabled = false
        filterItem.style = UIBarButtonItemStyle.Done
        navItem.leftBarButtonItem = filterItem
        
        navItem.title = "Bad Movie"
        
        hideFilter(true)
    }
    
    func hideFilter(hide: Bool)
    {
        sectionHight = hide ? 0 : 86
        self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    
    func setupTableView()
    {
        let testNib = UINib(nibName: "TestCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(testNib, forCellReuseIdentifier: "TestCell")
    }
    
    
    
    
    //MARK: - Tap
    @IBAction func tapSort(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            sortType = .PooPoo
            break
        case 1:
            sortType = .Poo
        default:
            break;
        }
        tapSortHelper(sortType)
    }
    func tapSortHelper(type: SortType)
    {
        startRequest()
    }
    
    func tapSearch()
    {
        performSegueWithIdentifier("toSearch", sender: nil)
    }
    
    func tapFilter()
    {
        gotoTop()
        sectionHight = sectionHight == 0 ? 86 : 0
        self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: UITableViewRowAnimation.Automatic)
    }

    
    //MARK: - Request
    func startGetGenreList() {
        if BMRequestManager.sharedInstance.genres.count > 0 {
            return
        }
        let api = BMRequestManager.sharedInstance.genreApi
        Alamofire.request(.GET, api)
            .validate()
            .responseJSON { response in
                print(response)
                
                switch response.result {
                    
                case .Success:
                    if let value = response.result.value {
                        BMRequestManager.sharedInstance.parseGenre(value)
                        self.setupSortView()
                    }
                    print("Validation Successful")
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    
    func startRequest()
    {
        gotoTop()
        SVProgressHUD.showWithStatus("Loading")
        pageNumber = 1
        resetRequestUrlAndParams()
        Alamofire.request(.GET, api, parameters: params)
            .validate()
            .responseJSON { response in
                print(response)
                
                switch response.result {
                    
                case .Success:
                    if let value = response.result.value {
                        self.movies = BMRequestManager.sharedInstance.parseSearch(value)
                        self.pageNumber += 1
                        self.updateSortMovies()
                        
                    }
                    print("Validation Successful")
                    
                case .Failure(let error):
                    print(error)
                }
                SVProgressHUD.dismiss()
        }
    }
    
    func moreRequest()
    {
        resetRequestUrlAndParams()
        Alamofire.request(.GET, api, parameters: params)
            .validate()
            .responseJSON { response in
                print(response)
                
                switch response.result {
                    
                case .Success:
                    if let value = response.result.value {
                        let newMoview = BMRequestManager.sharedInstance.parseSearch(value)
                        self.movies += newMoview
                        self.pageNumber += 1
                        self.updateMoreTable(newMoview)
                    }
                    print("Validation Successful")
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    
    
    func indexPathsNewDataCount(count: Int) -> [NSIndexPath]
    {
        var paths:[NSIndexPath] = [NSIndexPath]()
        let loop = count - 1
        let pos = self.movies.count - count
        for i in 0...loop {
            let indexPath = NSIndexPath(forRow: pos+i, inSection: 0)
            paths.append(indexPath)
        }
        return paths
    }
    
    
    
    
    // MARK: - Table view data source
    func getSortMovies()->[MovieItem]
    {
        return movies
    }
    
    func updateSortMovies()
    {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
        })

    }
    
    func updateMoreTable(newMoview : [MovieItem])  {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.insertRowsAtIndexPaths(self.indexPathsNewDataCount(newMoview.count), withRowAnimation: UITableViewRowAnimation.Automatic)
            self.tableView.endUpdates()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHight//44
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sectionHight == 0 ? nil : sortView
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return getSortMovies().count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TestCell = tableView.dequeueReusableCellWithIdentifier("TestCell", forIndexPath: indexPath) as! TestCell
        let item = getSortMovies()[indexPath.row]
        cell.bindMovie(item)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastCell = getSortMovies().count - 5;
        if indexPath.row == lastCell {
            moreRequest()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = getSortMovies()[indexPath.row]
        performSegueWithIdentifier("goDetail", sender: item)
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goDetail" {
            if let viewController = segue.destinationViewController as? BMDetailController {
                viewController.movieItem = sender as! MovieItem
            }
        }
        
    }
    
    
    //MARK: Combox
    func setupComboxGenre()
    {
        var helper: SWComboxTitleHelper
        helper = SWComboxTitleHelper()
        
        let list = BMRequestManager.sharedInstance.getFullOptionNames()
        comboxViewGenre = SWComboxView.loadInstanceFromNibNamedToContainner(self.genreOptionsContainner)
        comboxViewGenre.bindData(list, comboxHelper: helper, seletedIndex: 0, comboxDelegate: self, containnerView: self.view)
        comboxViewGenre.delegate = self
    }
    
    func setupComboxYear()
    {
        var helper: SWComboxTitleHelper
        helper = SWComboxTitleHelper()
        
        
        comboxViewYear = SWComboxView.loadInstanceFromNibNamedToContainner(self.yearOptionsContainner)
        comboxViewYear.bindData(yearNumbers, comboxHelper: helper, seletedIndex: 0, comboxDelegate: self, containnerView: self.view)
        comboxViewYear.delegate = self
    }
    
    
    
    //MARK: - Combox delegate
    func selectedAtIndex(index:Int, combox: SWComboxView)
    {
        if combox == comboxViewGenre {
            self.searchGenre = BMRequestManager.sharedInstance.getFullOptionIds()[index]
            selectedGenre(self.searchGenre)
        }
        if combox == comboxViewYear
        {
            if index != 0 {
                self.searhYear = yearNumbers[index]
            }
            else
            {
                self.searhYear = ""
            }
            selectedYear(self.searhYear)
        }
       
    }
    
    
    
    func tapComboxToOpenTable(combox: SWComboxView)
    {
        gotoTop()
    }
    
    
    //MARK: - Combox for search
    func selectedGenre(genre : String)
    {
         startRequest()
    }
    
    func selectedYear(year : String)
    {
         startRequest()
    }
    
    func gotoTop() {
        tableView.setContentOffset(CGPoint(x: 0, y: -70), animated:true)
    }
}
