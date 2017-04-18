//
//  ViewController.swift
//  InteractiveStory
//
//  Created by Archie Tiu on 15/04/2017.
//  Copyright © 2017 LookingFor. All rights reserved.
//

import UIKit
                                        /// UITextFieldDelegate is being inherited in order to get the function where we can check if the user pressed the done button on the keyboard.
class ViewController: UIViewController, UITextFieldDelegate {
    
    enum ErrorHandler: Error {
        case NoName
    }
    /// Connects the textField object from IB for us to be able to check it via code
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var textFieldBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var startAdventureButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        /// NotificaitonCenter - Notifies when the keyboard will show up and what to do in preparation (call ViewController.keyboardWillShow method).
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /// Prepare the PageController view before it is pushed on top of the ViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startAdventure" {

            do {
                if let name = nameTextField.text {
                    if name == "" {
                        throw ErrorHandler.NoName
                    }
                    
                    if let pageController = segue.destination as? PageController {
                        pageController.page = Adventure.story(name: name)
                    }
                }
            } catch ErrorHandler.NoName {
                let alertController = UIAlertController(title: "Name Not Provided", message: "Provide a name to start your story!", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(action)
                
                present(alertController, animated: true, completion: nil)
            } catch let error {
                fatalError("\(error)")
            }
        }
    }
    
    /// this will define what will happen when the keyboard shows up
    func keyboardWillShow(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            
            UIView.animate(withDuration: 0.8) {
                self.textFieldBottomConstraint.constant = keyboardFrame.size.height + 10
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    /// this will define what will happen when the keyboard hides.
    func keyboardWillHide(notification: NSNotification) {
        if let userInfoDict = notification.userInfo, let keyboardFrameValue = userInfoDict[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardFrame = keyboardFrameValue.cgRectValue
            
            UIView.animate(withDuration: 0.8) {
                //self.textFieldBottomConstraint.constant = startAdventureButton.topAnchor + 10
                self.textFieldBottomConstraint.constant -= keyboardFrame.size.height - 20
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - UITextFieldDelegate
    // ref: https://teamtreehouse.com/library/build-an-interactive-story-app-with-swift-2/refactoring-the-model-layer/dismissing-the-keyboard
    
    /// This function is called when the user pressed the done button on the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() /// resign the textField as the first responder (remove focus).
        return true
    }
}



















































































































































