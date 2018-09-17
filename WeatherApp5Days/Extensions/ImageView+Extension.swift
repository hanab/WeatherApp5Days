//
//  ImageView+Extension.swift
//  WeatherApp5Days
//
//  Created by Hana  Demas on 9/15/18.
//  Copyright © 2018 ___HANADEMAS___. All rights reserved.
//

import UIKit

//MARK: UIImage extention to load and catch image asynchronously
extension UIImageView {
    func loadImageWithURLString(_ URLString: String, placeHolder: UIImage?) {
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("Image loading error: \(error )")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}
