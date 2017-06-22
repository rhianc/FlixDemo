//
//  DetailViewController.swift
//  FlixDemo
//
//  Created by Rhian Chavez on 6/21/17.
//  Copyright © 2017 Rhian Chavez. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {

    @IBOutlet weak var backdrop: UIImageView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    var movie: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageStarter = "https://image.tmdb.org/t/p/w500"

        if let movie = movie {
            detailTitle.text = movie["title"] as? String
            releaseDate.text = movie["release_date"] as? String
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

}
