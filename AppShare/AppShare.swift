// AppRating.swift
//
// Copyright (c) 2017 GrizzlyNT (https://github.com/grizzly/AppRating)
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

import Foundation
import Social

open class AppShare {
    
    var applinkCode : String?;
    
    /**
     * MARK: -
     * MARK: Initialization
     * set the applink.co Code, as received on
     * https://applink.co
     *
     * - Parameter applinkCode: your applink.co code
     */
    public init(applinkCode: String, vc:UIViewController) {
        self.applinkCode(applinkCode);
        self.manager.vc = vc;
    }
    
    /**
     * Singleton instance of the underlaying share manager.
     */
    let manager : AppShareManager = {
        struct Singleton {
            static let instance: AppShareManager = AppShareManager();
        }
        return Singleton.instance;
    }()
    
    
    /**
     * Share current app.
     */
    open func shareApp(on: AppShareService) {
        self.manager.shareAppOn(on: on, text: "")
    }
    
    /**
     * set the applink.co Code, as received on
     * https://applink.co
     *
     * - Parameter applinkCode: your applink.co code
     */
    open func applinkCode(_ applinkCode: String) {
        self.applinkCode = applinkCode;
        self.manager.applinkCode = applinkCode
    }
    
}

open class AppShareManager : NSObject {
    
    var applinkCode : String?;
    var vc : UIViewController?;

    func shareApp() {
        if let url = _getShareURL() {
            let objectsToShare = [url]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            if let vc = self.vc {
                vc.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    func shareAppOn(on: AppShareService, text:String) {
        if let url = _getShareURL() {
            let shareText = text + " " + url.absoluteString;
            if let textEncoded = shareText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                switch on {
                case .whatsapp:
                    guard let whatsAppUrl = NSURL(string: "whatsapp://send?text=" + textEncoded) else { return }
                    self._openSocialService(url: whatsAppUrl as URL);
                    break;
                case .facebook:
                    // Facebook does not allow prefilled text, so only url without text can be shared.
                    self._shareOnFacebook(url: url);
                    break;
                case .twitter:
                    self._shareOnTwitter(text: text, url: url);
                    break;
                default:
                    return;
                }
            }
        }
    }
    
    // - Privates
    
    private func _shareOnFacebook(url: URL) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
            let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            fbSheet?.add(url);
            if let vc = self.vc {
                vc.present(fbSheet!, animated: true, completion: nil);
            }
        } else {
            self._showAlertView(title: "Facebook", message: "Please login to your Facebook account in Settings");
        }
    }
    
    private func _shareOnTwitter(text: String, url: URL) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let twSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twSheet?.setInitialText(text)
            twSheet?.add(url);
            if let vc = self.vc {
                vc.present(twSheet!, animated: true, completion: nil);
            }
        } else {
            self._showAlertView(title: "Twitter", message: "Please login to your Twitter account in Settings");
        }
    }
    
    private func _openSocialService(url:URL) {
        if UIApplication.shared.canOpenURL(url as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            self._showAlertView(title: "Error", message: "App not found, please download it on the App Store");
        }
    }
    
    private func _showAlertView(title:String, message:String) {
        if let vc = self.vc {
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            let defaultButton = UIAlertAction(title: "OK",
                                              style: .default) {(_) in
                                                
            }
            alert.addAction(defaultButton)
            vc.present(alert, animated: true, completion: nil);
        }
    }
    
    private func _getShareURL() -> URL? {
        if let applinkCode = self.applinkCode {
            let urlString = "https://applink.co/" + applinkCode
            return URL(string: urlString);
        }
        return nil;
    }
    
}

public enum AppShareService: Int {
    case all, facebook, twitter, whatsapp
}
