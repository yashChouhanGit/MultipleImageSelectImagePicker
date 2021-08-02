//
//  PhotoCell.swift
//  DemoImagePicker
//
//  Created by Yash on 26/02/21.
//

import UIKit
import AVKit


class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBOutlet weak var toggleView: UIView! {
        didSet {
            toggleView.backgroundColor  = .white
            toggleView.layer.cornerRadius = toggleView.frame.width / 2
            toggleView.layer.borderWidth = 1.5
            toggleView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    @IBOutlet weak var centerToggleButton: UIView! {
        didSet {
            centerToggleButton.backgroundColor  = #colorLiteral(red: 0.5039543498, green: 0.7868612047, blue: 1, alpha: 1)
            centerToggleButton.layer.cornerRadius = centerToggleButton.frame.width / 2
        }
    }
    
    @IBOutlet weak var videoView: UIView!
    
    func configure(_ image: UIImage?) {
        photoImageView.isHidden = false
        videoView.isHidden = true
        photoImageView.image = image
        photoImageView.contentMode = .scaleToFill
    }
    
    func configure(_ asset: AVURLAsset?) {
        guard let asset  = asset else {
            photoImageView.isHidden = true
            videoView.isHidden = false
            return
        }
        photoImageView.isHidden = true
        videoView.isHidden = false
        let url = asset.url
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.bounds
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.player?.play()
        videoView.layer.addSublayer(playerLayer)
    }
    
    func didSelectAction() {
        centerToggleButton.isHidden = !centerToggleButton.isHidden
    }
    
}
