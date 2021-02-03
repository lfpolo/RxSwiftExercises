//
//  ViewController.swift
//  CameraFilter
//
//  Created by Luís Felipe Polo on 23/01/21.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var applyFilter: UIButton!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Camera Filter"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navc = segue.destination as? UINavigationController, let photosCVC = navc.viewControllers.first as? PhotosCollectionViewController else {
            return
        }
        
        photosCVC.selectedPhoto.subscribe(onNext: { [weak self] photo in
            self?.updateUI(with: photo)
        }).disposed(by: disposeBag)
        
    }
    
    @IBAction func applyButtonPressed(_ sender: UIButton) {
        guard let sourceImage = self.imageView.image else {
            return
        }
        
        FilterService().applyFilter(to: sourceImage)
        .subscribe(onNext : { filteredImage in
            DispatchQueue.main.async {
                self.imageView.image = filteredImage
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateUI(with image : UIImage) {
        self.imageView.image = image
        self.applyFilter.isHidden = false
    }
}

