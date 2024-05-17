//
//  SinglePhotoCollectionViewCell.swift
//  Support
//
//  Created by Akram Ul Hasan on 9/5/24.
//

import UIKit
import Photos


class SinglePhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var singleImage: UIImageView!
    @IBOutlet weak var selectedImage: UIImageView!
    
    static var className = String(describing: SinglePhotoCollectionViewCell.self)
    static func nib() -> UINib{
        return UINib(nibName: SinglePhotoCollectionViewCell.className, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        singleImage.layer.cornerRadius = 2
        singleImage.clipsToBounds = true
    }
    
    public func configure( asset: PHAsset?, targetSize: CGSize) {
        asset?.getImage(targetSize: targetSize, completion: { photo in
            self.singleImage.image = photo
        })
    }
}
