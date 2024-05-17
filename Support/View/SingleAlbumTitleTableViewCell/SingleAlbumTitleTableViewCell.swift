//
//  SingleAlbumTitleTableViewCell.swift
//  Support
//
//  Created by Akram Ul Hasan on 9/5/24.
//

import UIKit

class SingleAlbumTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var selectedTitle: UIImageView!
    
    static let classname = String(describing: SingleAlbumTitleTableViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: SingleAlbumTitleTableViewCell.classname, bundle: nil)
    }
    
    public func configure(title: String, isSelectedTitle: Bool) {
        self.title.text = title
        
        if isSelectedTitle == true {
            selectedTitle.image = UIImage(named: "selected")
        } else {
            selectedTitle.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
