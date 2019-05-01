//
//  LoginViewController.swift
//  FamilyArchives
//
//  Created by Zoe Henry on 4/25/19.
//  Copyright © 2019 Zoe Henry. All rights reserved.
//

import UIKit
import FirebaseUI

class LoginViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginTapped(_ sender: UIButton) {
        //Get default auth UI object
        
        let authUI = FUIAuth.defaultAuthUI()
        
        guard authUI != nil else {
            // log the error
            return
        }
        
        // set self as delegate
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        
        // get reference to UI view controller
        let authViewController = authUI!.authViewController()
        
        // show
        present(authViewController, animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LoginViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        //check for errors
        if error != nil {
            // log the error
            return
        }
        
        performSegue(withIdentifier: "GoHome", sender: self)
    }
}
