//
//  ViewController.swift
//  gyazos
//
//  Created by Ryo Nitami on 2017/02/15.
//  Copyright © 2017 Ryo Nitami. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

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
    
    func uploadImage(_ selectedImage: UIImage) {
        let endpoint = try! URLRequest(
            url: URL(string: "http://upload.gyazo.com/upload.cgi")!,
            method: .post
        )
        let idData: Data! = "".data(using: .utf8)
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.indeterminate
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(idData, withName: "id")
                multipartFormData.append(UIImagePNGRepresentation(selectedImage)!, withName: "imagedata", fileName: "gyazo", mimeType: "image/png")
            },
            with: endpoint,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseString { response in
                        let gyazoUrl = URL(string: response.result.value!)
                        if (UIApplication.shared.canOpenURL(gyazoUrl!)) {
                            UIPasteboard.general.url = URL(string: response.result.value!)
                            UIApplication.shared.open(gyazoUrl!)
                            hud.hide(animated: true)
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }
    
    // 画像が選択された時に呼ばれる
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        uploadImage(selectedImage)
        self.dismiss(animated: true, completion: nil)
    }
    
    // 画像選択がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}
