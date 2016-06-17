//
//  TwitchBroadcast.swift
//  hoc22
//
//  Created by Markim Shaw on 6/10/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

class TwitchBroadcast {
    
    
    var _imagePreview:UIImageView!
    var _broadcastTitle:String!
    var _broadcastURL:String!
    
    init(imagePreview:UIImageView, broadcastTitle:String){
        self._imagePreview = imagePreview
        self._broadcastTitle = broadcastTitle
    }
    
    convenience init(imagePreview:UIImageView, broadcastTitle:String, videoUrl:String){
        self.init(imagePreview: imagePreview, broadcastTitle: broadcastTitle)
        self._broadcastURL = videoUrl
        
    }
}