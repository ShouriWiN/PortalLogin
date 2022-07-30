//
//  ViewController.swift
//  PortalLogin
//
//  Created by Shouri on 2022/06/30.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    let realm = try! Realm()
    
    var itemLists: Results<timeTable>!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("didload")
        
        let login = portalAuth()
        
        Task{
            try await login.getResponse()   //ログインページからPOSTに必要なデータを取ってくる
            try await login.logIn()         //ログイン実行
            print("終わった")
            tableView.reloadData()          //処理が終わるとテーブル更新
        }
        
        let portalData = realm.objects(timeTable.self)
        print("全てのデータ\(portalData)")
        
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        tableView.layer.cornerRadius = 10
        
        itemLists = realm.objects(timeTable.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemLists.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! MainTableViewCell
        
        print("yy")
        print(itemLists[indexPath.row])
        let itemList = itemLists[indexPath.row]
        print(itemLists[indexPath.row].time)
        
        //print(indexPath.row)
        if(itemList.time == "09:30～11:00") {
            cell.img.image = UIImage(systemName: "1.circle.fill")
        } else if(itemList.time == "11:10～12:40") {
            cell.img.image = UIImage(systemName: "2.circle.fill")
        } else if(itemList.time == "13:30～15:00") {
            cell.img.image = UIImage(systemName: "3.circle.fill")
        } else if(itemList.time == "15:10～16:40") {
            cell.img.image = UIImage(systemName: "4.circle.fill")
        } else {
            cell.img.image = UIImage(systemName: "exclamationmark.circle.fill")
        }
        
        cell.dateLabel.text = "\(itemList.dateValue)"
        cell.timeLabel.text = itemList.time
        cell.nameLabel.text = itemList.name
        return cell
    }
    /*
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
     */
    
    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

