//
//  HomeViewController.swift
//  hoc22
//
//  Created by Markim Shaw on 6/10/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIScrollViewDelegate {
    
    /* Properties */
    @IBOutlet weak var _mainScrollView:UIScrollView!
    @IBOutlet weak var _twitchButton:UIButton!
    @IBOutlet weak var _youtubeButton:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* For enabling horizontal paging */
        self._mainScrollView.contentInset = UIEdgeInsetsZero
        self.automaticallyAdjustsScrollViewInsets = false
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(HomeViewController.scrollTimer), userInfo: nil, repeats: true)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default

    }
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent

        self._mainScrollView.frame = CGRect(x: 0.0, y: 0.0, width: self._mainScrollView.frame.width, height: self._mainScrollView.frame.height)
        self._mainScrollView.contentSize = CGSize(width: self._mainScrollView.frame.width * 4, height: self._mainScrollView.frame.height)
        self._mainScrollView.pagingEnabled = true
        self._mainScrollView.delegate = self
        self.createBackgroundScrollImages()
        
        self._twitchButton.layer.cornerRadius = 30
        self._twitchButton.layer.borderWidth = 1
        self._twitchButton.layer.borderColor = UIColor.clearColor().CGColor
        self._twitchButton.layer.backgroundColor = UIColor.blackColor().CGColor//UIColor(red: 42.0/255.0, green: 159.0/255.0, blue: 214.0/255.0, alpha: 1.0).CGColor
        
        self._youtubeButton.layer.cornerRadius = 30
        self._youtubeButton.layer.borderWidth = 1
        self._youtubeButton.layer.borderColor = UIColor.clearColor().CGColor
        self._youtubeButton.layer.backgroundColor = UIColor(red: 42.0/255.0, green: 159.0/255.0, blue: 214.0/255.0, alpha: 1.0).CGColor
        
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    //Function used for adding the images to the background scene for the main UIScrollView
    func createBackgroundScrollImages(){
        
        var images:[UIImageView] = []
        let image0 = UIImageView(image: UIImage(named: "sf5_section"))
        let image1 = UIImageView(image:  UIImage(named: "mkx_section"))
        let image2 = UIImageView(image: UIImage(named: "overwatch_section"))
        let image3 = UIImageView(image: UIImage(named: "smash4_section"))
        //image0.image?.imageWithRenderingMode(.)
        
        
        images += [image0, image1, image2, image3]
        
        
        
        images[0].frame.offsetInPlace(dx: 0.0, dy: 0.0)
        images[1].frame.offsetInPlace(dx: self._mainScrollView.frame.width, dy: 0.0)
        images[2].frame.offsetInPlace(dx: self._mainScrollView.frame.width * 2, dy: 0.0)
        images[3].frame.offsetInPlace(dx: self._mainScrollView.frame.width * 3, dy: 0.0)
        
        //self._mainScrollView.addSubView(images[0])
        self._mainScrollView.addSubview(images[0])
        self._mainScrollView.addSubview(images[1])
        self._mainScrollView.addSubview(images[2])
        self._mainScrollView.addSubview(images[3])
        
        
        
       
        
        
        
        
    }
    
    func scrollTimer(){
        let offset:CGFloat = self._mainScrollView.contentOffset.x
        let nextPage = (Int)(offset/self._mainScrollView.frame.size.width) + 1
        
        if (nextPage != 4){
            //        [scrMain scrollRectToVisible:CGRectMake(nextPage*scrMain.frame.size.width, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
            self._mainScrollView.scrollRectToVisible(CGRect(x: CGFloat(nextPage) * self._mainScrollView.frame.size.width, y: 0, width: self._mainScrollView.frame.size.width, height: self._mainScrollView.frame.size.height), animated: true)
        } else {
            //        [scrMain scrollRectToVisible:CGRectMake(0, 0, scrMain.frame.size.width, scrMain.frame.size.height) animated:YES];
            self._mainScrollView.scrollRectToVisible(CGRect(x: 0, y: 0, width: self._mainScrollView.frame.size.width, height: self._mainScrollView.frame.size.height), animated: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func unwindForSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    @IBAction func prepareForUnwind(segue:UIStoryboardSegue){
    
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
