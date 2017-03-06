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
    public init(applinkCode: String) {
        self.applinkCode(applinkCode);
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
    open func shareApp() {
        self.manager.shareApp();
    }

    /**
     * Share current app on Facebook.
     */
    open func shareOnFacebook() {
        self.manager.shareOnFacebook();
    }
    
    /**
     * Share current app on Twitter.
     */
    open func shareOnTwitter() {
        self.manager.shareOnTwitter();
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

    func shareApp() {
        if let url = getShareURL() {
            let objectsToShare = [url]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            if let vc = self.topMostViewController(self.getRootViewController()){
                vc.present(activityVC, animated: true, completion: nil)
            }
        }
    }
    
    open func shareOnTwitter() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            twitterSheet.add(self.getShareURL())
            if let vc = self.topMostViewController(self.getRootViewController()){
                vc.present(twitterSheet, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            if let vc = self.topMostViewController(self.getRootViewController()){
                vc.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    open func shareOnFacebook() {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            facebookSheet.add(self.getShareURL())
            if let vc = self.topMostViewController(self.getRootViewController()){
                vc.present(facebookSheet, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                if let vc = self.topMostViewController(self.getRootViewController()){
                    vc.present(alert, animated: true, completion: nil)
                }
        }
    }
    
    private func getShareURL() -> URL? {
        if let applinkCode = self.applinkCode {
            let urlString = "https://applink.co/" + applinkCode
            return URL(string: urlString);
        }
        return nil;
    }
    
    private func topMostViewController(_ controller: UIViewController?) -> UIViewController? {
        var isPresenting: Bool = false
        var topController: UIViewController? = controller
        repeat {
            // this path is called only on iOS 6+, so -presentedViewController is fine here.
            if let controller = topController {
                if let presented = controller.presentedViewController {
                    isPresenting = true
                    topController = presented
                } else {
                    isPresenting = false
                }
            }
        } while isPresenting
        
        return topController
    }
    
    private func getRootViewController() -> UIViewController? {
        if var window = UIApplication.shared.keyWindow {
            
            if window.windowLevel != UIWindowLevelNormal {
                let windows: NSArray = UIApplication.shared.windows as NSArray
                for candidateWindow in windows {
                    if let candidateWindow = candidateWindow as? UIWindow {
                        if candidateWindow.windowLevel == UIWindowLevelNormal {
                            window = candidateWindow
                            break
                        }
                    }
                }
            }
            
            for subView in window.subviews {
                if let responder = subView.next {
                    if responder.isKind(of: UIViewController.self) {
                        return topMostViewController(responder as? UIViewController)
                    }
                    
                }
            }
        }
        
        return nil
    }
    
}
