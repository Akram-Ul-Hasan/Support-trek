//
//  IssueTypeTableViewCell.swift
//  Support
//
//  Created by Akram Ul Hasan on 7/5/24.
//

import UIKit

class IssueTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var issueSingleOption: UILabel!
    
    @IBOutlet weak var isSelectedOptionImg: UIImageView!
    
    static let classname = String(describing: IssueTypeTableViewCell.self)
    static public func nib() -> UINib {
        return UINib(nibName: IssueTypeTableViewCell.classname, bundle: nil)
    }
    
    public func configure(title: String, isSelectedItem: Bool) {
        issueSingleOption.text = title
        if isSelectedItem {
            isSelectedOptionImg.image = UIImage(named: "selected")
        } else {
            isSelectedOptionImg.image = nil
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
