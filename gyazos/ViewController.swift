//
//  ViewController.swift
//  gyazos
//
//  Created by Ryo Nitami on 2017/02/15.
//  Copyright © 2017 Ryo Nitami. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var selectImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // uploadImage()
    }
    
    @IBAction func selectImage(_ sendar: AnyObject) {
        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = sourceType
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func uploadImage() {
        let url = try! URLRequest(
            url: URL(string: "upload.gyazo.com/upload.cgi")!,
            method: .post
        )
        let idData: Data! = "".data(using: .utf8)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(idData, withName: "id")
            },
            with: url,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
}
