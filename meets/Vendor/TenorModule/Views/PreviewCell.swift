//
//  PreviewCell.swift
//  Tenorize
//
//  Created by Eric Giannini on 8/29/18.
//  Copyright © 2018 Eric Giannini. All rights reserved.
//

import UIKit
import SwiftyGif

class PreviewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var entity : GIF!{
        didSet {

            /* resultsArray[indexPath.row].media?.first?.mp4?.preview */
            if let url = entity.media?.first?.gif?.url{
                let loader = UIActivityIndicatorView.init(style: .medium)
                self.thumbImageView.setGifFromURL(url, customLoader: loader)
            }
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()

        thumbImageView.image = nil
    }
}
