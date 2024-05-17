//
//  AllPhotosViewController.swift
//  Support
//
//  Created by Akram Ul Hasan on 9/5/24.
//

import UIKit
import Photos

class AllPhotosViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let photoManager = PhotoManager.shared
    
    private var allPhotoAssets: [PHAsset] = []
    private var photoAssetToShow: [PHAsset] = []
    private var allAlbumAssetCollection: [PHAssetCollection] = []
    private var albumAssetCollectionToShow = PHAssetCollection()
    private var albumListTitles: [String] = []
    
    private var cellSize = CGFloat()
    
    private var titleLabel = UILabel()
    private var button = UIButton(type: .system)
    
    private var selectedImagesFromGallery: [PHAsset] = []
    
    var didSelectedImages : (([PHAsset]) -> Void)?
    
    var maxImageLimit = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Photos"

        self.setupCollectionViewUI()
        self.setupTitleView()
        self.requestPhotoAuthorization()
        self.setupLeftBarButton()
    }
    
    override func viewDidLayoutSubviews() {
        self.cellSize = collectionView.frame.width / 3
    }
    
    private func setupCollectionViewUI() {
        self.collectionView.register(SinglePhotoCollectionViewCell.nib(), forCellWithReuseIdentifier: SinglePhotoCollectionViewCell.className)
        self.collectionView.register( PreviewCameraCollectionViewCell.nib(), forCellWithReuseIdentifier: PreviewCameraCollectionViewCell.className)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func setupTitleView() {
        let titleView = createCustomTitleView()
        self.navigationItem.titleView = titleView
    }
    
    private func createCustomTitleView() -> UIView {
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        self.titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
        titleLabel.text = "All Photos"
        titleLabel.textAlignment = .center
        titleView.addSubview(titleLabel)

        self.button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        button.addTarget(self, action: #selector(titleViewButtonTapped), for: .touchUpInside)
        button.frame = CGRect(x: titleLabel.frame.maxX + 10, y: 0, width: 44, height: 44)
        titleView.addSubview(button)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(titleViewButtonTapped))
        titleView.addGestureRecognizer(tapGesture)

        return titleView
    }
    
    private func requestPhotoAuthorization() {
        photoManager.requestAuthorization { [weak self] authorized in
            guard let self = self else { return }
            if authorized {
                self.fetchPhotosAndAlbums()
            } else {
                print("Access to photo library denied.")
            }
        }
    }
    
    private func fetchPhotosAndAlbums() {
        photoManager.fetchAllPhotos { [weak self] photoAssets in
            guard let self = self else { return }
            if let photoAssets = photoAssets {
                self.allPhotoAssets = photoAssets
                self.photoAssetToShow = photoAssets
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                print("Failed to fetch photos.")
            }
        }
        
        photoManager.fetchAllAlbums { [weak self] albums in
            guard let self = self else { return }
            if let albums = albums {
                self.allAlbumAssetCollection = albums
                self.albumListTitles = ["All Photos"] + albums.compactMap { $0.localizedTitle }
            } else {
                print("Failed to fetch albums.")
            }
        }
    }
    
    func setupRightBarButton() {
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonTapped))
        
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func setupLeftBarButton() {
        let closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        let closeBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        navigationItem.leftBarButtonItem = closeBarButtonItem
    }

    @objc func closeButtonTapped() {
        // Dismiss the presented view controller
        dismiss(animated: true, completion: nil)
    }
        
    @objc func doneButtonTapped() {

        self.dismiss(animated: true) {
            self.didSelectedImages?(self.selectedImagesFromGallery)
        }

    }
    
    @objc private func titleViewButtonTapped() {
        self.button.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)

        guard let viewControllerToPresent = storyboard?.instantiateViewController(withIdentifier: "AlbumListViewController") as? AlbumListViewController else {
            return
        }
        
        viewControllerToPresent.isPresent = { [weak self] isPresented in
            DispatchQueue.main.async {
                if isPresented {
                    self?.button.setImage(UIImage(systemName: "arrowtriangle.up.fill"), for: .normal)
                } else {
                    self?.button.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
                }
            }
        }
        
        viewControllerToPresent.selectedOption = { [weak self] option in
            if !option.isEmpty {
                self?.albumPhotoToShowOnCollectionView(albumTitle: option)
            }
            
        }
        
        viewControllerToPresent.optionTitles = self.albumListTitles
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [ .medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            
        }


        self.navigationController?.present(viewControllerToPresent, animated: true)
    }
    
 
    
    func albumPhotoToShowOnCollectionView(albumTitle: String) {
        if albumTitle == "All Photos" {
            self.photoAssetToShow = self.allPhotoAssets
            self.titleLabel.text = "All Photos"

        } else {
            for album in allAlbumAssetCollection {
                if album.localizedTitle == albumTitle {
                    self.albumAssetCollectionToShow = album
                    break
                }
            }
            albumAssetCollectionToShow.getImagesFromSingleAlbum { photoAsset in
                self.photoAssetToShow = photoAsset
                self.titleLabel.text = albumTitle
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

//collectionview functions
extension AllPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoAssetToShow.count+1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewCameraCollectionViewCell.className, for: indexPath) as? PreviewCameraCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SinglePhotoCollectionViewCell.className, for: indexPath) as? SinglePhotoCollectionViewCell else{
                return UICollectionViewCell()
            }
            
            let photoAsset = photoAssetToShow[indexPath.row - 1]
            if selectedImagesFromGallery.contains(photoAsset) {
                cell.selectedImage.image = UIImage(named: "selected")
            } else {
                cell.selectedImage.image = nil
            }
            cell.configure(asset: photoAsset, targetSize: CGSizeMake(self.cellSize, self.cellSize))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.cellSize, height: self.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        setupRightBarButton()
        
        if indexPath.row == 0 {
            if let cameraCell = collectionView.cellForItem(at: indexPath) as? PreviewCameraCollectionViewCell {
                cameraCell.startCamera(withDelay: 0.0)
            }
            return
        }
        
        let selectedPhotoAsset = self.photoAssetToShow[indexPath.item - 1]

        if selectedImagesFromGallery.count < maxImageLimit {
            if let index = selectedImagesFromGallery.firstIndex(of: selectedPhotoAsset)  {
                selectedImagesFromGallery.remove(at: index)
            } else {
                selectedImagesFromGallery.append(selectedPhotoAsset)
            }
        } else {
          
//            print("else condition working")
            
            if let index = selectedImagesFromGallery.firstIndex(of: selectedPhotoAsset)  {
                selectedImagesFromGallery.remove(at: index)
            } else {
                self.showImageLimitExceededAlert()
            }
        }
        
        
        collectionView.reloadItems(at: [indexPath])
//        self.doneButtonTapped()
    }
    
    func showImageLimitExceededAlert() {
        let alertController = UIAlertController(title: "Alert", message: "Maximum image limit exceeded.", preferredStyle: .alert)
        
        // Add an OK button to the alert
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cellIndexPath = IndexPath(row: 0, section: 0)
        guard let cameraCell = collectionView.cellForItem(at: cellIndexPath) as? PreviewCameraCollectionViewCell else {
            return
        }

        let cellRect = collectionView.convert(cameraCell.frame, to: collectionView.superview)
        let isIntersecting = collectionView.bounds.intersects(cellRect)

        if !isIntersecting{
            cameraCell.stopCamera()
        }
    }

}
