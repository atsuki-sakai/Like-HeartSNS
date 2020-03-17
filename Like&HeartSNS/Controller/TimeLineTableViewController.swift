//
//  TimeLineTableViewController.swift
//  Like&HeartSNS
//
//  Created by 酒井専冴 on 2020/03/16.
//  Copyright © 2020 sakai_atsuki. All rights reserved.
//

import UIKit
import Firebase

class TimeLineTableViewController: UITableViewController {
    
    var timeLineRef = Database.database().reference().child("timeLine")
    var timeLines = [TimeLineModel]()
    
    var profileImageString:String = ""
    var userName:String = ""
    var imageString:String = ""
    var likeCounts:Int = 0
    var heartCounts:Int = 0
    var text:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "TimeLineTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
        
        self.navigationController?.navigationBar.isHidden = false
        //backボタンを非表示
        self.navigationItem.hidesBackButton = true
        title = "Like & Heart"
        //cellの選択を可能にする
        self.tableView.allowsSelection = true
        //CustomCellの場合は必要
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 511
        
        tableView.separatorColor = UIColor.systemBlue

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTimeLineData()
    }
    func fetchTimeLineData(){
        
        timeLineRef.observe(.value) { (snapShot) in
        
            print("A snapShot :\(snapShot)")
            print("A snapShotChildren: \(snapShot.children)")
            self.timeLines.removeAll()
            
            for child in snapShot.children{
                print("A child : \(child)")
                let childSnapShot = child as! DataSnapshot
                let timeLine = TimeLineModel(snapShot: childSnapShot)
                print("A timeLine\(timeLine)")
                //0番目に追加していく。
                self.timeLines.insert(timeLine, at: 0)
            }
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return timeLines.count
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! TimeLineTableViewCell
        
        let timeLineModel = timeLines[indexPath.row]
        //timelineTableViewCellのtimeLineModelに代入することでdidSetが発動する。
        cell.timeLineModel = timeLineModel
        cell.selectionStyle = .none
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 511
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let timeLine = timeLines[indexPath.row]
        
        profileImageString = timeLine.profileImageString
        userName = timeLine.userName
        imageString = timeLine.imageString
        likeCounts = timeLine.likeCounts
        heartCounts = timeLine.heartCounts
        text = timeLine.text
        
        performSegue(withIdentifier: "detail", sender: nil)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            
            let detailVC = segue.destination as! DetailViewController
            
            detailVC.profileImage = self.profileImageString
            detailVC.userName = self.userName
            detailVC.selectedImage = self.imageString
            detailVC.likeCount = self.likeCounts
            detailVC.heartCount = self.heartCounts
            detailVC.comment = self.text
            
        }
        return
    }
    @IBAction func transitionPostVC(_ sender: Any) {
        
        performSegue(withIdentifier: "post", sender: nil)
        
    }
    

}
