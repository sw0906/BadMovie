//
//  BMDetailController.swift
//  BadMovie
//
//  Created by shou wei on 03/07/16.
//  Copyright © 2016年 shou wei. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import Alamofire
import SwiftyJSON
import FontAwesomeKit
import FontAwesomeIconFactory
import SystemConfiguration.SCNetworkReachability
import SVProgressHUD


enum ReachabilityType {
    case WWAN,
    WiFi,
    NotConnected
}






class BMDetailController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var playView: YTPlayerView!
    
    @IBOutlet weak var wifiText: UILabel!
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var playSlide: UISlider!
    
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateNumberLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var GenreLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var peopleImageView: UIImageView!
    
    
    var movieItem:MovieItem!
    
    
    func isConnectedWifi() -> Bool {
        let reachability = Reachability.reachabilityForInternetConnection()
        let status = reachability.isConnectWifi()
        return status
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.isConnectedWifi(){
            wifiText.hidden = true
        }
        else
        {
            wifiText.hidden = false
        }
        
        movieImageView.kf_setImageWithURL(movieItem.getBackdropUrl())
        
        hiddeImageView(true)
        setupRateView()
        setupData()
        startRequestVideo()
    }
    
    func setupRateView() {
        rateView.layer.borderWidth = 2.0
        rateView.layer.cornerRadius = 3.0
        rateView.layer.borderColor = UIColor.whiteColor().CGColor
        rateView.clipsToBounds = true
        
        let fac:NIKFontAwesomeIconFactory = NIKFontAwesomeIconFactory.buttonIconFactory()
        starImageView.image = fac.createImageForIcon(NIKFontAwesomeIcon.Star)
        peopleImageView.image = fac.createImageForIcon(NIKFontAwesomeIcon.User)
        
        
        starImageView.image = starImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        starImageView.tintColor = UIColor.whiteColor()
        
        peopleImageView.image = peopleImageView.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        peopleImageView.tintColor = UIColor.whiteColor()
        
//        var cogIcon: FAKFontAwesome = FAKFontAwesome.starIconWithSize(20)
//        starImageView.image = cogIcon.imageWithSize(CGSize(width: 20, height: 20))
//        
//        cogIcon = FAKFontAwesome.userIconWithSize(15)
//        peopleImageView.image = cogIcon.imageWithSize(CGSize(width: 15, height: 15))
    }
    
    func setupData()
    {
        rateLabel.text = movieItem.vote_average
        rateNumberLabel.text = movieItem.vote_count
        GenreLabel.text = movieItem.getGenreName()
        infoLabel.text = movieItem.overview
        titleLabel.text = movieItem.getTitleString()
        
        let score = Float( movieItem.vote_average)
        let rate = CGFloat(score!) * 0.1
        view.backgroundColor = UIColor.globalPooRateColor(rate)
    }
    
    func hiddeImageView(hide: Bool)
    {
        movieImageView.hidden = hide
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func startRequestVideo() {
        SVProgressHUD.showWithStatus("Loading")
        let api = BMRequestManager.sharedInstance.videoApi(movieItem.movieId)
        Alamofire.request(.GET, api)
            .validate()
            .responseJSON { response in
                print(response)
                
                switch response.result {
                    
                case .Success:
                    if let value = response.result.value {
                       let videos = BMRequestManager.sharedInstance.parseVideo(value)
                        if videos.count > 0
                        {
                            self.setupYoutube(videos[0].key)
                        }
                        else
                        {
                            self.hiddeImageView(false)
                        }
                    }
                    print("Validation Successful")
                    
                case .Failure(let error):
                    print(error)
                }
                SVProgressHUD.dismiss()
        }
    }
    
    
    //MARK: - video
    func setupYoutube(youtubeKey: String)
    {
        let dic = ["controls" : (0), "playsinline" : (1), "autohide" : (1), "showinfo" : (0), "modestbranding" : (1)];
        playView.delegate = self
        playView.loadWithVideoId(youtubeKey, playerVars: dic)
    }
    
    
    func playerViewDidBecomeReady(playerView: YTPlayerView)
    {
        SVProgressHUD.dismiss()
        view.bringSubviewToFront(wifiText)
    }
    
    func playerView(playerView: YTPlayerView, didChangeToState state: YTPlayerState)
    {
        if state == YTPlayerState.Playing {
            wifiText.hidden = true
        }
    }
    
    func playerView(playerView: YTPlayerView, didPlayTime playTime: Float) {
        let  interval = playView.duration()
        let dur = Double(playTime)/interval
        self.playSlide.value = Float(dur)
    }
    
    @IBAction func onSliderChange(sender: UISlider) {
        let  seekToTime = self.playView.duration() *  Double( self.playSlide.value)
        playView.seekToSeconds(Float(seekToTime), allowSeekAhead: true)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
