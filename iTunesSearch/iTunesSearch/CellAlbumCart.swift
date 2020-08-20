//
//  CellAlbumCart.swift
//  iTunesSearch
//
//  Created by Pandeyan Rokr on 2020-08-20.
//  Copyright © 2020 Razor. All rights reserved.
//

import UIKit

class CellAlbumCart: UITableViewCell {
    
    @IBOutlet weak var imgViewAlbum: UIImageView!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblCollectionName: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var btnDelete: UIButton!

    let dateFormatter = DateFormatter()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCartView(_ cartViewModel: CartViewModel, _ indexPath: IndexPath) {
        lblArtistName.text = cartViewModel.arrAlbum[indexPath.row].artistName
        lblCollectionName.text = cartViewModel.arrAlbum[indexPath.row].collectionName ?? ""
        lblTrackName.text = cartViewModel.arrAlbum[indexPath.row].trackName
        
        let releaseDate = cartViewModel.arrAlbum[indexPath.row].releaseDate
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dateObj = dateFormatter.date(from: releaseDate)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: dateObj!)
        lblReleaseDate.text = date
        let priceValue: Float = cartViewModel.arrAlbum[indexPath.row].collectionPrice
        let currency = cartViewModel.arrAlbum[indexPath.row].currency
        let price = "\(priceValue)" + " " + currency
        lblPrice.text = price
        
        let imgURL = cartViewModel.arrAlbum[indexPath.row].artworkUrl100
        
        if let cachedImage = APP_MANAGER.imageCache.object(forKey: imgURL as NSString) {
            self.imgViewAlbum.image = cachedImage
        } else {
            APP_MANAGER.downloadImage(url: URL(string: imgURL)!) { (image, error) in
                DispatchQueue.main.async {
                    if image != nil {
                        self.imgViewAlbum.image = image
                        APP_MANAGER.imageCache.setObject(image!, forKey: imgURL as NSString)
                    }else {
                        self.imgViewAlbum.image = UIImage(named: "icon_dummy")
                    }
                }
            }
        }
    }

}
