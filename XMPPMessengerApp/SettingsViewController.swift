//
//  SettingsViewController.swift
//  XMPPMessengerApp
//
//  Created by Zhouboli on 15/10/21.
//  Copyright © 2015年 Boris. All rights reserved.
//

import Foundation
import UIKit
import XMPPFramework
import xmpp_messenger_ios

class SettingsViewController : UIViewController
{
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var validateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        //let tap = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if OneChat.sharedInstance.isConnected()
        {
            usernameTextField.hidden = true
            passwordTextField.hidden = true
            validateButton.setTitle("Disconnect", forState: UIControlState.Normal)
        }
        else
        {
            if NSUserDefaults.standardUserDefaults().stringForKey(kXMPP.myJID) != "kXMPPmyJID"
            {
                usernameTextField.text = NSUserDefaults.standardUserDefaults().stringForKey(kXMPP.myJID)
                passwordTextField.text = NSUserDefaults.standardUserDefaults().stringForKey(kXMPP.myPassword)
            }
        }
    }
    
    func dismissKeyboard() {
        if usernameTextField.isFirstResponder() {
            usernameTextField.resignFirstResponder()
        } else if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if passwordTextField.isFirstResponder() {
            textField.resignFirstResponder()
            validate(self)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    @IBAction func validate(sender: AnyObject) {
        if OneChat.sharedInstance.isConnected()
        {
            OneChat.sharedInstance.disconnect()
            usernameTextField.hidden = false
            passwordTextField.hidden = false
            validateButton.setTitle("Validate", forState: UIControlState.Normal)
        }
        else
        {
            OneChat.sharedInstance.connect(username: usernameTextField.text!, password: passwordTextField.text!, completionHandler: { (stream, error) -> Void in
                if let _ =  error
                {
                    let alertController = UIAlertController(title: "Sorry", message: "An error occurred: \(error)", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                        
                    }))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else
                {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }
    
    @IBAction func close(sender: AnyObject) {
    }
}