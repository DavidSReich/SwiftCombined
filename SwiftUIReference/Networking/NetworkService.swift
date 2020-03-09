//
//  NetworkService.swift
//  SwiftUIReference
//
//  Created by David S Reich on 6/3/20.
//  Copyright © 2020 Stellar Software Pty Ltd. All rights reserved.
//

import Foundation
import RxSwift

class NetworkService {
    private let disposeBag = DisposeBag()

    func getData(urlString: String,
                 useRxSwift: Bool,
                 mimeType: String,
                 networkingType: UserSettings.NetworkingType,
                 not200Handler: HTTPURLResponseNot200? = nil,
                 completion: @escaping (DataResult) -> Void) {

        if useRxSwift {
            getDataWithRxSwift(urlString: urlString,
                               mimeType: mimeType,
                               networkingType: networkingType,
                               not200Handler: not200Handler,
                               completion: completion)
        } else {
            getDataWithoutRxSwift(urlString: urlString,
                                  mimeType: mimeType,
                                  networkingType: networkingType,
                                  not200Handler: not200Handler,
                                  completion: completion)
        }
    }

    private func getDataWithoutRxSwift(urlString: String,
                                       mimeType: String,
                                       networkingType: UserSettings.NetworkingType,
                                       not200Handler: HTTPURLResponseNot200? = nil,
                                       completion: @escaping (DataResult) -> Void) {
        let referenceError = SessionService.getData(urlString: urlString,
                                                        mimeType: mimeType,
                                                        networkingType: networkingType,
                                                        not200Handler: not200Handler,
                                                        completion: completion)

        if let referenceError = referenceError {
            completion(.failure(ReferenceError.noFetchJSON(referenceError: referenceError)))
        }
    }

    private func getDataWithRxSwift(urlString: String,
                                    mimeType: String,
                                    networkingType: UserSettings.NetworkingType,
                                    not200Handler: HTTPURLResponseNot200? = nil,
                                    completion: @escaping (DataResult) -> Void) {
        guard let jsonObservable = SessionService.getDataObservable(urlString: urlString,
                                                                        mimeType: mimeType,
                                                                        networkingType: networkingType,
                                                                        not200Handler: not200Handler) else {
                                                                            completion(.failure(.badURL))
                                                                            return
        }

        jsonObservable.subscribe(onNext: { result in
            completion(result)
        },
                                 onError: { error in
                                    print("error: \(error)")
                                    completion(.failure(error as? ReferenceError ?? .dataTask(error: error)))
        }).disposed(by: disposeBag)
    }
}
