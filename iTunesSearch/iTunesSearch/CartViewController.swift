//
//  CartViewController.swift
//  iTunesSearch
//
//  Created by Pandeyan Rokr on 2020-08-20.
//  Copyright © 2020 Razor. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewCart: UITableView!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblItems: UILabel!
    
    var cartViewModel = CartViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableViewCart.estimatedRowHeight = UITableView.automaticDimension
        tableViewCart.rowHeight = UITableView.automaticDimension
        tableViewCart.tableFooterView = UIView()
        self.cartViewModel.getPriceAndCount { (count, price) in
            DispatchQueue.main.async {
                self.lblItems.text = "Item Count: \(count)"
                self.lblTotal.text = String(format: "Amount: %.2f \(self.cartViewModel.currency)", price)
                self.tableViewCart.reloadData()
            }
        }
        
    }
    
    //MARK:- TableView DataSource & Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel.arrAlbum.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellAlbumCart", for: indexPath) as! CellAlbumCart
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(deleteAlbumFromCart(_:)), for: .touchUpInside)
        cell.setUpCartView(cartViewModel, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func deleteAlbumFromCart(_ sender: UIButton) {
        self.cartViewModel.removeItemFromCart(index: sender.tag) { (count, price) in
            
            DispatchQueue.main.async {
                self.lblItems.text = "Item Count: \(count)"
                self.lblTotal.text = String(format: "Amount: %.2f \(self.cartViewModel.currency)", price)
                if count == 0 {
                    self.navigationController?.popViewController(animated: true)
                }else {
                    self.tableViewCart.reloadData()
                }
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
