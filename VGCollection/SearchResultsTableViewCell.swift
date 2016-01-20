//
//  SearchResultsTableViewCell.swift
//  VGCollection
//
//  Created by Khoa Vo on 1/19/16.
//  Copyright © 2016 AppSynth. All rights reserved.
//

import UIKit

class SearchResultsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var labelVerticalConstraint: NSLayoutConstraint!
    
    // MARK: - Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
