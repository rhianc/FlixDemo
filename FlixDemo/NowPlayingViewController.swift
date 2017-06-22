//
//  NowPlayingViewController.swift
//  FlixDemo
//
//  Created by Rhian Chavez on 6/21/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import AlamofireImage

class NowPlayingViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var movies: [[String: Any]] = []
    var refreshControl: UIRefreshControl!
    var selected: IndexPath?
    
    func fetchMovies(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=bce579dfade4b99c8c9e13bff0c532f4")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) {(data, response, error) in
            // This will run when the network request returns
            if let error = error {
                //print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //print(dataDictionary)
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let path = selected{
            tableView.deselectRow(at: selected!, animated: false)}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchMovies()
    }
    
    func didPullToRefresh(_ refreshControl: UIRefreshControl){
        fetchMovies()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return movies.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let imagePath = movie["poster_path"] as! String
        let begining: String = "https://image.tmdb.org/t/p/w500"
        
        let url = URL(string: begining + imagePath)!
        cell.Title.text = title
        cell.Description.text = overview
        cell.ImageSquare.af_setImage(withURL: url)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            selected = indexPath
            let movie = movies[indexPath.row]
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.movie = movie
        }
    }
}
