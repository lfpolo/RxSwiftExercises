//
//  URLRequest+Extensions.swift
//  Weather
//
//  Created by Luís Felipe Polo on 25/01/21.
//

import Foundation
import RxCocoa
import RxSwift

extension URLRequest {
    static func load<T: Decodable>(url : URL) -> Observable<T> {
        return Observable.just(url)
            .flatMap { url -> Observable<(response: HTTPURLResponse, data: Data)> in
                let request = URLRequest(url: url)
                return URLSession.shared.rx.response(request: request)
            }.map { response, data -> T in
                if 200..<300 ~= response.statusCode {
                    return try JSONDecoder().decode(T.self, from: data)
                } else {
                    throw RxCocoaURLError.httpRequestFailed(response: response, data: data)
                }
            }.asObservable()
    }
}
