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
import FontAwesomeIconFactory


class TestCell: UITableViewCell {
    
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateNumberLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var GenreLabel: UILabel!
    
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var peopleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rateView.layer.borderWidth = 2.0
        rateView.layer.cornerRadius = 3.0
        rateView.layer.borderColor = UIColor.whiteColor().CGColor
        rateView.clipsToBounds = true
        
        self.movieImage.hidden = false
        setupRateView()
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
        self.movieImage.kf_setImageWithURL(movie.getBackdropUrl(), placeholderImage: UIImage(named: "Poo"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        rateLabel.text = movie.vote_average
        rateNumberLabel.text = movie.vote_count
        
        rateLabel.text = movie.vote_average
        rateNumberLabel.text = movie.vote_count
        GenreLabel.text = movie.getGenreName()
        titleLabel.text = movie.title
        
        addShadowColor(titleLabel)
    }
    
    func addShadowColor(label: UILabel)
    {
        label.shadowColor = UIColor.flatBlackColor()
        label.shadowOffset = CGSizeMake(1, 1)
    }
    
    func cancelDownload() {
        self.movieImage.sd_cancelCurrentImageLoad()
    }
}
