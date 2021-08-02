//
//  ViewController.swift
//  DemoImagePicker
//
//  Created by Yash on 26/02/21.
//

import UIKit
import Photos
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        PhotoService.shared.initilizeFirstTime {}
    }

    @IBAction func pickImagesAction(_ sender: UIButton) {
        pickImage()
    }
}


extension ViewController {
    func checkAuthorization(completion: @escaping () -> Void) {
        let status =  PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { value in
                guard status  == .authorized else { return }
                completion()
            }
        case .denied,.limited,.restricted: break
        default:break
        }
    }
    
    func pickImage() {
        checkAuthorization {
            print(">>>>>START")
            PhotoService.shared.initilizeFirstTime {
                guard let scene = self.storyboard?.instantiateViewController(withIdentifier: "YashImagePickerController") as? YashImagePickerController else {
                    return
                }
                self.present(scene, animated: true)
                print(">>>>>END")
            }
        }
    }
}


class PhotoService {
    
    private var assets : [PHAsset] = []
    private typealias ImageCompletion = UIImage?
    private typealias VideoCompletion = AVURLAsset?
    
    var mediaAsserts : [Any] = []
    var size : CGSize = CGSize(width: 500, height: 500)
    var contentMode : PHImageContentMode = .aspectFit
    var numberOfAsserts: Int {
        mediaAsserts.count
    }
    
    static var shared = PhotoService()
    
    private init() {}
    
    func initilizeFirstTime(completion: @escaping () -> Void) {
        guard mediaAsserts.isEmpty else { return completion() }
        getPhotoAssets {
            self.assetsToImages {
                completion()
            }
        }
    }
    
    private func proceessingPhotosAssets(photos: PHFetchResult<PHAsset>,
                                         completion: @escaping () -> Void) {
        guard photos.count == 0 else {
            (0..<photos.count).forEach {
                assets.append(photos[$0])
            }
            completion()
            return
        }
        completion()
    }
    
    private func proceessingVideoAssets(videos:PHFetchResult<PHAsset>,
                                        completion: @escaping () -> Void) {
        guard videos.count == 0 else {
            (0..<videos.count).forEach {
                assets.append(videos[$0])
            }
            completion()
            return
        }
        completion()
    }
    
    private func getPhotoAssets(completion: @escaping () -> Void) {
        let fetchOptions = PHFetchOptions()
        let assetImageReesult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        let assetVideoReesult = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        proceessingPhotosAssets(photos: assetImageReesult) { [weak self] in
            guard let self = self else { return  completion() }
            self.proceessingVideoAssets(videos: assetVideoReesult) {
                completion()
            }
        }
    }
    
    private func assetsToImages(completion: @escaping () -> Void) {
        guard !assets.isEmpty else {
            return  completion()
        }
        assets.enumerated().forEach {
            if $0.element.mediaType == .image {
                convertPhotoAssertIntoImage($0.element) { [weak self] image in
                    if
                        let self = self,
                        let image = image {
                        self.mediaAsserts.append(image)
                    }
                }
            } else {
                convertAssertIntoVideo($0.element) { [weak self] avUrlAssert in
                    if
                        let self = self,
                        let urlAssert = avUrlAssert {
                        self.mediaAsserts.append(urlAssert)
                    }
                }
            }
            
            if $0.offset == (assets.count - 1) {
                completion()
            }
        }
    }
    
    private func convertPhotoAssertIntoImage(_ photoAsset: PHAsset,
                                             completion: @escaping (ImageCompletion) -> Void ) {
        
        let imageManager = PHCachingImageManager()
        let imageOption = PHImageRequestOptions()
        imageOption.resizeMode = .exact
        imageOption.deliveryMode = .highQualityFormat
        imageOption.progressHandler = {  (progress, error, stop, info) in
            print("progress: \(progress)")
        }
        imageManager
            .requestImage(for: photoAsset,
                          targetSize: size,
                          contentMode: contentMode,
                          options: imageOption) { image , info in
                print(">>>>>>>>>>>>>>>>>>>>>>>>S")
                print("info  \(info)")
                print(">>>>>>>>>>>>>>>>>>>>>>>>E")
                completion(image)
            }
    }
    
    private func convertAssertIntoVideo(_ asset: PHAsset,
                                        completion: @escaping (VideoCompletion) -> Void ) {
        
        let imageManager = PHCachingImageManager()
        let videoOption = PHVideoRequestOptions()
        videoOption.isNetworkAccessAllowed = true
        videoOption.deliveryMode = .mediumQualityFormat
        imageManager
            .requestAVAsset(forVideo: asset, options: videoOption) { videoAsset , info , videoDict in
                print(">>>>>>>>>>>>>>>>>>>>>>>>S")
                print("videoDict \(videoDict)")
                print("info  \(info)")
                let assetUrl = videoAsset as? AVURLAsset
                print(">>>>>>>>>>>>>>>>>>>>>>>>E")
                completion(assetUrl)
            }
    }
}
