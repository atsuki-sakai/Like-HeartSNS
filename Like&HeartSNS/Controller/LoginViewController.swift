//
//  LoginViewController.swift
//  Like&HeartSNS
//
//  Created by 酒井専冴 on 2020/03/16.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBOutlet weak var errorLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        //UserNameViewを表示しないtrueで非表示
        errorLabel.isHidden = true
        self.userNameView.isHidden = true
        alertLabel.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    @IBAction func loginButtonTaped(_ sender: Any) {
        
        self.userNameView.isHidden = false
        userNameView.alpha = 0.0
        userNameView.layer.cornerRadius = 20
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: [.curveEaseIn], animations: {
            self.userNameView.alpha = 1.0
        }, completion: nil)
        
    }
    @IBAction func closeButtonTaped(_ sender: Any) {
        
        UIView.animate(withDuration: 0.6, delay: 0.0, options: .allowUserInteraction, animations: {
            self.userNameView.alpha = 0.0
        }) { (completed) in
            //animationの完了時に非表示にする。
            self.userNameTextField.text = ""
            self.alertLabel.isHidden = true
            self.userNameView.isHidden = true
        }
    }
    @IBAction func doneButtonTaped(_ sender: Any) {
        
        if userNameTextField.text != ""{
            
            Auth.auth().signInAnonymously { (authResult, error) in
                
                if let error = error {
                  
                    //errorの時は振動させる
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.error)
                    self.errorLabel.isHidden = false
                    self.errorLabel.adjustsFontSizeToFitWidth = true
                    self.errorLabel.text = error.localizedDescription
                    
                    return
                    
                }
                //画面遷移
                UserDefaults.standard.setValue(self.userNameTextField.text!, forKey: "userName")
                self.performSegue(withIdentifier: "edit", sender: nil )
                
                return
                
            
            }
        }else{
        userNameTextField.text = ""
        alertLabel.isHidden = false
        return 
        }
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
