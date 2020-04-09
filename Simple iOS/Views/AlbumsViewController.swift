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
    var albums = [Album]()

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
    
    
    /**
    Fetch and handle infinity scroll
    */
    func loadData() {
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global().async {
                sleep(1) // A little more of time to see the animation
                Album.fetch(start: self.albums.count, onCompletion : { response in
                    self.isLoading = false
                    self.albums.append(contentsOf: response)
                    self.albumsTableView.reloadData()
                })
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
            loadData()
        }
        
        parallaxHeader.layoutHeaderViewForScrollViewOffset(scrollView.contentOffset)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // Return the amount of albums
            return albums.count
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0 {
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let photosViewController = storyBoard.instantiateViewController(withIdentifier: "photosView") as! PhotosViewController
            photosViewController.album = albums[indexPath.row]
            
            self.navigationController?.pushViewController(photosViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "albumViewCell", for: indexPath) as! AlbumViewCell
            cell.setData(album: albums[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCellId", for: indexPath) as! LoadingViewCell
            cell.activityIndicator.startAnimating()
            return cell
        }
    }
}
