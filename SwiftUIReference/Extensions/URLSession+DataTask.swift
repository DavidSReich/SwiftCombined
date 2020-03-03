//
//  URLSession+DataTask.swift
//  GIPHYTags
//
//  Created by David S Reich on 9/12/19.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation

extension URLSession {
    class func urlSessionDataTask(urlString: String,
                                  mimeType: String,
                                  not200Handler: HTTPURLResponseNot200? = nil,
                                  completion: @escaping (DataResult) -> Void) -> URLSessionDataTask? {

        guard let url = URL(string: urlString) else {
            print("Cannot make URL")
            completion(.failure(.badURL))
            return nil
        }

        //using an URLRequest object is not necessary in this usage
        let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
            HTTPURLResponse.validateData(data: data,
                                         response: response,
                                         error: error,
                                         mimeType: mimeType,
                                         not200Handler: not200Handler,
                                         completion: completion)
        }

        dataTask.resume()
        return dataTask
    }
}
