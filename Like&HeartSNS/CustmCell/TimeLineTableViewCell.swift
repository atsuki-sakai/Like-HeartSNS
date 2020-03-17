//
//  TimeLineTableViewCell.swift
//  Like&HeartSNS
//
//  Created by 酒井専冴 on 2020/03/16.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import Lottie

class TimeLineTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userSelectedImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var commentLabel: UILabel!
    
    let tapLikeColor = UIColor.red
    let tapHeartColor = UIColor.red
    let normalLikeColor = UIColor.lightGray
    let normalHeartColor = UIColor.lightGray
    
    var likeTapFlag = false
    var heartTapFlag = false
    var profileImageStringCheck = String()
    
    var animationView:AnimationView! = AnimationView()
    
    var timeLineModel:TimeLineModel!{
        
        didSet{
            commentLabel.text = timeLineModel.text
            commentLabel.sizeToFit()
            userIconView.sd_setImage(with: URL(string: timeLineModel.profileImageString), placeholderImage: UIImage(named: "noImage"), options: .continueInBackground, completed: nil)
            userSelectedImageView.sd_setImage(with: URL(string: timeLineModel.imageString), placeholderImage: UIImage(named: "noImage"), options: .continueInBackground, completed: nil)
            userNameLabel.text = timeLineModel.userName
            
            //よく考える
            if likeTapFlag == false && heartTapFlag == false{
                    likeButton.setTitleColor(normalLikeColor, for: [])
                    heartButton.setTitleColor(normalHeartColor, for: [])
                    
            }else if (timeLineModel.likeCounts == 0 && timeLineModel.heartCounts == 0) && likeTapFlag == true && heartTapFlag == false{
                
                likeButton.setTitleColor(normalLikeColor, for: [])

                
            }else if (timeLineModel.likeCounts == 0 && timeLineModel.heartCounts == 0) && likeTapFlag == false && heartTapFlag == true{
                
                heartButton.setTitleColor(normalHeartColor, for: [])

                
            }else if likeTapFlag == true{
                 likeButton.setTitleColor(tapLikeColor, for: [])
            }else if heartTapFlag == true{
                heartButton.setTitleColor(tapHeartColor, for: [])
            }
            
            likeButton.setTitle("👍🏽 \(timeLineModel.likeCounts) いいね！", for: [])
            heartButton.setTitle("😍 \(timeLineModel.heartCounts)ハート", for: [])
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
       
        userSelectedImageView.layer.masksToBounds = false
        userSelectedImageView.layer.cornerRadius = frame.height/10
        userSelectedImageView.clipsToBounds = true
        userSelectedImageView.layer.borderColor = UIColor.black.cgColor
        userSelectedImageView.layer.borderWidth = 4
        userSelectedImageView.contentMode = .scaleAspectFill
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func startLikeAnimation(){
        
        let animation = Animation.named("good")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        animationView.loopMode = .playOnce
        animationView.backgroundColor = .clear
        animationView.play()
        self.addSubview(animationView)
        //buttonが押されてから2秒、遅延させてからaniamtionViewを消す
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            //2秒後に行いたい処理
            self.animationView.removeFromSuperview()
            
        }
        
    }
    func startHeartAnimation(){
        
        let animation = Animation.named("heart")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        animationView.backgroundColor = .clear
        self.addSubview(animationView)
        
        animationView.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            self.animationView.removeFromSuperview()
        }
    }
    
    @IBAction func likeButtonTaped(_ sender: Any) {
    
    if UserDefaults.standard.object(forKey: "profileImage") != nil{
        
        profileImageStringCheck = UserDefaults.standard.object(forKey: "profileImage") as! String
    }
    
    
    //自分のアカウント
    if profileImageStringCheck == timeLineModel.profileImageString{
        if likeTapFlag == false && heartTapFlag == false {
            print("mylike : L false & H false")
            timeLineModel.plusLike()
            likeButton.setTitle("👍 \(timeLineModel.likeCounts)いいね", for: [])
            likeButton.setTitleColor(tapLikeColor, for: [])
    
            startLikeAnimation()
            likeTapFlag = true
        }else if likeTapFlag == true && heartTapFlag == false {
            
            print("mylike : L true & H false")
            if timeLineModel.likeCounts == 0{
                print("myLike Count == 0")
                likeButton.setTitle("👍 \(timeLineModel.likeCounts)いいね", for: [])
                timeLineModel.likeCounts += 1
                likeButton.setTitleColor(tapLikeColor, for: [])
               
                startLikeAnimation()
                likeTapFlag = true
                return
            }
            print("myLike Count != 0")
            
            timeLineModel.minusLike()
            likeButton.setTitle("👍 \(timeLineModel.likeCounts)いいね", for: [])
            likeButton.setTitleColor(normalLikeColor, for: [])
            
            likeTapFlag = false
        }
        
        
    }else{
        
        if likeTapFlag == false && heartTapFlag == false{
            print("like : false & false")
            timeLineModel.plusLike()
            likeButton.setTitle("👍 \(timeLineModel.likeCounts)いいね", for: [])
            likeButton.setTitleColor(tapLikeColor, for: [])
            
            startLikeAnimation()
            likeTapFlag = true
            
        }else if likeTapFlag == true && heartTapFlag == false{
            print("like : L true H false")
            if timeLineModel.likeCounts == 0{
                print("like Count == 0")
                print(timeLineModel.likeCounts)
                timeLineModel.likeCounts += 1
                likeButton.setTitle("👍 \(timeLineModel.likeCounts)いいね", for: [])
                likeButton.setTitleColor(tapLikeColor, for: [])
               
                startLikeAnimation()
                likeTapFlag = true
                return
            }
            print("like Count != 0")
            
            timeLineModel.minusLike()
            likeButton.setTitle("👍 \(timeLineModel.likeCounts)いいね", for: [])
            likeButton.setTitleColor(normalLikeColor, for: [])
            
            likeTapFlag = false
            }
        }
        
    }
    @IBAction func heartButtonTaped(_ sender: Any) {
        
        //自分のアカウント
        if profileImageStringCheck == timeLineModel.profileImageString{
            
                if likeTapFlag == false && heartTapFlag == false{
                    timeLineModel.plusHeart()
                    heartButton.setTitle("♡ \(timeLineModel.heartCounts)ハート", for: [])
                    heartButton.setTitleColor(tapHeartColor, for: [])
                   
                    startHeartAnimation()
                    heartTapFlag = true

                    
                }else if likeTapFlag == false && heartTapFlag == true{
                    
                    if timeLineModel.heartCounts == 0{
                        timeLineModel.plusHeart()
                     
                     heartButton.setTitle("♡ \(timeLineModel.heartCounts)ハート", for: [])
                        heartButton.setTitleColor(tapHeartColor, for: [])
                     
                        startHeartAnimation()
                        heartTapFlag = true
                        return
                    }

                    
                   timeLineModel.minusHeart()
                    heartButton.setTitle("♡ \(timeLineModel.heartCounts)ハート", for: [])
                    heartButton.setTitleColor(normalHeartColor, for: [])
    
                    heartTapFlag = false
                }
                
            
        }else{
            
           
            if likeTapFlag == false && heartTapFlag == false{
                
                timeLineModel.plusHeart()
                heartButton.setTitle("♡ \(timeLineModel.heartCounts)ハート", for: [])
                heartButton.setTitleColor(tapHeartColor, for: [])
              
                startHeartAnimation()
                heartTapFlag = true
            }else if likeTapFlag == false && heartTapFlag == true {
                
                if timeLineModel.heartCounts == 0{
                    timeLineModel.plusHeart()
                    heartButton.setTitle("♡ \(timeLineModel.heartCounts)ハート", for: [])
                    heartButton.setTitleColor(tapHeartColor, for: [])
    
                    startHeartAnimation()
                    heartTapFlag = true
                    return
                }

                timeLineModel.minusHeart()
                heartButton.setTitle("♡ \(timeLineModel.heartCounts)ハート", for: [])
                heartButton.setTitleColor(normalHeartColor, for: [])
                heartTapFlag = false

            }
            
            
            
        }

     
    }
    
}
