//
//  ViewController.swift
//  Countries
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import Foundation
import AlamofireImage

extension UIImageView {
    func setImage(withPath path: String){
        guard let url = try? path.asURL() else {
            return
        }
        self.af_setImage(withURL: url)
    }
    
    func setImage(withPath path: String, placeholderImage placeholder: UIImage? = nil){
        guard let url = try? path.asURL() else {
            self.image =  placeholder
            return
        }
        self.af_setImage(withURL: url, placeholderImage: placeholder)
    }
}

struct ImageProvider: RequestImages {
    fileprivate let downloadQueue = DispatchQueue(label: "Images cache", qos: DispatchQoS.background)
    //MARK: - Fetch image from URL and Images cache
    func loadImages(from url: URL, completion: @escaping (_ image: UIImage) -> Void) {
        downloadQueue.async(execute: { () -> Void in
            do{
                let data = try Data(contentsOf: url)
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async { completion(image) }
                } else { print("Could not decode image") }
            }catch { print("Could not load URL: \(url): \(error)") }
        })
    }
}
protocol RequestImages {}
extension RequestImages where Self == ImageProvider{
    func requestImage(from url: URL, completion: @escaping (_ image: UIImage) -> Void){
        //calling here another function and returning data completion
        loadImages(from: url, completion: completion)
    }
}

