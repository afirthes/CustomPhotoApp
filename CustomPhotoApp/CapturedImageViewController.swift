//
//  CapturedImageViewController.swift
//  CustomPhotoApp
//
//  Created by Afir Thes on 10.09.2021.
//

import UIKit

class CapturedImageViewController: UIViewController {

    @IBOutlet weak var capturedImageView: UIImageView!
    
    var capturedImage: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = capturedImage {
            capturedImageView.image = UIImage(data: image)
        }

    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
