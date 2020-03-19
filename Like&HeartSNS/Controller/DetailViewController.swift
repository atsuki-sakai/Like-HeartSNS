//
//  DetailViewController.swift
//  Like&HeartSNS
//
//  Created by 酒井専冴 on 2020/03/17.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var userIconView: CircleImage!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
//bihaviorのeditableとselectableのチェックを外す、そのままでは編集できてしまう為。
    @IBOutlet weak var commentTextView: UITextView!
    
    //受け取り用の変数を用意
    var profileImage = String()
    var userName = String()
    var selectedImage = String()
    var likeCount = Int()
    var heartCount = Int()
    var comment = String()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        //ボタンを押せなくする
        likeButton.isEnabled = false
        heartButton.isEnabled = false

        userIconView.sd_setImage(with: URL(string: profileImage), placeholderImage: UIImage(named: "noImage"), options: .continueInBackground, completed: nil)
        userNameLabel.text = userName
        selectedImageView.sd_setImage(with: URL(string: selectedImage), placeholderImage: UIImage(named: "noImage"), options: .continueInBackground, completed: nil)
        likeButton.setTitle("👍🏽 \(likeCount)いいね", for: [])
        heartButton.setTitle("😍 \(heartCount)ハート", for: [])
        commentTextView.text = comment
        
        selectedImageView.layer.masksToBounds = false
        selectedImageView.clipsToBounds = true
        selectedImageView.layer.cornerRadius = selectedImageView.frame.height/4
        selectedImageView.layer.borderWidth = 4
        selectedImageView.layer.borderColor = UIColor.black.cgColor
        selectedImageView.contentMode = .scaleAspectFill
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
