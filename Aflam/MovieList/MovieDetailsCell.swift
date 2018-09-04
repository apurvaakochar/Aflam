//
//  MovieDetailsCell.swift
//  Aflam
//
//  Created by Apurva Kochar on 9/1/18.
//  Copyright © 2018 careem. All rights reserved.
//

import UIKit

class MovieDetailsCell: UITableViewCell {


    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.layer.masksToBounds = true
        mainView.layer.cornerRadius = 10.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
