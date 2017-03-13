// AppShareViewController.swift
//
// Copyright (c) 2017 GrizzlyNT (https://github.com/grizzly/AppShare)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class AppShareViewController : UIViewController {
    
    @IBOutlet weak var shareOnFacebookButton: UIButton!
    @IBOutlet weak var shareOnTwitterButton: UIButton!
    @IBOutlet weak var sendByWhatsAppButton: UIButton!
    @IBOutlet weak var sendByEmailButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var appShare : AppShare?;
    var applinkCode : String?;
    
    override func viewDidLoad() {
        if let applinkCode = self.applinkCode {
            self.appShare = AppShare(applinkCode: applinkCode, vc: self);
        }
    }
    
    @IBAction func shareOnFacebookButtonPressed(_ sender: Any) {
        appShare?.shareApp(on: .facebook);
    }
    
    @IBAction func shareOnTwitterButtonPressed(_ sender: Any) {
        appShare?.shareApp(on: .twitter);
    }
    
    @IBAction func sendByWhatsAppButtonPressed(_ sender: Any) {
        appShare?.shareApp(on: .whatsapp);
    }
    
    @IBAction func sendByEmailButtonPressed(_ sender: Any) {
        appShare?.shareApp(on: .email);
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    
}


