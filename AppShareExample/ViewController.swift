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
        
        self.appShare = AppShare(applinkCode: "1000160", vc:self);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func shareThisAppButtonPressed(_ sender: Any) {
        appShare?.openShareWindow(viewcontroller: self)
    }

}

