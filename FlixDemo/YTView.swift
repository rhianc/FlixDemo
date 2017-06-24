//
//  YTView.swift
//  FlixDemo
//
//  Created by Rhian Chavez on 6/23/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YTView: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet var videoPlayer: YTPlayerView!
    var url: URL?
    var videoJson: [[String: Any]] = []
    var key: String = "none"
    
    override func viewDidLoad() {
        getVideo()
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
