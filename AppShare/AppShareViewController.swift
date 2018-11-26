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

    var applinkCode : String?;
    
    var colorTint : UIColor = .black;
    var tintAlpha : CGFloat = 0.5;
    var blurRadius : CGFloat = 5;
    var fontColor : UIColor = .white;
    
    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    private var visualEffectView : UIVisualEffectView?
    private var appShare : AppShare?;
    
    override func viewDidLoad() {
        if let applinkCode = self.applinkCode {
            self.appShare = AppShare(applinkCode: applinkCode, vc: self);
        }
        self.setLayout();
    }
    
    @IBAction func shareOnFacebookButtonPressed(_ sender: Any) {
        appShare?.shareApp(on: .facebook, sourceView: self.shareOnFacebookButton);
    }
    
    @IBAction func shareOnTwitterButtonPressed(_ sender: Any) {
        appShare?.shareApp(on: .twitter, sourceView: self.shareOnTwitterButton);
    }
    
    @IBAction func sendByWhatsAppButtonPressed(_ sender: Any) {
        appShare?.shareApp(on: .whatsapp, sourceView: self.sendByWhatsAppButton);
    }
    
    @IBAction func sendByEmailButtonPressed(_ sender: Any) {
        appShare?.shareApp(on: .email, sourceView: self.sendByEmailButton);
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil);
    }
    
    /// Sets the value for the key on the blurEffect.
    private func _setEffectViewValue(_ value: Any?, forKey key: String) {
        blurEffect.setValue(value, forKeyPath: key)
        self.visualEffectView?.effect = blurEffect
    }
    
    private func setLayout() {
        if (self.visualEffectView == nil) {
            self.view.backgroundColor = UIColor.clear;
            self.view.isOpaque = false;
            self.visualEffectView = UIVisualEffectView(frame: self.view.bounds)
            if let visualEffectView = self.visualEffectView {
                visualEffectView.backgroundColor = UIColor.clear;
                visualEffectView.isOpaque = false;
                visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
                self._setEffectViewValue(self.colorTint, forKey: "colorTint");
                self._setEffectViewValue(self.tintAlpha, forKey: "colorTintAlpha");
                self._setEffectViewValue(self.blurRadius, forKey: "blurRadius");
                self.view.addSubview(visualEffectView)
                self.view.sendSubviewToBack(visualEffectView);
            }
        }
        self.setSocialButtonLayout(button: self.shareOnFacebookButton, bold: true);
        self.setSocialButtonLayout(button: self.shareOnTwitterButton, bold: true);
        self.setSocialButtonLayout(button: self.sendByWhatsAppButton, bold: true);
        self.setSocialButtonLayout(button: self.sendByEmailButton, bold: true);
        self.setSocialButtonLayout(button: self.closeButton, bold: false);
    }
    
    private func setSocialButtonLayout(button : UIButton, bold:Bool) {
        button.setTitleColor(self.fontColor, for: .normal);
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = self.fontColor.cgColor
        button.titleEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8);
        let frameworkBundle = self.appShare?.manager.bundle()
        if let currentTitle = button.title(for: .normal) {
            let title = frameworkBundle?.localizedString(forKey: currentTitle, value:"", table: "AppShareLocalizable");
            button.setTitle(title, for: .normal);
        }
        if (bold) {
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
    }

}


