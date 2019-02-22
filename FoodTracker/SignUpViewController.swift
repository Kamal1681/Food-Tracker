//
//  SignUpViewController.swift
//  FoodTracker
//
//  Created by Kamal Maged on 2019-02-18.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var passWordText: UITextField!
    
   func storeInUserDefaults() {
        userNameText.text = UserDefaults.standard.string(forKey: "username")
        passWordText.text = UserDefaults.standard.string(forKey: "password")
   }
    func parse(url: URL) {
        let postData = [
            "username": userNameText.text ?? "",
            "password": passWordText.text ?? ""
        ]
        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: postData, options: []) else {
            print("could not serialize json")
            return
        }
        
        
        let request = NSMutableURLRequest(url: url)
        request.httpBody = postJSON
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard let data = data else {
                print("no data returned from server \(String(describing: error?.localizedDescription))")
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String,Any> else {
                print("data returned is not json, or not valid")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("no response returned from server \(String(describing: error))")
                return
            }
            
            guard response.statusCode == 200 else {
                // handle error
                print("an error occurred \(String(describing: json?["error"]))")
                return
            }
            let token = json!["token"]
            print(token)
            
            
        }
        // do something with the json object
        task.resume()
       storeInUserDefaults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view
    
    }

    @IBAction func signUp(_ sender: Any) {
        parse(url: URL(string: "https://cloud-tracker.herokuapp.com/signup")!)
    }
    
    @IBAction func logIn(_ sender: Any) {
        parse(url: URL(string: "https://cloud-tracker.herokuapp.com/login")!)
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
