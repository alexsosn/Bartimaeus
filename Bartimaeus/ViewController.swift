//
//  ViewController.swift
//  Bartimaeus
//
//  Created by Alex on 3/30/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    let imagePickerController = UIImagePickerController()
    let cnn = DeepNeuralNetwork()
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.redColor()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .Camera
        imagePickerController.cameraCaptureMode = .Photo
        imagePickerController.showsCameraControls = false
        
        self.navigationController?.presentViewController(imagePickerController, animated: false, completion: {
            let view = UIView(frame: self.view.frame)
            view.backgroundColor = UIColor.blackColor()
            self.imagePickerController.view.addSubview(view)

            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.takePhoto))
            view.addGestureRecognizer(gestureRecognizer)
            
            self.cnn.loadNetwork()
        })
    }

    func takePhoto() {
        imagePickerController.takePicture()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let _ = info[UIImagePickerControllerEditedImage] {
            print("This should not happen.")
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageThumbnail = generateThumbnailFromImage(image)
            let destPath = pathInDocumentsFolder(temporaryImageFileName(imageThumbnail))
            
            guard let _ = saveImage(imageThumbnail, path: destPath) else {
                print("error saving image")
                return
            }

            let res = cnn.recognizeImageOnPath(destPath as String)
            let utterance = AVSpeechUtterance(string: res)
            utterance.voice = AVSpeechSynthesisVoice(identifier: "en-US")
            
            self.synthesizer.speakUtterance(utterance)

        } else {
            print("Error")
        }
    }
}

