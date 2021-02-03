//
//  PhotosCollectionViewController.swift
//  CameraFilter
//
//  Created by Luís Felipe Polo on 23/01/21.
//

import UIKit
import Photos
import RxSwift

class PhotosCollectionViewController : UICollectionViewController {
    
    var images = [PHAsset]()
    private let selectedPhotoSubject = PublishSubject<UIImage>()
    var selectedPhoto : Observable<UIImage> {
        return selectedPhotoSubject.asObservable()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populatePhotos()
    }

    private func populatePhotos() {
        PHPhotoLibrary.requestAuthorization(receivedAuthorizationStatus(status:))
    }

    func receivedAuthorizationStatus(status : PHAuthorizationStatus) {
        if status == .authorized {
            let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)

            assets.enumerateObjects { [weak self] object, count, stop in
                self?.images.append(object)
            }
            
            images.reverse()
            print(images)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let asset = self.images[indexPath.row]
        let manager = PHImageManager.default()
        
        manager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { image, error in
            cell.photoImageView.image = image
            
        }
        
        return cell
         
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAsset = self.images[indexPath.row]
        PHImageManager.default().requestImage(for: selectedAsset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { [weak self] image, info in
            
            guard let info = info else {
                return
            }
            
            let isThumb = info["PHImageResultIsDegradedKey"] as! Bool
            
            if !isThumb, let image = image {
                self?.selectedPhotoSubject.onNext(image)
                self?.dismiss(animated: true, completion: nil)
            }
            
        }
    }
    
}
