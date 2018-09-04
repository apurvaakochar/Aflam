//
//  MovieDetailsCell.swift
//  Aflam
//
//  Created by Apurva Kochar on 9/1/18.
//  Copyright © 2018 careem. All rights reserved.
//

import UIKit

class MovieDetailsCell: UITableViewCell {

    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
