//
//  ViewController.swift
//  SearchBook
//
//  Created by Tatsiana on 10/24/19.
//  Copyright © 2019 Tatsiana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var authorTF: UITextField!
    @IBOutlet var foundLabel: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet var emptyLabel: UILabel!
    @IBOutlet var searchBtn: UIButton!

    private var googleBooks = [Book]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: Action
    @IBAction func searchBtn(_ sender: UIButton) {
       //flowers+inauthor:keyes
        let titleText = getTextInTextField(textField: titleTF, par: "intitle:")
        let authorText = getTextInTextField(textField: authorTF, par: "inauthor:")

        let currentUrl = URL(string: "https://www.googleapis.com/books/v1/volumes?q="+((titleText + "+") ?? "") +  authorText)

        guard let url = currentUrl else {return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in

            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do {

                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])

                if let rootDictionary = jsonResponse as? [String: Any],
                     let items = rootDictionary["items"] as? [[String: Any]] {

                    self.googleBooks.removeAll()

                    for item in items {
                        if let book = Book(json: item) {
                            self.googleBooks.append(book)
                        }
                    }
                    DispatchQueue.main.async(execute: {
                        self.configureUI()
                    })

                } else {
                    DispatchQueue.main.async(execute: {
                        self.googleBooks.removeAll()
                        self.configureUI()
                        self.emptyLabel.text = "Sorry, I can't find anything 👀"
                    })
                }

            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()

        }

    // MARK: functions

    private func configureUI() {
        table.isHidden = googleBooks.isEmpty
        emptyLabel.isHidden = !googleBooks.isEmpty
        foundLabel.text = "Found books: " + String(googleBooks.count)
        searchBtn.layer.cornerRadius = 5
        table.reloadData()
    }

    private func getTextInTextField(textField: UITextField, par: String) -> String {
        var text = ""
        if let textInTextField = textField.text {
            if  !textInTextField.isEmpty {
                text = par + textInTextField.replacingOccurrences(of: " ", with: "+")
            }
        }
        return text.trimmingCharacters(in: .whitespaces)
    }

}

// MARK: extension
extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! bookTableViewCell
        cell.setup(with: googleBooks[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googleBooks.count
    }

}
