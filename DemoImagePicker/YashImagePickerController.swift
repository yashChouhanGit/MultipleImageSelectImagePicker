//
//  YashImagePickerController.swift
//  DemoImagePicker
//
//  Created by Yash on 26/02/21.
//

import UIKit
import Photos


class YashImagePickerController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView?
    
    let totalSpacing: CGFloat =  48
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegateAndDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        PhotoService.shared.initilizeFirstTime {
            
        }
      /*  DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.photoCollectionView?.reloadData()
        }*/
    }
    
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        photoCollectionView?.reloadData()
    }

}


extension YashImagePickerController {
    func configureDelegateAndDataSource() {
        photoCollectionView?.register(UINib(nibName:"PhotoCell", bundle: nil),
                                      forCellWithReuseIdentifier: "PhotoCell")

        photoCollectionView?.delegate = self
        photoCollectionView?.dataSource = self
    }
}

extension YashImagePickerController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoService.shared.numberOfAsserts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if let image = PhotoService.shared.mediaAsserts[ indexPath.row] as? UIImage {
            photoCell.configure(image)
        }
        if let video = PhotoService.shared.mediaAsserts[ indexPath.row] as? AVURLAsset {
            photoCell.configure(video)
        }
        return photoCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
        cell.didSelectAction()
    }
}

extension YashImagePickerController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = ((collectionView.frame.width - 48) / 2)
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
}

extension YashImagePickerController: UICollectionViewDelegate {
    
}
