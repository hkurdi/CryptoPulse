//
//  LocalFileManager.swift
//  CryptoPulse
//
//  Created by HLK on 6/22/24.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    
    private init() { }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        
//        calling create folder if needed to create directory if ! available
        createFolderIfNeeded(folderName: folderName)
        
        
//        getting the path for images
        guard
            let data = image.pngData(),
            let url = getURLforImage(imageName: imageName, folderName: folderName)
        else { return }
//        saving the images to path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error: an error has occured while attempting to save the image.\nError: \(error) Image Name: \(imageName)")
        }
    }
    
    func getImage(imageName: String, folderName: String) -> UIImage? {
        
        guard let url = getURLforImage(imageName: imageName, folderName: folderName),
        FileManager.default.fileExists(atPath: url.path)
        else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error: an error has occured while attempting to create this directory.\nError: \(error) \n Folder Name: \(folderName)")
            }
        }
    }
    
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        else {
            return nil
        }
        return url.appending(path: folderName)
    }
    
    private func getURLforImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else { 
            return nil
        }
        return folderURL.appending(path: imageName + ".png")
    }
}
