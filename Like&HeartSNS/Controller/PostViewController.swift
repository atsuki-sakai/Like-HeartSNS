//
//  PostViewController.swift
//  Like&HeartSNS
//
//  Created by 酒井専冴 on 2020/03/17.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class PostViewController: UIViewController {
    
    
    @IBOutlet weak var postBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    
    var selectedImageURL:URL?
    var userName:String!
    var userProfileImage:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.postBarButtonItem.isEnabled = false
        title = "Like & Heart"
        //keyboardを開いた状態にする
//        commentTextView.becomeFirstResponder()
        
        commentTextView.layer.cornerRadius = commentTextView.frame.height/5
        commentTextView.layer.masksToBounds = false
        commentTextView.clipsToBounds = true
        commentTextView.layer.borderWidth = 4
        commentTextView.layer.borderColor = UIColor.black.cgColor
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "userName") != nil && UserDefaults.standard.object(forKey: "profileImage") != nil {
            
            userName = UserDefaults.standard.object(forKey: "userName") as! String
            userProfileImage = UserDefaults.standard.object(forKey: "profileImage") as! String
        }
        
    }
    @IBAction func PostButtonTaped(_ sender: Any) {
        
        if commentTextView.text != "" && selectedImageURL?.absoluteString.isEmpty != true{
            
            //初期化して値を入れる
            let timeLineModel = TimeLineModel(text: commentTextView.text!, imageString: selectedImageURL!.absoluteString, ProfileImageString: userProfileImage, userName: userName)
            //初期化した際の値をfirebaseに送る
            timeLineModel.contentsSave()
            //ひとつ前の画面に戻る
            self.navigationController?.popViewController(animated: true)
            
        }else if commentTextView.text.count > 50 {
            print("50文字以内で入力してください。")
            commentTextView.text = ""
        }
    }
    
    @IBAction func selectedImageViewTaped(_ sender: Any) {
        
        showAddImageAlert()
    }
    private func showAddImageAlert(){
        
        let alertVC = UIAlertController(title: "画像を選択", message: nil, preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (cameraAction) in
            
            self.openCamera()
        }
        let albumAction = UIAlertAction(title: "アルバム", style: .default) { (albumAction) in
            
            self.openAlbum()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertVC.addAction(cameraAction)
        alertVC.addAction(albumAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    //Storageに送るだけ,Databaseには送っていない
    func sendAndGetImageURL(){
        
        let ref = Database.database().reference(fromURL: "https://likeandheartsns-26e53.firebaseio.com/")
        let storage = Storage.storage().reference(forURL: "gs://likeandheartsns-26e53.appspot.com" )
        
        let key = ref.childByAutoId().key
        let imageRef = storage.child("ImageContents").child("\(key).jpeg")
        
        var imageData:Data = Data()
        
        if selectedImageView.image != nil {
            
            imageData = (selectedImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        HUD.dimsBackground = false
        HUD.show(.progress)
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            imageRef.downloadURL { (url, error) in
                
                HUD.hide()
    
                self.selectedImageURL = url
                //ボタンを押せるようにする。
                self.postBarButtonItem.isEnabled = true
                
            }
        }
        uploadTask.resume()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        commentTextView.resignFirstResponder()
    }
}
extension PostViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func openCamera(){
        
        let sourceType:UIImagePickerController.SourceType = .camera
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    func openAlbum(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let albumPicker = UIImagePickerController()
            albumPicker.allowsEditing = true
            albumPicker.sourceType = sourceType
            albumPicker.delegate = self
            
            self.present(albumPicker, animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if (info[.editedImage] as! UIImage) != nil{
            
            let selectImage = info[.editedImage] as! UIImage
            selectedImageView.image = selectImage
            //ここでデータを送信する
            sendAndGetImageURL()
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
}

