//
//  Book.swift
//  SearchBook
//
//  Created by Tatsiana on 10/24/19.
//  Copyright © 2019 Tatsiana. All rights reserved.
//

import Foundation

class Book {

    let title: String
    let authors: [String]
    let pageCount: Int64
    let imageBook: String

    init?(json: [String: Any]) {
        var titleText = ""
        var authorsArray = [String]()
        var imagePath = ""
        var pageNum: Int64 = 0

        for dic in json {
            let key = dic.key
            if key == "volumeInfo" {
                if let value = dic.value as? NSDictionary {
                    titleText = value.value(forKeyPath: "title") as! String

                    if let authorArray = value.value(forKeyPath: "authors") as? Array<String> {
                        for td in authorArray {
                            authorsArray.append(td)
                        }
                    }

                    if let imageDictionary = value.value(forKeyPath: "imageLinks") as? NSDictionary {
                        if let imageLink = imageDictionary.value(forKeyPath: "smallThumbnail") as? String {
                            imagePath = imageLink

                        }
                    }

                    if let pages = value.value(forKeyPath: "pageCount") as? Int64 {
                        pageNum = pages
                    }

                }

             }
            }

        self.title = titleText
        self.authors = authorsArray
        self.imageBook = imagePath
        self.pageCount = pageNum

    }
}
