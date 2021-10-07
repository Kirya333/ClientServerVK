//
//  GalleryViewController.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 11.07.2021.
//

import UIKit
import RealmSwift

class GalleryViewController: UIViewController {
    
   
    @IBOutlet weak var galleryView: GalleryHorisontalView!
    
    var galleryPhotos: Results<PhotoModel>?
    var selectedImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryView.setImages(images: getImages(), showIndexPhoto: selectedImageIndex)
    }
    
    func getImages() -> [UIImage] {
        var images = [UIImage]()
        guard let galleryPhotos = galleryPhotos else { return images }
        
        for photo in galleryPhotos {
            if let url = URL(string: photo.urlByGallery),
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                images.append(image)
            }
        }
        
        return images
    }
}
