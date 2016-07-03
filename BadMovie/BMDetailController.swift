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
import SystemConfiguration


public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}











class BMDetailController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var playView: YTPlayerView!
    
    @IBOutlet weak var wifiText: UILabel!
    
    var movieItem:MovieItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() {
            wifiText.hidden = true
        }
        else
        {
            wifiText.hidden = false
        }
        
        startRequestVideo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func startRequestVideo() {
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
                    }
                    print("Validation Successful")
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
    
    
    func setupYoutube(youtubeKey: String)
    {
        let dic = ["controls" : (0), "playsinline" : (1), "autohide" : (1), "showinfo" : (0), "modestbranding" : (1)];
        playView.delegate = self
        playView.loadWithVideoId(youtubeKey, playerVars: dic)
        

//        NSDictionary *playerVars = @{
//            @"controls" : @0,
//            @"playsinline" : @1,
//            @"autohide" : @1,
//            @"showinfo" : @0,
//            @"modestbranding" : @1
//        };
//        self.playerView.delegate = self;
//        [self.playerView loadWithVideoId:videoId playerVars:playerVars];
    }
    
    
    func playerViewDidBecomeReady(playerView: YTPlayerView)
    {
    }
    
    func playerView(playerView: YTPlayerView, didChangeToState state: YTPlayerState)
    {
        wifiText.hidden = true
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
