//
//  ViewController.swift
//  AppShareExample
//
//  Created by Stefan Mayr on 05.03.17.
//  Copyright © 2017 Grizzly New Technologies GmbH. All rights reserved.
//

import UIKit
import AppShare

class ViewController: UIViewController {
    
    var appShare : AppShare?;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Go to https://applink.co an get your applinkCode (for free of course) and enter it below instead
        // of the example one.
        
<<<<<<< HEAD
        self.appShare = AppShare(applinkCode: "1000026");
=======
        self.appShare = AppShare(applinkCode: "1000160", vc:self);
>>>>>>> 8d04b584bcc713f93a072680c18a9d4ba38ed60a
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func shareThisAppButtonPressed(_ sender: Any) {
        appShare?.openShareWindow(viewcontroller: self)
    }
    
    @IBAction func shareOnTwitterButtonPressed(_ sender: Any) {
        appShare?.shareOnTwitter();
    }
    
    @IBAction func shareOnFacebookButtonPressed(_ sender: Any) {
        appShare?.shareOnFacebook();
    }

}

