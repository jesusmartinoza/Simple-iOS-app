//
//  FirstViewController.swift
//  Simple iOS
//
//  Created by Jesús Martínez on 4/8/20.
//  Copyright © 2020 Jesús Martínez. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController {

    public let parallaxHeader = ParallaxHeader()
    @IBOutlet weak var albumsTableView: UITableView!
    
    var isLoading = false
    var itemsArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup header
        albumsTableView.tableHeaderView = parallaxHeader.parallaxHeaderViewWithImage(
            UIImage(named: "albums")!,
            headerSize: CGSize(width: albumsTableView.frame.size.width, height: 200),
            title : "Albums")
        parallaxHeader.layoutHeaderViewForScrollViewOffset(albumsTableView.contentOffset)
        
        // Setup TableView
        registerTableViewCells()
        
        self.albumsTableView.delegate = self
        self.albumsTableView.dataSource = self
        
        loadData()
    }
    
    private func registerTableViewCells() {
        // Register Album Cell
        let textFieldCell = UINib(nibName: "AlbumViewCell",
                                  bundle: nil)
        self.albumsTableView.register(textFieldCell,
                                forCellReuseIdentifier: "albumViewCell")
        
        // Register Loading Cell
        let tableViewLoadingCellNib = UINib(nibName: "LoadingViewCell", bundle: nil)
        self.albumsTableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingCellId")
    }
    
    func loadData() {
        self.isLoading = false
        
        for i in 0...20 {
            itemsArray.append("Item \(i)")
        }
        self.albumsTableView.reloadData()
    }
    
    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            let start = itemsArray.count
            let end = start + 16
            DispatchQueue.global().async {
                // fake background loading task
                sleep(2)
                for i in start...end {
                    self.itemsArray.append("Item \(i)")
                }
                DispatchQueue.main.async {
                    self.albumsTableView.reloadData()
                    self.isLoading = false
                }
            }
        }
    }
}

extension AlbumsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if (offsetY > contentHeight - scrollView.frame.height * 4) && !isLoading {
            loadMoreData()
        }
        
        parallaxHeader.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Return the amount of albums
            return itemsArray.count
        } else if section == 1 {
            // Return the Loading cell
            return 1
        } else {
            // Return nothing
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 64 // Item Cell height
        } else {
            return 72 // Loading Cell height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumViewCell", for: indexPath) as! AlbumViewCell
            cell.setData(album: itemsArray[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCellId", for: indexPath) as! LoadingViewCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
}
