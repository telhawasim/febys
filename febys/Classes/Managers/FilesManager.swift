//
//  FilesManager.swift
//  febys
//
//  Created by Faisal Shahzad on 12/02/2022.
//

import Foundation

class FilesManager: NSCoder {
    
    static var shared = FilesManager()
    
    func savePdf(pdfData: Data, fileName: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
        DispatchQueue.main.async {
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let pdfNameFromUrl = "\(fileName).pdf"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            
//            if FileManager.default.fileExists(atPath: actualPath.path) {
//                do {
//                    try FileManager.default.removeItem(atPath: actualPath.path)
//                    print("Removed already existing file")
//                } catch let removeError {
//                    print("Couldn't remove file at path", removeError)
//                }
//            }
            
            do {
                try pdfData.write(to: actualPath, options: .atomic)
                completion(.success((actualPath.absoluteString, fileName)))
            }catch{
                print("Error in Downloading File", error.localizedDescription)
                completion(.failure(error))
                print("Saving Error")
            }
        }
    }
    
    func showSavedPdf(url:String, fileName:String) {
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName).pdf") {
                        // its your file! do what you want with it!
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
    }
    
    // check to avoid saving a file multiple times
    func pdfFileAlreadySaved(url:String, fileName:String)-> Bool {
        var status = false
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("Febys-\(fileName).pdf") {
                        status = true
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
        return status
    }
}
