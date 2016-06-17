//
//  TwitchViewController.swift
//  hoc22
//
//  Created by Markim Shaw on 6/10/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit
import Alamofire

class TwitchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var _liveStreamWebView:UIWebView!
    @IBOutlet weak var _pastBroadcastsTable:UITableView!
    var _pastBroadcasts:[TwitchBroadcast] = []
    var _viewHeight:CGFloat!
    var _viewWidth:CGFloat!
    var _broadcastCurrentlyPlaying = false
    var currentRow = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Twitch"
        self.view.backgroundColor = UIColor.blackColor()
        
        //add title colro
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self._pastBroadcastsTable.delegate = self
        self._pastBroadcastsTable.dataSource = self
        self._liveStreamWebView.scrollView.scrollEnabled = false
        self._liveStreamWebView.scrollView.bounces = false
        self.automaticallyAdjustsScrollViewInsets = false

        
        /*load all of the images once this view loads so that way the tableview can easily be populated with the images without a long wait time */
        Alamofire.request(.GET, "https://guarded-wave-29413.herokuapp.com/api/v1/twitch", parameters: [:]).responseJSON(completionHandler: {
            response in
            do {
                let responseDict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: []) as! Array<Dictionary<NSObject,AnyObject>>
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
                    for i in 0..<responseDict.count {
                        let image_url = NSURL(string: responseDict[i]["image_url"] as! String)
                        let broadcast_url = responseDict[i]["url"] as! String
                        
                        let data = NSData(contentsOfURL: image_url!)
                        dispatch_async(dispatch_get_main_queue(), {
                            let image = UIImageView()
                            image.image = UIImage(data: data!)
                            let newBroadcast = TwitchBroadcast(imagePreview: image, broadcastTitle: responseDict[i]["title"] as! String, videoUrl: broadcast_url)
                            self._pastBroadcasts += [newBroadcast]
                            self._pastBroadcastsTable.reloadData()
                        })
                    }
                    
                }
            } catch {
                
            }
            
        
        })

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //Adjust the webview height/width on rotation
        self._viewHeight = self._liveStreamWebView.scrollView.frame.height
        self._viewWidth = self._liveStreamWebView.scrollView.frame.width
        self._liveStreamWebView.loadRequest(NSURLRequest(URL: NSURL(string: "http://player.twitch.tv/?channel=bum1six3&autoplay=false")!))
        
        self._pastBroadcastsTable.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
    }
    
    
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        if self._broadcastCurrentlyPlaying == true {
            self._viewHeight = self._liveStreamWebView.frame.height
            self._viewWidth = self._liveStreamWebView.scrollView.frame.width
            //let embedVideo = "<!DOCTYPE html><head><style>body { margin: 0; padding: 0; height:100%;}</style></head><body><iframe webkit-playsinline src=\"https://player.twitch.tv/?video=v\(self._pastBroadcasts[self.currentRow]._broadcastURL)&amp;autoplay=false&amp;playsinline=1\" height=\"\(self._viewHeight)\" width=\"100%\" scrolling=\"no\" allowfullscreen=\"false\" frameborder=\"0\" autoplay=\"false\"</iframe></body></html>"
            //self._liveStreamWebView.loadHTMLString(embedVideo, baseURL: nil)
        }
        //self._liveStreamWebView.frame = CGRect(0,0,self.)
        //Try to prevent the UIWebView from always reloading on orientation change
        /*if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation)){
            self._liveStreamWebView.stopLoading()
        } else if (self._liveStreamWebView.loading){
            self._liveStreamWebView.reload()
        }
        
        if(UIInterfaceOrientationIsLandscape(toInterfaceOrientation)){
            self._liveStreamWebView.stopLoading()
        } else if (self._liveStreamWebView.loading){
            self._liveStreamWebView.reload()
        }*/
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self._pastBroadcasts.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self._viewHeight = self._liveStreamWebView.frame.height
        self._viewWidth = self._liveStreamWebView.scrollView.frame.width
        let embedVideo = "<!DOCTYPE html><head><style>html, body { margin: 0; padding: 0; height:100%;}</style></head><body><iframe webkit-playsinline src=\"https://player.twitch.tv/?video=v\(self._pastBroadcasts[indexPath.row]._broadcastURL)&amp;autoplay=false&amp;playsinline=1\" height=\"100%\" width=\"100%\" scrolling=\"no\" allowfullscreen=\"false\" frameborder=\"0\" autoplay=\"false\"</iframe></body></html>"
        self._liveStreamWebView.loadHTMLString(embedVideo, baseURL: nil)
        
        
        self._broadcastCurrentlyPlaying = true
        self.currentRow = indexPath.row
        
        
    }
   
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        /* Tag guide line:
            1 = Image
            2 = Label
        */
        let cell = tableView.dequeueReusableCellWithIdentifier("past_broadcast", forIndexPath: indexPath) as UITableViewCell
        let image = cell.viewWithTag(1) as! UIImageView
        let title = cell.viewWithTag(3) as! UILabel
        let image_image = self._pastBroadcasts[indexPath.row]._imagePreview.image
        image.image = image_image
        title.text = self._pastBroadcasts[indexPath.row]._broadcastTitle
        let backgroundForTitleText = cell.viewWithTag(2)
        backgroundForTitleText!.layer.opacity = 0.5
        //title.layer.opacity = 1.0
        
        return cell
    }
    
    @IBAction func  loadLive(){
        //self._viewHeight = self._liveStreamWebView.scrollView.frame.height
        //self._viewWidth = self._liveStreamWebView.scrollView.frame.width
        self._liveStreamWebView.loadRequest(NSURLRequest(URL: NSURL(string: "http://player.twitch.tv/?channel=bum1six3&autoplay=false")!))
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
