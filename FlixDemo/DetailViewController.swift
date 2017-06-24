//
//  DetailViewController.swift
//  FlixDemo
//
//  Created by Rhian Chavez on 6/21/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import AlamofireImage
import youtube_ios_player_helper

class DetailViewController: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var videoPlayer: YTPlayerView!
    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    let format = DateFormatter()
    let prettyformat = DateFormatter()
    var movie: [String: Any]?
    var url: URL?
    var videoJson: [[String: Any]] = []
    var key: String = "none"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let imageStarter = "https://image.tmdb.org/t/p/w500"

        if let movie = movie {
            //print(movie)
            let movieIDnum = movie["id"] as! Int
            let movieID = String(movieIDnum)
            //print(movieID)
            let st = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=bce579dfade4b99c8c9e13bff0c532f4&language=en-US"
            //print(st)
            url = URL(string: st)!
            getVideo()
            movieTitle.text = movie["title"] as? String
            let releaseDatePrimitive = movie["release_date"] as! String
            format.dateFormat = "yyyy-MM-dd"
            let finalDate = format.date(from: releaseDatePrimitive)
            prettyformat.dateFormat = "MMM dd, yyyy"
            releaseDate.text = prettyformat.string(from: finalDate!)
            overview.text = movie["overview"] as? String
            let backdropPath = movie["backdrop_path"] as! String
            let coverPath = movie["poster_path"] as! String
            let backURL = URL(string: imageStarter + backdropPath)!
            let coverURL = URL(string: imageStarter + coverPath)!
            backdrop.af_setImage(withURL: backURL)
            poster.af_setImage(withURL: coverURL)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func playVideo(){
        //let videoID = "https://www.youtube.com/watch?v=\(key)"
        //videoPlayer.loadVideo(byURL: videoID, startSeconds: 0.0, suggestedQuality: .small)
        videoPlayer.delegate = self
        videoPlayer.load(withVideoId: key)
        videoPlayer.playVideo()
    }
    
    func getVideo(){
        //print(self.url)
        let request = URLRequest(url: self.url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        //print("got this far")
        let task = session.dataTask(with: request) {(data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
                print("not getting Data")
                //self.errorAlert()
            } else if let data = data {
                print("getting Data")
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //print(dataDictionary)
                self.videoJson = dataDictionary["results"] as! [[String: Any]]
                //self.movies = movies
                //self.tableView.reloadData()
                //self.refreshControl.endRefreshing()
                //self.activityIndicator.stopAnimating()
                let first = self.videoJson[0] as [String: Any]
                self.key = first["key"] as! String
                //print(self.videoJson)
                self.playVideo()
            }
        }
        task.resume()
        //print("did this too")
    }
}
