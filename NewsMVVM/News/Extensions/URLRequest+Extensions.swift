//
//  URLRequest+Extensions.swift
//  News
//
//  Created by Luís Felipe Polo on 24/01/21.
//

import RxSwift
import RxCocoa

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
