//
//  ShowMediaViewController.swift
//  DemoImagePicker
//
//  Created by Yash on 07/08/22.
//

import UIKit
import Photos


class ShowMediaViewController: UIViewController {

	@IBOutlet weak var showCollectionView: UICollectionView!
	
	var mediaArray :[Media] = []
	
	override func viewDidLoad() {
        super.viewDidLoad()
		configureDelegateAndDataSource()
        // Do any additional setup after loading the view.
    }


	@IBAction func onTappedbacKButton(_ sender: UIButton) {
		self.dismiss(animated: true)
	}
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ShowMediaViewController {
	func configureDelegateAndDataSource() {
		showCollectionView?.register(UINib(nibName:"PhotoCell", bundle: nil),
									  forCellWithReuseIdentifier: "PhotoCell")

		showCollectionView?.delegate = self
		showCollectionView?.dataSource = self
	}
}

extension ShowMediaViewController: UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return mediaArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
		let media = PhotoService.shared.mediaAsserts[ indexPath.row]
		if let image = media.asset as? UIImage {
			photoCell.configure(image, isSelect: false,isSelectionShow: false)
		}
		if let video = media.asset as? AVURLAsset {
			photoCell.configure(video, isSelect: false,isSelectionShow: false)
		}
		return photoCell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		/*guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
		var media = mediaArray[ indexPath.row]
		cell.didSelectAction(isSelect: !media.isSelect)
		media.isSelect = !media.isSelect
		PhotoService.shared.mediaAsserts[ indexPath.row] = media*/
	}
}

extension ShowMediaViewController: UICollectionViewDelegateFlowLayout {
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

extension ShowMediaViewController: UICollectionViewDelegate {
	
}
