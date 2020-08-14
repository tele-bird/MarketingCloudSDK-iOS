//
//  ViewController.swift
//  LearningApp
//
//  Created by Brian Criscuolo on 6/4/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import MarketingCloudSDK
import SafariServices
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    var locationUpdateObserver: NSObjectProtocol?

    deinit {
        NotificationCenter.default.removeObserver(locationUpdateObserver as Any)
        locationUpdateObserver = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "MobilePush SDK LearningApp"
        
        locationLabel.preferredMaxLayoutWidth = self.view.bounds.size.width;
        locationLabel.text = "Location not yet updated";
        
        if locationUpdateObserver == nil {
            locationUpdateObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name.SFMCLocationDidReceiveLocationUpdate, object: nil, queue: OperationQueue.main) {(_ note: Notification) -> Void in
                let location = note.userInfo?["lastLocation"] as! CLLocation
                self.updateLocationLabel(location: location.description)
            }
        }
    }
    
    func updateLocationLabel(location: String) {
        if MarketingCloudSDK.sharedInstance().sfmc_watchingLocation() {
            guard let _ = MarketingCloudSDK.sharedInstance().sfmc_lastKnownLocation() else { locationLabel.text = "Not watching location"
                return
                }
            locationLabel.text = String(format: "Watching location - current location:\n %@", location)
        }
        else {
            locationLabel.text = "Not watching location"
        }
    }
    
    @IBAction func showDocs(_ sender: Any) {
        if let url = URL.init(string: "https://salesforce-marketingcloud.github.io/MarketingCloudSDK-iOS/") {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: false)
            present(vc, animated: true)
        }
    }

    @IBAction func setRegistrationValues(_ sender: Any) {

        // anonymous user:
        let uuid = UUID.init()
        let anonymousKey = uuid.uuidString
        var hasLoggedIn = false
        var isLoggedIn = false;
        MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("HasLoggedIn", value: hasLoggedIn.description)
        MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("IsLoggedIn", value: isLoggedIn.description)
        MarketingCloudSDK.sharedInstance().sfmc_setContactKey(anonymousKey)
        print("Created anonymous Contact with Key: " + anonymousKey + " and IsLoggedIn: " + isLoggedIn.description)

        // logged in user:
        let emailAddress = "phil123456789@reg.com"
        hasLoggedIn = true
        isLoggedIn = true
        MarketingCloudSDK.sharedInstance().sfmc_setContactKey(emailAddress)
        MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("HasLoggedIn", value: hasLoggedIn.description)
        MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("IsLoggedIn", value: isLoggedIn.description)
        print("Marked Contact with Key: " + emailAddress + " as HasLoggedIn: " + hasLoggedIn.description + " and IsLoggedIn: " + isLoggedIn.description)

        // logged out user:
        isLoggedIn = false
        MarketingCloudSDK.sharedInstance().sfmc_setContactKey(emailAddress)
        MarketingCloudSDK.sharedInstance().sfmc_setAttributeNamed("IsLoggedIn", value: isLoggedIn.description)
        print("Marked Contact with Key: " + emailAddress + " as IsLoggedIn:" + isLoggedIn.description )
    }
}

