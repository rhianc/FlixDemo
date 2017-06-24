//
//  CollectionViewController.swift
//  FlixDemo
//
//  Created by Rhian Chavez on 6/22/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import Alamofire

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    //@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var movies: [[String: Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellsPerLine: CGFloat = 2
        let rowsPerView: CGFloat = 2.1
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset.top = 0
        let width = collectionView.frame.size.width/cellsPerLine
        print(width)
        let height = collectionView.frame.size.height/rowsPerView
        print(height)
        layout.itemSize = CGSize(width: width, height: height)
        fetchMovies()

        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMovies(){
        //activityIndicator.startAnimating()
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=bce579dfade4b99c8c9e13bff0c532f4")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
                //self.errorAlert()
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //print(dataDictionary)
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.collectionView.reloadData()
                //self.refreshControl.endRefreshing()
                //self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = movies[indexPath.row]
        //let title = movie["title"] as! String
        //let overview = movie["overview"] as! String
        let imagePath = movie["poster_path"] as! String
        let begining: String = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: begining + imagePath)!
        cell.CoverImage.af_setImage(withURL: url)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let cell = sender as! UICollectionViewCell
        if let indexPath = collectionView.indexPath(for: cell){
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }

}
