//
//  GalleryViewController.swift
//  ClientServer
//
//  Created by Кирилл Тарасов on 11.07.2021.
//

import UIKit

class GalleryViewController: UIViewController {
    
   
    @IBOutlet weak var galleryView: GalleryHorisontalView!
    
    var galleryPhotos = [Photo]()
    var selectedImageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryView.setImages(images: getImages(), showIndexPhoto: selectedImageIndex)
    }
    
    func getImages() -> [UIImage] {
        var images = [UIImage]()
        
        for photo in galleryPhotos {
            for photoSize in photo.sizes {
                if photoSize.type == "x" {
                    if let url = URL(string: photoSize.url),
                       let data = try? Data(contentsOf: url),
                       let image = UIImage(data: data) {
                        images.append(image)
                    }
                }
            }
        }
        
        return images
    }

}
