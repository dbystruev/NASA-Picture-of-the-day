//
//  ViewController.swift
//  JSON
//
//  Created by Denis Bystruev on 08/11/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var copyrightLabel: UILabel!
    
    let photoInfoController = PhotoInfoController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionLabel.text = ""
        copyrightLabel.text = ""
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        photoInfoController.fetchPhotoInfo { (fetchedInfo) in
            print(#function, fetchedInfo ?? "nil")
            
            if let fetchedInfo = fetchedInfo {
                updateUI(with: fetchedInfo)
            }
        }
        
        func updateUI(with photoInfo: PhotoInfo) {
            let task = URLSession.shared.dataTask(with: photoInfo.url) { data, _, _ in
                guard let data = data else { return }
                
//                UIApplication.shared.open(URL(string: "https://apod.nasa.gov/apod/image/1811/Ma2018_tezelN1024.jpg")!)
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        
                        self.navigationItem.title = photoInfo.title
                        self.imageView.image = image
                        self.descriptionLabel.text = photoInfo.description
                        
                        if let copyright = photoInfo.copyright {
                            self.copyrightLabel.text = "Copyright \(copyright)"
                        } else {
                            self.copyrightLabel.isHidden = true
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
}

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.map { URLQueryItem(name: $0.key, value: $0.value) }
        return components?.url
    }
    
    func withHTTPS() -> URL? {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.scheme = "https"
        return components?.url
    }
}

