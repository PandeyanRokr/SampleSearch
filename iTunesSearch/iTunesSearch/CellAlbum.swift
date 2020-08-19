//
//  CellAlbum.swift
//  iTunesSearch
//
//  Created by Pandeyan Rokr on 2020-08-19.
//  Copyright © 2020 Razor. All rights reserved.
//

import UIKit

class CellAlbum: UITableViewCell {
    
    @IBOutlet weak var imgViewAlbum: UIImageView!
    @IBOutlet weak var lblArtistName: UILabel!
    @IBOutlet weak var lblTrackName: UILabel!
    @IBOutlet weak var lblCollectionName: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    let dateFormatter = DateFormatter()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpView(_ albumViewModel: AlbumViewModel, _ indexPath: IndexPath) {
        lblArtistName.text = albumViewModel.arrAlbum[indexPath.row].artistName
        lblCollectionName.text = albumViewModel.arrAlbum[indexPath.row].collectionName ?? ""
        lblTrackName.text = albumViewModel.arrAlbum[indexPath.row].trackName
        let releaseDate = albumViewModel.arrAlbum[indexPath.row].releaseDate
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let dateObj = dateFormatter.date(from: releaseDate)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.string(from: dateObj!)
        lblReleaseDate.text = date
        let priceValue: Float = albumViewModel.arrAlbum[indexPath.row].collectionPrice
        let currency = albumViewModel.arrAlbum[indexPath.row].currency
        let price = "\(priceValue)" + " " + currency
        lblPrice.text = price
        
        let imgURL = albumViewModel.arrAlbum[indexPath.row].artworkUrl100
        
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
