//
//  YouTubeVideo.swift
//  hoc22
//
//  Created by Markim Shaw on 6/12/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import Foundation
import UIKit

class YouTubePlaylist{
    var _title:String!
    var _imagePreview:UIImageView!
    var _playlist_id:String!
    
    init(title:String, imagePreview:UIImageView, playlist_id:String){
        self._title = title
        self._imagePreview = imagePreview
        self._playlist_id = playlist_id
    }
}

class YouTubeVideo{
    var _title:String!
    var _imagePreview:UIImageView!
    var _playlist_id:String!
    
    init(title:String, imagePreview:UIImageView, playlist_id:String){
        self._title = title
        self._imagePreview = imagePreview
        self._playlist_id = playlist_id
    }
}