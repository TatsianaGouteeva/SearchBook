//
//  RegistrationViewController.swift
//  SearchBook
//
//  Created by Tatsiana on 10/28/19.
//  Copyright © 2019 Tatsiana. All rights reserved.
//

import UIKit
import OAuthSwift

class RegistrationViewController: UIViewController {

    // MARK: IBOutlet
    @IBOutlet var googleBtn: UIButton!
    @IBOutlet var withoutAuthBtn: UIButton!
    @IBOutlet var viewGoogle: UIView!
    @IBOutlet var viewWithoutAuth: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: functions
    func configureUI() {
        withoutAuthBtn.layer.cornerRadius = 5
        withoutAuthBtn.layer.borderColor = UIColor.gray.cgColor
        withoutAuthBtn.layer.borderWidth = 1

        viewGoogle.layer.borderColor = UIColor.gray.cgColor
        viewGoogle.layer.borderWidth = 1
        viewGoogle.layer.cornerRadius = 5
    }

    // MARK: enter into google account
    @IBAction func register(_ sender: UIButton) {

        let oauthswift = OAuth2Swift(
            consumerKey: "622386102456-cpt0aac3rcgmnih30kjakrfk1mu4qecu.apps.googleusercontent.com",
            consumerSecret: "",
            authorizeUrl: "https://accounts.google.com/o/oauth2/auth",
            accessTokenUrl: "https://accounts.google.com/o/oauth2/token",
            responseType: "code"
        )

        oauthswift.allowMissingStateCheck = true
        oauthswift.authorizeURLHandler = SafariURLHandler(viewController: self, oauthSwift: oauthswift)
        //guard let rwURL = URL(string: "Test.SearchBook:/oauth2Callback") else { return }
        //guard let rwURL = URL(string: "com.example.SearchBook:/oauth2Callback") else { return }
        guard let rwURL = URL(string: "com.searchBook:/oauth-callback") else { return }

        oauthswift.authorize(withCallbackURL: rwURL, scope: "https://mail.google.com/", state: "", success: {
            (_, _, _) in

            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "viewController") as! ViewController
            self.present(viewController, animated: true)

            print("Success")
        }, failure: { (error) in
            print(error.localizedDescription)
        })

      }

    // MARK: enter without registration
    @IBAction func enterWithoutRegistration(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "viewController") as! ViewController
        present(viewController, animated: true)

    }

}
