//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Pandeyan Rokr on 2020-08-19.
//  Copyright © 2020 Razor. All rights reserved.
//

import UIKit

struct ResultModel: Codable {
    var resultCount: Int
    var results: [Album]
}

struct Album: Codable, Hashable {
    var trackId: Int
    var artistName: String
    var collectionName: String?
    var trackName: String
    var artworkUrl100: String
    var collectionPrice: Float
    var currency: String
    var releaseDate: String
    var isSelected: Bool?
}

class AlbumSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var searchBarAlbum: UISearchBar!
    @IBOutlet weak var tableViewAlbum: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var btnSort: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    
    var albumViewModel = AlbumViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableViewAlbum.estimatedRowHeight = UITableView.automaticDimension
        tableViewAlbum.rowHeight = UITableView.automaticDimension
        tableViewAlbum.tableFooterView = UIView()
        searchBarAlbum.showsCancelButton = true
        self.loader.startAnimating()
        albumViewModel.fetchAlbum { (albumArray) in
            if albumArray != nil {
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.loader.isHidden = true
                    self.tableViewAlbum.reloadData()
                }
            }else {
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.loader.isHidden = true
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(checkCartDelete), name: .cartDelete, object: nil)
    }
    
    //MARK:- Check Cart Zero
    @objc func checkCartDelete(_ notification:Notification) {
        let trackId = notification.userInfo![KEY_TRACK_ID] as! Int
        self.albumViewModel.updateAlbumCart(trackId)
        self.tableViewAlbum.reloadData()
    }

    //MARK:- TableView DataSource & Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumViewModel.arrAlbum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAlbum", for: indexPath) as! CellAlbum
        cell.btnSelect.tag = indexPath.row
        cell.btnSelect.addTarget(self, action: #selector(addItemToCart(_:)), for: .touchUpInside)
        cell.setUpView(albumViewModel, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.albumViewModel.addAlbumToCart(indexPath.row) {
            self.tableViewAlbum.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK:- Search Bar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.albumViewModel.searchAlbum(searchText.lowercased()) {
            self.reloadTableAlbum()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarAlbum.resignFirstResponder()
    }
    
    //MARK:- Throw Alert
    func throwAlert(title:String?,msg:String) {
        
        DispatchQueue.main.async {
            let alertView = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let btnDismiss = UIAlertAction(title: "OK", style: .default) { (action) in
                alertView.dismiss(animated: true, completion: nil)
            }
            alertView.addAction(btnDismiss)
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    //MARK:- Sort Action
    @IBAction func sortAction(_ sender: UIButton) {
        
        let sortMenu = UIAlertController(title: nil, message: "Sort By", preferredStyle: .actionSheet)
            
        let btnArtist = UIAlertAction(title: "Artist", style: .default) { (action) in
            self.albumViewModel.sortAlbum(.Artist) {
                self.reloadTableAlbum()
            }
            
        }
        let btnCollection = UIAlertAction(title: "Collection", style: .default) { (action) in
            self.albumViewModel.sortAlbum(.Collection) {
                self.reloadTableAlbum()
            }
            
        }
        let btnTrack = UIAlertAction(title: "Track", style: .default) { (action) in
            self.albumViewModel.sortAlbum(.Track) {
                self.reloadTableAlbum()
            }
            
        }
        let btnPrice = UIAlertAction(title: "Price", style: .default) { (action) in
            self.albumViewModel.sortAlbum(.Price) {
                self.reloadTableAlbum()
            }
        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
        sortMenu.addAction(btnArtist)
        sortMenu.addAction(btnCollection)
        sortMenu.addAction(btnTrack)
        sortMenu.addAction(btnPrice)
        sortMenu.addAction(cancelAction)
            
        self.present(sortMenu, animated: true, completion: nil)
        
    }
    
    //MARK:- Goto Cart View
    @IBAction func cartButtonAction(_ sender: UIButton) {
        self.albumViewModel.gotoCartView(self)
    }
    
    //MARK:- Reload Table
    private func reloadTableAlbum() {
        DispatchQueue.main.async {
            self.tableViewAlbum.reloadData()
        }
    }
    
    //MARK:- Add Item To Cart
    @objc func addItemToCart(_ sender: UIButton) {
        self.albumViewModel.addAlbumToCart(sender.tag) {
            self.tableViewAlbum.reloadRows(at: [IndexPath(row: sender.tag, section: 0)], with: .none)
        }
    }

}

