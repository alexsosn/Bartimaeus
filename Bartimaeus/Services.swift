//
//  Services.swift
//  Bartimaeus
//
//  Created by Alex on 3/30/16.
//  Copyright © 2016 Alex. All rights reserved.
//

import Foundation
import UIKit

func generateThumbnailFromImage(image: UIImage) -> UIImage {
    var thumbnail: UIImage
    var destinationSize = image.size
    
    if image.size.width > 800 || image.size.height > 600 {
        let scaleFactor = max(image.size.width/800, image.size.height/600)
        
        destinationSize = CGSizeMake(image.size.width/scaleFactor,
                                     image.size.height/scaleFactor)
    }
    
    UIGraphicsBeginImageContext(destinationSize)
    image.drawInRect(CGRectMake(0, 0, destinationSize.width, destinationSize.height))
    thumbnail = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return thumbnail
}

func pathInDocumentsFolder(fileName: NSString) -> NSString {
    let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let destPath = "\(documentsDirectory)/\(fileName)"
    return destPath
}

func temporaryImageFileName(image: UIImage) -> NSString {
    return "\(image.hash).jpg"
}

func saveImage(image: UIImage, path: NSString) -> UIImage? {
    guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
        print("no data")
        return nil
    }
    
    guard imageData.writeToFile(path as String, atomically: true) else {
        print("couldn't write image data to file \(path) because of error")
        return nil
    }
    
    return UIImage(contentsOfFile:path as String)
}
