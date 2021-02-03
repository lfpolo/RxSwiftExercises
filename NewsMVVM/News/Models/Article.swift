//
//  Article.swift
//  News
//
//  Created by Luís Felipe Polo on 24/01/21.
//

import Foundation

struct ArticleResponse : Decodable {
    let articles : [Article]
}

extension ArticleResponse {
    static var url : URL {
        return URL(string: "https://newsapi.org/v2/top-headlines?country=br&apiKey=77bbf8425e694b41bcf4a23228659a65")!
    }
    
    static var empty : ArticleResponse {
        return ArticleResponse(articles: [])
    }
}

struct Article : Decodable {
    let title : String
    let description : String?
}
