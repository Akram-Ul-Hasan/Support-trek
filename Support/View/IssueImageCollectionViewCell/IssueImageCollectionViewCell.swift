//
//  IssueImageCollectionViewCell.swift
//  Support
//
//  Created by Akram Ul Hasan on 9/5/24.
//

import UIKit
import Photos

class IssueImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageHoldingView: UIView!
    @IBOutlet weak var image: UIImageView!
        
    var isCancelSelectedImageClicked: ((Int) -> Void)?
    var index = Int()
    
    static let classname = String(describing: IssueImageCollectionViewCell.self)
    static func nib() -> UINib {
        return UINib(nibName: IssueImageCollectionViewCell.classname, bundle: nil)
    }
    
    public func configure(asset: PHAsset, index: Int) {
        self.index = index
        asset.getImage(targetSize: CGSize(width: self.frame.size.width, height: self.frame.size.height), completion: { image in
            self.image.image = image
        })
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        imageHoldingView.layer.cornerRadius = 6
        imageHoldingView.clipsToBounds = true
        imageHoldingView.layer.borderWidth = 0.5
        imageHoldingView.layer.borderColor = UIColor(named: "labelColor")?.cgColor
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        isCancelSelectedImageClicked?(index)

    }
}
