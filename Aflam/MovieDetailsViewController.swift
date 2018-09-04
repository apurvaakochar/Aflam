//
//  MovieDetailsViewController.swift
//  Aflam
//
//  Created by Apurva Kochar on 9/4/18.
//  Copyright © 2018 careem. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailsViewController: UIViewController {

    /*
     Showing the movie poster and overview
     */
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overView: UITextView!
    var imageUrl: URL?
    var overviewText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButton.layer.masksToBounds = true
        closeButton.layer.cornerRadius = 15.0
        imageView.kf.setImage(with: imageUrl)
        overView.text = overviewText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func closedButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
