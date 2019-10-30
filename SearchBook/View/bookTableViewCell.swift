//
//  bookCellTableViewCell.swift
//  SearchBook
//
//  Created by Tatsiana on 10/24/19.
//  Copyright © 2019 Tatsiana. All rights reserved.
//

import UIKit

class bookTableViewCell: UITableViewCell {

    @IBOutlet var imgBook: UIImageView!
    @IBOutlet var titleBook: UILabel!
    @IBOutlet var authorBook: UILabel!
    @IBOutlet var pageCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(with book: Book) {
        var authorText = ""

        titleBook.text = book.title
        for author in book.authors {
            authorText = authorText + author + ";"
        }

        authorBook.text = authorText
        pageCount.text = "p. " + String(book.pageCount)
        imgBook.image = load(currentUrl: book.imageBook)
    }

    func load(currentUrl: String?) -> UIImage {

        var imageBook =  UIImage.init()
        guard let url = URL(string: currentUrl!) else { return UIImage.init() }

        DispatchQueue.global().async {
        if let data = try? Data(contentsOf: url.absoluteURL) {
            if let getImageBook = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageBook = getImageBook
                    self.imgBook.image = getImageBook

                }
            }
            }

    }

        return imageBook

    }

}
