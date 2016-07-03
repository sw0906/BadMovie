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


class BMMainTableViewController: UITableViewController,SWComboxViewDelegate {
    let filterItem:UIBarButtonItem = UIBarButtonItem()
    var movies:[MovieItem] = [MovieItem]()
    var sortType: SortType = .PooPoo
    var searchWords: String = ""
    var searchGenre: String = ""
    var searhYear : String = ""
    var sectionHight:CGFloat = 86
    
    var comboxViewGenre:SWComboxView!
    var comboxViewYear:SWComboxView!
    var yearNumbers: [String] = []
    
    @IBOutlet weak var yearOptionsContainner: UIView!
    
    @IBOutlet weak var genreOptionsContainner: UIView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    
    @IBOutlet var sortView: UIView!
    
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    @IBOutlet var headerView: UIView!
    
    @IBAction func tapSort(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex
        {
        case 0:
            sortType = .PooPoo
            break
        case 1:
            sortType = .Poo
            print("tap 2")
        default:
            break;
        }
        startRequest()
    }
    
    
    
    //    var genres:[Genre]!
    
    var pageNumber:Int = 1;
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        yearNumbers.append("All Years")
        for i in 1920...2016 {
            let value = 2016 - i + 1920
            yearNumbers.append(String(value))
        }
        setupNav()
        setupTableView()
        startGetGenreList()
        startRequest()
    }
    
    func setupSortView()
    {
        if comboxViewYear == nil {
            filterItem.enabled = true;
            setupComboxGenre()
            setupComboxYear()
        }
    }
    
    private func setupNav()
    {
        
        let fac:NIKFontAwesomeIconFactory = NIKFontAwesomeIconFactory.barButtonItemIconFactory()
        let searchItem:UIBarButtonItem = UIBarButtonItem()
        searchItem.image = fac.createImageForIcon(NIKFontAwesomeIcon.Search)
        searchItem.action = #selector(BMMainTableViewController.tapSearch)
        searchItem.target = self
        searchItem.enabled = true
        searchItem.style = UIBarButtonItemStyle.Done
        
        //        let filterItem:UIBarButtonItem = UIBarButtonItem()
        filterItem.image = fac.createImageForIcon(NIKFontAwesomeIcon.Filter)
        filterItem.action = #selector(BMMainTableViewController.tapFilter)
        filterItem.target = self
        filterItem.enabled = false
        filterItem.style = UIBarButtonItemStyle.Done
        
        navItem.rightBarButtonItem = searchItem
        navItem.leftBarButtonItem = filterItem
        
        navItem.title = "Bad Movie"
        
        hideFilter(true)
    }
    
    func hideFilter(hide: Bool)
    {
        sectionHight = hide ? 0 : 86
        self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    
    private func setupTableView()
    {
        //        tableView.tableHeaderView = sortView
        let nib = UINib(nibName: "BMTableViewCell", bundle: NSBundle.mainBundle())
        tableView.registerNib(nib, forCellReuseIdentifier: "BMTableViewCell")
        
        
        tableView.registerClass(BMCell.classForCoder(), forCellReuseIdentifier: "BMCell")
        
        //        tableView.addSubview(headerView)
        //        tableView.reloadData()
        //        tableView.rowHeight = UITableViewAutomaticDimension
        //        tableView.estimatedRowHeight = 160
    }
    
    
    
    
    //MARK: - Tap
    func tapSearch()
    {
        performSegueWithIdentifier("toSearch", sender: nil)
    }
    
    func tapFilter()
    {
        sectionHight = sectionHight == 0 ? 86 : 0
        self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(0, 1)), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    

    
    //MARK: - Request
    func startGetGenreList() {
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
        pageNumber = 1
        refreshControl?.beginRefreshing()
        let api = BMRequestManager.sharedInstance.discovery
        let params = BMRequestManager.sharedInstance.discoveryParams(pageNumber, sortType: sortType, key: searchWords, genre: searchGenre, year: searhYear)
        
        Alamofire.request(.GET, api, parameters: params)
            .validate()
            .responseJSON { response in
                print(response)
                
                switch response.result {
                    
                case .Success:
                    if let value = response.result.value {
                        self.movies = BMRequestManager.sharedInstance.parseSearch(value)
                        self.pageNumber += 1
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                        })
                        
                    }
                    print("Validation Successful")
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    func moreRequest()
    {
        let api = BMRequestManager.sharedInstance.discovery
        let params = BMRequestManager.sharedInstance.discoveryParams(pageNumber, sortType: sortType, key: searchWords, genre: searchGenre, year: searhYear)
        
        Alamofire.request(.GET, api, parameters: params)
            //        Alamofire.request(.GET, api)
            .validate()
            .responseJSON { response in
                print(response)
                
                switch response.result {
                    
                case .Success:
                    if let value = response.result.value {
                        let newMoview = BMRequestManager.sharedInstance.parseSearch(value)
                        self.movies += newMoview
                        self.pageNumber += 1
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.beginUpdates()
                            self.tableView.insertRowsAtIndexPaths(self.indexPathsNewDataCount(newMoview.count), withRowAnimation: UITableViewRowAnimation.Automatic)
                            self.tableView.endUpdates()
                        })
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
        return movies.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:BMTableViewCell = tableView.dequeueReusableCellWithIdentifier("BMTableViewCell", forIndexPath: indexPath) as! BMTableViewCell
        let item = movies[indexPath.row]
        cell.bindMovie(item)
        //        let cell:BMCell = tableView.dequeueReusableCellWithIdentifier("BMCell", forIndexPath: indexPath) as! BMCell
        return cell
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 160
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let lastCell = movies.count - 5;
        if indexPath.row == lastCell {
            moreRequest()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = movies[indexPath.row]
        performSegueWithIdentifier("goDetail", sender: item)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
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
    
    
    
    //MARK: delegate
    func selectedAtIndex(index:Int, combox: SWComboxView)
    {
        if combox == comboxViewGenre {
            self.searchGenre = BMRequestManager.sharedInstance.getFullOptionIds()[index]
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
        }
        startRequest()
    }
    
    func tapComboxToOpenTable(combox: SWComboxView)
    {
        
    }
}
