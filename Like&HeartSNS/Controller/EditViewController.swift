//
//  EditViewController.swift
//  Like&HeartSNS
//
//  Created by 酒井専冴 on 2020/03/16.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Photos
import Firebase
import PKHUD

class EditViewController: UIViewController {

    var userName:String?
    var imageURL:URL?
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch (status){
                
            case .notDetermined:
                print("error")
                return
            case .restricted:
                print("error")
                return
            case .denied:
                print("error")
                return
            case .authorized:
                print("許可を得ています。success")
            @unknown default:
                print("error")
                return
            }
        }
       
    }
    @IBAction func imageViewTaped(_ sender: Any) {
        
        ShowphotoAlert()
        
    }
    @IBAction func doneButtonTaped(_ sender: Any) {
        
        if userImageView.image != nil {
            
            //同期処理
            DispatchQueue.main.async {
            //sendAndGetが終わるまで次の処理にはいかない
                self.sendAndGetURL()
                
            }
            performSegue(withIdentifier: "timeLine", sender: nil)
            
        }
    }
    private func sendAndGetURL(){
        //RealTimeDatabaseのURL
        let ref = Database.database().reference(fromURL: "https://likeandheartsns-26e53.firebaseio.com/")
        //StorageのURL
        let storage = Storage.storage().reference(forURL: "gs://likeandheartsns-26e53.appspot.com")
        
        //Uniquなkeyを生成
        let key = ref.childByAutoId().key
        //画像の名前,保存する為のURLPATHを作成
        let imageRef = storage.child("ProfileImages").child("\(String(describing: key)).jpeg")
        //userImageViewの画像を圧縮する100/1
        var imageData:Data = Data()
        if userImageView.image != nil {
            
            imageData = (userImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        //indicatorを回す
        //背景色を白ベースにする
        HUD.dimsBackground = false
        //indicatorの形式を指定
        HUD.show(.progress)
        
        let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
            
            if let error = error {
                
                print(error.localizedDescription)
                return
                
            }   
            imageRef.downloadURL { (url, error) in
                
                if url != nil {
                    
                    //indicatorを止める
                    HUD.hide()
                    
                    
                    self.imageURL = url
                    //ImageURLをstrinng型に変換して保存
                    UserDefaults.standard.set(self.imageURL?.absoluteString, forKey: "profileImage")
                }
            }
        }
        //処理を続ける
        uploadTask.resume()
    }
    private func ShowphotoAlert(){
        
        let alertVC = UIAlertController(title: "写真を選択", message: "カメラ OR アルバム", preferredStyle: .alert)
        
        let cameraAction = UIAlertAction(title: "カメラ", style: .default) { (cameraAction) in
            
            //カメラを開く
            self.openCamera()
        }
        let albumAction = UIAlertAction(title: "アルバム", style: .default) { (albumAction) in
            
            //アルバムを開く
            self.openAlbum()
        }
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertVC.addAction(cameraAction)
        alertVC.addAction(albumAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    
}



extension EditViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    func openCamera(){
        
        let sourceType: UIImagePickerController.SourceType = .camera
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPiker = UIImagePickerController()
            
            cameraPiker.sourceType = sourceType
            cameraPiker.allowsEditing = true
            cameraPiker.delegate = self
            
            self.present(cameraPiker, animated: true, completion: nil)
        }
    }
    func openAlbum(){
        
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            
            let albumPicker = UIImagePickerController()
            
            albumPicker.sourceType = sourceType
            albumPicker.allowsEditing = true
            albumPicker.delegate = self
            
            self.present(albumPicker, animated: true, completion: nil)
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //cancelボタンが押された時閉じる
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if  let pickedImage = info[.editedImage] as? UIImage {
            
            self.userImageView.image = pickedImage
            //userImageViewにセットしてpickerを閉じる
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
