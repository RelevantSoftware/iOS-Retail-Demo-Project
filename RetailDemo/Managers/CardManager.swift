//
//  CardManager
//  Dynamic Interface App
//
//  Created by Alexey Romanko on 22.02.17.
//  Copyright © 2017 Alexey Romanko. All rights reserved.
//

import Foundation
import UIKit
class CardManager {

    func saveImageDocumentDirectory(image: UIImage, code: String) -> (String){
        let fileManager = FileManager.default
        let paths = (self.getDirectoryPath() as NSString).appendingPathComponent("\(code).png")
        let imageData = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
        return paths
    }

    func getImage(code: String) -> UIImage? {
        let fileManager = FileManager.default

        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(code).png")
        if fileManager.fileExists(atPath: imagePAth){
            return UIImage(contentsOfFile: imagePAth)
        }else{
            print("No Image")
            return nil
        }
    }

    func deleteImage(code: String) {
        let fileManager = FileManager.default

        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("\(code).png")
        if fileManager.fileExists(atPath: imagePAth){
            do  {
            	try fileManager.removeItem(atPath: imagePAth)
            }
            catch let err as NSError {
                print (err.localizedDescription)
            }
        }
    }

    func getDirectoryPath() -> String {

        let sharedContainerURL: NSURL? = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: kGroupName) as NSURL?
        if let sharedContainerURLPath = sharedContainerURL?.path {
            return sharedContainerURLPath

        }
    let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory

    }


}
