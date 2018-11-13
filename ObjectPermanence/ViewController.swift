//
//  ViewController.swift
//  ObjectPermanence
//
//  Created by Erkin Otles on 11/12/18.
//  Copyright © 2018 Erkin Otles. All rights reserved.
//

import UIKit
import os.log
import MessageUI

/**
 View controller
 Many sins committed against the MVC gods below...
 */
class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    //MARK: Properties
    var objects: [Object] = []
    var dateFormatter = DateFormatter()
    
    @IBOutlet weak var sTextField: UITextField!
    @IBOutlet weak var savedObjectsTextView: UITextView!
    
    
    //MARK: Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        let newObject = Object(s: sTextField.text!, d: Date())
        objects.append(newObject!)
        self.save()
        self.update()
    }
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        self.sendEmail()
    }
    
    //MARK: UIViewController Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
    }
    
    //MARK: View Helper Methods
    func update() {
        self.load()
        sTextField.text = ["Whatsup?", "Say something...", "Aloha"].randomElement()
        
        //formatting date
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .short
        
        //Make object data human readable
        var objectsToString = ""
        for object in objects {
            objectsToString += "\(object.s) (\(self.dateFormatter.string(from: object.d)))\n"
        }
        savedObjectsTextView.text = objectsToString
    }
    
    
    
    //MARK: Data Handling
    private func load() {
        guard let savedObjects = NSKeyedUnarchiver.unarchiveObject(withFile: Object.ArchiveURL.path) as? [Object] else {
            return
        }
        self.objects = savedObjects
    }
    
    private func save() {
        let isSuccessfullySaved = NSKeyedArchiver.archiveRootObject(self.objects, toFile: Object.ArchiveURL.path)
        if isSuccessfullySaved {
            os_log("Results successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save results...", log: OSLog.default, type: .error)
        }
    }
    
    private func toJSON() -> String {
        self.load()
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(self.objects)
        let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8)
        return jsonString!
    }
    
    //MARK: Email Stuff
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["eotles@gmail.com"])
            mail.setSubject("[ObjectPermanence Data]")
            mail.setMessageBody("<p>All results attached.</p>", isHTML: true)
            
            mail.addAttachmentData(self.toJSON().data(using: .utf8)!, mimeType: "application/json", fileName: "objects.json")
            
            present(mail, animated: true)
        } else {
            // show failure alert
            print("Mail fail :(")
        }
    }
    


}

