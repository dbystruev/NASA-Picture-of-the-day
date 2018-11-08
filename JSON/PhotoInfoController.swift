//
//  PhotoInfoController.swift
//  JSON
//
//  Created by Denis Bystruev on 08/11/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import Foundation

class PhotoInfoController {
    
    func fetchPhotoInfo(completion: @escaping (PhotoInfo?) -> Void) {
        let baseURL = URL(string: "https://api.nasa.gov/planetary/apod")!
        
        let query = [
            "api_key": "DEMO_KEY"
        ]
        
        let url = baseURL.withQueries(query)!
        
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            let jsonDecoder = JSONDecoder()
            
            if let data = data, let photoInfo = try? jsonDecoder.decode(PhotoInfo.self, from: data) {
                completion(photoInfo)
            } else {
                print(#function, "Can't read data")
                completion(nil)
            }
        }
        task.resume()
    }
}
