//
//  YouTubeTableViewController.swift
//  hoc22
//
//  Created by Markim Shaw on 6/12/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit
import Alamofire


class YouTubeTableViewController: UITableViewController {
    
    var _youtubePlaylists:[YouTubePlaylist] = []
    var _youtubeVideos:[YouTubeVideo] = []
    var tableRefreshControl:UIRefreshControl?
    var nextPageToken = ""
    var fetchingMoreVideos = false
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "YouTube"
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.view.backgroundColor = UIColor.blackColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        loadVideos(pageToken: self.nextPageToken, fetchingMore: false)


        
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.dequeueReusableCellWithIdentifier("youtube_playlist", forIndexPath: indexPath) as? YouTubeTableViewCell
        cell?._image.hidden = true
        cell?._background.hidden = true
        cell?._title.hidden = true
        cell?._youtube_player.hidden = false
        let videoId = self._youtubeVideos[indexPath.row]._playlist_id

        cell?._youtube_player.loadWithVideoId(videoId, playerVars: [
            "playsinline": 1,
            "controls": 1,
            "width": self.view.frame.width,
            "height": self.view.frame.height]
        )
        cell?._youtube_player.playVideo()
        
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("youtube_playlist")
        return cell!.contentView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self._youtubeVideos.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("youtube_playlist", forIndexPath: indexPath) as? YouTubeTableViewCell
        /* Cell tags 
            1 - Image
            2 - Title
        */
        cell?._image.image = self._youtubeVideos[indexPath.row]._imagePreview.image
        cell?._title.text = self._youtubeVideos[indexPath.row]._title
        

        return cell!
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if (self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
        {
            if fetchingMoreVideos {
                return
            } else {
                fetchingMoreVideos = true
                loadVideos(pageToken: self.nextPageToken, fetchingMore: true)
            }
            
            
            
        }
    }
    
    func loadVideos(pageToken pageToken:String, fetchingMore:Bool){
        //let currentTableCount = self._youtubeVideos.count
        var url = ""
        if fetchingMore == true{
            url = "https://guarded-wave-29413.herokuapp.com/api/v1/youtube/\(self.nextPageToken)"
        } else {
            url = "https://guarded-wave-29413.herokuapp.com/api/v1/youtube"
        }
        Alamofire.request(.GET, url, parameters: [:]).responseJSON(completionHandler: {
            response in
            do {
                let responseDict = try NSJSONSerialization.JSONObjectWithData(response.data!, options: []) as! Array<Dictionary<NSObject,AnyObject>>
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)){
                    for i in 0..<responseDict[0].count {
                        let image_url = NSURL(string: responseDict[i]["image_url"] as! String)
                        self.nextPageToken = responseDict[i]["nextPageToken"] as! String
                        let video_id = responseDict[i]["id"] as! String
                        
                        let data = NSData(contentsOfURL: image_url!)
                        dispatch_async(dispatch_get_main_queue(), {
                            let image = UIImageView()
                            image.image = UIImage(data: data!)
                            let newBroadcast = YouTubeVideo(title: responseDict[i]["title"] as! String, imagePreview: image, playlist_id: video_id)
                            if (self.nextPageToken == pageToken){
                                return
                            } else {
                                self._youtubeVideos += [newBroadcast]
                                self.tableView.reloadData()
                            }
                        })
                        self.fetchingMoreVideos = false
                    }
                    
                }
            } catch {
                
            }
            
            
        })

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
