//
//  SecondViewController.swift
//  Simple iOS
//
//  Created by Jesús Martínez on 4/8/20.
//  Copyright © 2020 Jesús Martínez. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var photos = [Photo]()
    var isLoading = false
    var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = album?.title
        registerViewCells()
        loadData()
    }
    
    private func registerViewCells() {
        // Register Album Cell
        let imageCell = UINib(nibName: "PhotoViewCell",
                                  bundle: nil)
        collectionView.register(imageCell, forCellWithReuseIdentifier: "photoViewCell")
    }
    
    /**
     Fetch first albums and show them in TableViewCollection
     */
    func loadData() {
        isLoading = true
        
        Photo.fetch(start: self.photos.count, albumId: album?.id ?? 0, onCompletion : { response in
            self.isLoading = false
            self.photos.append(contentsOf: response)
            self.collectionView.reloadData()
        })
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoViewCell", for: indexPath) as! PhotoViewCell
        
        cell.setData(photo: photos[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 2 && !self.isLoading {
            loadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

}

