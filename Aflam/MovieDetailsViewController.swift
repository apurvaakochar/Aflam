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
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closedButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
