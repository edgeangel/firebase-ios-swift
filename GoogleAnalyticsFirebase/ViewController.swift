//
//  ViewController.swift
//  GoogleAnalyticsFirebase
//
//  Copyright (c) 2020 EdgeAngel
//  Licensed under GNU General Public License, Version 3.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  https://www.gnu.org/licenses/gpl-3.0.html
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import UIKit
import WebKit
import Firebase
import FirebaseInstanceID

class ViewController: UIViewController, WKScriptMessageHandler  {
    
    private var webView: WKWebView!
    private var projectURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let projectURLString = "https://your-firebase-webview.com"
        self.projectURL = URL(string: projectURLString)!
        
        self.webView = WKWebView(frame: self.view.frame)
        
        self.webView.configuration.userContentController.add(self, name: "firebase")
        
        self.view.addSubview(self.webView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let request = URLRequest(url: self.projectURL)
        self.webView.load(request)
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      guard let body = message.body as? [String: Any] else { return }
      guard let command = body["command"] as? String else { return }
      guard let name = body["name"] as? String else { return }

      if command == "setUserProperty" {
        guard let value = body["value"] as? String else { return }
        Analytics.setUserProperty(value, forName: name)
      } else if command == "logEvent" {
        guard var params = body["parameters"] as? [String: NSObject] else { return }
        
        // [START override params with app_instance_id]
        InstanceID.instanceID().instanceID { (result, error) in
            let app_instance_id = result!.instanceID as NSObject
            let app_instance_id_array = ["app_instance_id": app_instance_id] as [String: NSObject]
            params.merge(app_instance_id_array){(current, _) in current}
            Analytics.logEvent(name, parameters: params)
        }
        // [END override params with app_instance_id]
      }
    }

}
