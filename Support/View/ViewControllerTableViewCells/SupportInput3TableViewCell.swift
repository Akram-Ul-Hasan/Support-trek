
import UIKit
import Photos

class SupportInput3TableViewCell: UITableViewCell {

    @IBOutlet weak var attachImagesView: UIView!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet var withAttachImageViewConstraint: NSLayoutConstraint!
    @IBOutlet var withCollectionViewConstraint: NSLayoutConstraint!
    
    var issueImagesAsset: [PHAsset] = []
    var isIssueImagesAssetRemoved: ((Int) -> Void)?
    var isAttachImagesViewClicked: (()-> Void)?

    static let classname = String(describing: SupportInput3TableViewCell.self)
    static public func nib() -> UINib {
        return UINib(nibName: SupportInput3TableViewCell.classname, bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
        setupTapGesture()
        setupCollectionView()
        updateUI()
    }
    
    public func configure(imageAssetCollection: [PHAsset]) {
        self.issueImagesAsset = imageAssetCollection
        updateUI()
    }

    private func setupUI() {
        attachImagesView.layer.cornerRadius = 1
        reviewBtn.layer.cornerRadius = reviewBtn.frame.size.height / 2
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(IssueImageCollectionViewCell.nib(), forCellWithReuseIdentifier: IssueImageCollectionViewCell.classname)
        collectionView.register(AddMoreIssueImageCollectionViewCell.nib(), forCellWithReuseIdentifier: AddMoreIssueImageCollectionViewCell.classname)
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(attachImagesViewTapped(_:)))
        attachImagesView.addGestureRecognizer(tapGesture)
        attachImagesView.isUserInteractionEnabled = true
    }
    
    

    @objc private func attachImagesViewTapped(_ sender: UITapGestureRecognizer) {
        isAttachImagesViewClicked?()
       
    }
    
    func updateReviewButton(enabled: Bool) {
        if enabled {
            reviewBtn.backgroundColor = UIColor(red: 0, green: 0.784, blue: 0.024, alpha: 1)
            reviewBtn.titleLabel?.textColor = UIColor(named: "backgroundColor")
            
        } else {
            reviewBtn.backgroundColor = UIColor(named: "buttonColor")
            reviewBtn.titleLabel?.textColor = UIColor.white
            reviewBtn.titleLabel?.textColor = UIColor(white: 0, alpha: 0.5)
        }
    }
   
    func updateUI() {
        let collectionViewIsActive = issueImagesAsset.count > 0
        self.attachImagesView.isHidden = collectionViewIsActive
        self.collectionView.isHidden = !collectionViewIsActive
            
        self.withAttachImageViewConstraint?.isActive = !collectionViewIsActive
        self.withCollectionViewConstraint?.isActive = collectionViewIsActive
        
        self.updateReviewButton(enabled: collectionViewIsActive)
        self.collectionView.reloadData()

        print("animated from support input 3 table view cell")
        UIView.animate(withDuration: 0.35) {
            self.contentView.layoutIfNeeded()
        }
    }
}


extension SupportInput3TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let maxItemsToShow = 5
        let actualItemCount = issueImagesAsset.count
        
        if actualItemCount < maxItemsToShow && actualItemCount > 0 {
            return actualItemCount + 1
        } else {
            return actualItemCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IssueImageCollectionViewCell.classname, for: indexPath) as? IssueImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        if issueImagesAsset.count < 5 {
            if indexPath.row == issueImagesAsset.count {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMoreIssueImageCollectionViewCell.classname, for: indexPath) as? AddMoreIssueImageCollectionViewCell else {
                    return UICollectionViewCell()
                }
                return cell
            }
        }
        
        cell.isCancelSelectedImageClicked = { index in
            self.issueImagesAsset.remove(at: index)
            collectionView.reloadData()
            self.updateUI()
            self.isIssueImagesAssetRemoved?(index)
        }
        cell.configure(asset: issueImagesAsset[indexPath.row], index: indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70.5, height: 70.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if issueImagesAsset.count < 5 {
            if indexPath.row == issueImagesAsset.count {
                isAttachImagesViewClicked?()
            }
        }
    }
}


