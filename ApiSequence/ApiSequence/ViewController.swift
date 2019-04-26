//
//  ViewController.swift
//  ApiSequence
//
//  Created by Raghavareddy M on 27/02/19.
//  Copyright © 2019 Raghavareddy M. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    fileprivate var downloadTask1:  DownloadTask?
    fileprivate var downloadTask2:  DownloadTask?

    var task = ["https://reqres.in/api/users?page=2","https://reqres.in/api/users/2","https://reqres.in/api/unknown/2"]
    
    @IBOutlet weak var progressTab: UIProgressView!
    
    @IBOutlet weak var progressTab2: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.progressTab.progress = 0.0
        // Do any additional setup after loading the view, typically from a nib.
    }
   

    @IBAction func Start(_ sender: UIButton) {
        for obj in task
        {
            let url = URL(string: obj)!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
            downloadTask1 = DownloadService.shared.download(request: request)
            downloadTask1?.completionHandler = { [weak self] in
                switch $0 {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let data):
                    print("Number of bytes: \(data.count)")
                    var jsonDictionary : NSDictionary
                    do {
                        jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                        print(jsonDictionary)
                    } catch {
                        print(error)
                    }

                }
                self?.downloadTask1 = nil
            }
            downloadTask1?.progressHandler = { [weak self] in
                print("Task1: \($0)")
                self?.progressTab.progress = Float($0)
            }

            downloadTask1?.resume()
        }
    }
    
    @IBAction func PostApicall(_ sender: UIButton) {
        let url = "https://reqres.in/api/users"
        let dict = ["name": "morpheus",
                    "job": "leader"]
        downloadTask2 = DownloadService.shared.requestCall(url: url, method: "POST", param: dict, accessTokenstr: "")
        downloadTask2?.completionHandler = { [weak self] in
            switch $0 {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                print("Number of bytes: \(data.count)")
                var jsonDictionary : NSDictionary
                do {
                    jsonDictionary = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as! NSDictionary
                    print(jsonDictionary)
                } catch {
                    print(error)
                }
                
            }
            self?.downloadTask2 = nil
        }
        downloadTask2?.progressHandler = { [weak self] in
            print("Task1: \($0)")
            self?.progressTab2.progress = Float($0)
        }
        
        downloadTask2?.resume()
    }
    
    
    
  
    
}

