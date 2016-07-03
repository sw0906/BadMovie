//
//  BMTableViewCell.swift
//  BadMovie
//
//  Created by shou wei on 02/07/16.
//  Copyright © 2016年 shou wei. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage


class TestCell: UITableViewCell {
    
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateNumberLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rateView.layer.borderWidth = 2.0
        rateView.layer.cornerRadius = 3.0
        rateView.layer.borderColor = UIColor.whiteColor().CGColor
        rateView.clipsToBounds = true
        
        self.movieImage.hidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.movieImage.frame = CGRectMake(0,0,100,159);
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func bindMovie(movie: MovieItem) {
                self.movieImage.sd_setImageWithURL(movie.getBackdropUrl())
        //        self.movieImage.contentMode = UIViewContentMode.ScaleToFill
        
        rateLabel.text = movie.vote_average
        rateNumberLabel.text = movie.vote_count
    }
    
    func cancelDownload() {
        self.movieImage.sd_cancelCurrentImageLoad()
    }
}
