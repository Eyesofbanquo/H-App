//
//  YouTubeTableViewCell.swift
//  hoc22
//
//  Created by Markim Shaw on 6/13/16.
//  Copyright © 2016 Markim Shaw. All rights reserved.
//

import UIKit

class YouTubeTableViewCell: UITableViewCell {

    @IBOutlet weak var _image:UIImageView!
    @IBOutlet weak var _title:UILabel!
    @IBOutlet weak var _background:UIView!
    @IBOutlet weak var _youtube_player:YTPlayerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
