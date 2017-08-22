// AppShare.swift
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

import Foundation
import Social
import MessageUI

open class AppShare : NSObject {
    
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
        super.init();
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
    open func shareApp(on: AppShareService, sourceView: UIView?) {
        self.manager.sourceView = sourceView;
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
    
    open func openShareWindow(viewcontroller: UIViewController) {
        self.manager.openShareWindow(viewcontroller: viewcontroller);
    }
    
}

open class AppShareManager : NSObject, MFMailComposeViewControllerDelegate {
    
    var applinkCode : String?;
    var vc : UIViewController?;
    var sourceView : UIView?;
    var mailComposer : MFMailComposeViewController?;
    public var useMainAppBundleForLocalizations : Bool = false;
    
    func shareApp() {
        if let url = _getShareURL() {
            self._shareURLOnAll(url: url);
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
                case .email:
                    self._shareByMail(text: shareText);
                    break;
                default:
                    return;
                }
            }
        }
    }
    
    open func openShareWindow(viewcontroller: UIViewController) {
        let frameworkBundle = self.bundle();
        let storyboard = UIStoryboard(name: "AppShare", bundle: frameworkBundle);
        let vc = storyboard.instantiateInitialViewController() as! AppShareViewController;
        vc.applinkCode = self.applinkCode;
        viewcontroller.present(vc, animated: true);
    }
    
    // - Privates
    
    func _shareURLOnAll(url:URL) {
        let objectsToShare = [url]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
            self.vc?.present(activityVC, animated: true, completion: nil);
        } else if let sourceView = self.sourceView {
            activityVC.popoverPresentationController?.sourceView = sourceView;
            self.vc?.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private func _shareOnFacebook(url: URL) {
        if #available(iOS 11.0, *) {
            self._shareURLOnAll(url: url);
        } else {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                fbSheet?.add(url);
                if let vc = self.vc {
                    vc.present(fbSheet!, animated: true, completion: nil);
                }
            } else {
                self._shareURLOnAll(url: url);
            }
        }
    }
    
    private func _shareOnTwitter(text: String, url: URL) {
        if #available(iOS 11.0, *) {
            self._shareURLOnAll(url: url);
        } else {
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                let twSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twSheet?.setInitialText(text)
                twSheet?.add(url);
                if let vc = self.vc {
                    vc.present(twSheet!, animated: true, completion: nil);
                }
            } else {
                self._shareURLOnAll(url: url);
            }
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
    
    private func _shareByMail(text:String) {
        mailComposer = MFMailComposeViewController()
        mailComposer?.mailComposeDelegate = self
        mailComposer?.setMessageBody(text, isHTML: true)
        if let mailComposer = self.mailComposer {
            if let vc = self.vc {
                vc.present(mailComposer, animated: true, completion: nil)
            }
        }
    }
    
    
    // Email delegate
    public func mailComposeController(_ controller:MFMailComposeViewController, didFinishWith result:MFMailComposeResult, error:Error?) {
        var outputMessage = ""
        switch result.rawValue {
        case MFMailComposeResult.cancelled.rawValue:  outputMessage = ""
        case MFMailComposeResult.saved.rawValue:  outputMessage = ""
        case MFMailComposeResult.sent.rawValue:  outputMessage = ""
        case MFMailComposeResult.failed.rawValue: outputMessage = "Something went wrong with sending Mail, try again later."
        default:break  }
        
        if let vc = self.vc {
            vc.dismiss(animated: false, completion: { () -> Void in
                if (outputMessage != "") {
                    self._showAlertView(title: "Email", message: outputMessage);
                }
            })
        }
        
        
    }
    
    private func _topMostViewController(_ controller: UIViewController?) -> UIViewController? {
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
    
    // MARK: -
    // MARK: PRIVATE Misc Helpers
    
    public func bundle() -> Bundle? {
        var bundle: Bundle? = nil
        if useMainAppBundleForLocalizations {
            bundle = Bundle.main
        } else {
            let podBundle = Bundle(for: AppShareManager.classForCoder())
            if let bundleURL = podBundle.url(forResource: "AppShareRessources", withExtension: "bundle") {
                if let resourceBundle = Bundle(url: bundleURL) {
                    bundle = resourceBundle;
                }
            }
        }
        if bundle != nil {
            return bundle;
        } else {
            return Bundle.main;
        }
    }
    
}

public enum AppShareService: Int {
    case all, facebook, twitter, whatsapp, email
}
