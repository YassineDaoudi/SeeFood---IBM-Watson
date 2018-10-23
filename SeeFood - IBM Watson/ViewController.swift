//
//  ViewController.swift
//  SeeFood - IBM Watson
//
//  Created by Yassine Daoudi on 16/10/2018.
//  Copyright © 2018 Yassine Daoudi. All rights reserved.
//

import UIKit
import VisualRecognitionV3
import SVProgressHUD
import Social


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topBarImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    //MARK: - ImagePickerInstance
    let imagePicker = UIImagePickerController()
    
    //MARK: - Properties
    let apiKey = "hxf2U8jPiJvXwiQqIq_0t7E4zsSYWRhMbQdE9epYvnF_"
    let version = "2018-10-16"
    var classificationResults : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isHidden = true
        imagePicker.delegate = self
       
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        cameraButton.isEnabled = false
        SVProgressHUD.show()
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            
            let visualRecognition = VisualRecognition(version: version, apiKey: apiKey)
            
            visualRecognition.classify(image: image, threshold: 0.0, owners: nil, classifierIDs: nil, acceptLanguage: "en", failure: nil) { (classifiedImages) in
                let classes = classifiedImages.images.first!.classifiers.first!.classes
                
                
                self.classificationResults.removeAll()
                
                for index in 0..<classes.count {
                    self.classificationResults.append(classes[index].className)
                }
                DispatchQueue.main.async {
                    self.cameraButton.isEnabled = true
                    SVProgressHUD.dismiss()
                    self.shareButton.isHidden = false
                }
                
                if self.classificationResults.contains("hotdog") {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Hotdog"
                        self.navigationController?.navigationBar.barTintColor = UIColor.green
                        self.navigationController?.navigationBar.isTranslucent = false
                        self.topBarImageView.image = UIImage(named: "hotdog")
                    }
                } else {
                    DispatchQueue.main.async {
                        self.navigationItem.title = "Not Hotdog"
                        self.navigationController?.navigationBar.barTintColor = UIColor.red
                        self.navigationController?.navigationBar.isTranslucent = false
                        self.topBarImageView.image = UIImage(named: "not-hotdog")
                    }
                    
                }
            }
            
            
        } else {
            print("There was an error picking the image")
        }
        
    }
    
    //MARK: - IBActions
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func shareTapped(_ sender: UIButton) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter)
        {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc?.setInitialText("My food is a hotdog ^_^")
            //vc?.add()
            present(vc!,animated: true,completion: nil)
        } else {
            self.navigationItem.title = "Please Login to twiter"
        }
        
    }
    
}

