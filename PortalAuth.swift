//
//  PortslAuth.swift
//  PortalLogin
//
//  Created by Shouri on 2022/06/11.
//

import Foundation
import Alamofire
import Kanna
import RealmSwift

class portalAuth {
    
    var parameter: Parameters = [:]
    var viewstate: String = ""
    var eventvalidation: String = ""
    var viewstategenerator: String = ""
    let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
    
    let id: String = "12345678"
    let password = "password"
    
    func getResponse() async throws -> String {
        return try await AF.request("https://portal.xxx.ac.jp/pc/")
            .responseString { response in
                print("\(response.result)")
                if let html = response.value {
                    if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                        // Search for nodes by CSS selector
                        
                        for show in doc.css("input[id='__VIEWSTATE']") {
                            self.viewstate=show["value"]!
                            //print(show["value"] as Any)
                        }
                        
                        for show in doc.css("input[id='__VIEWSTATEGENERATOR']") {
                            self.viewstategenerator=show["value"]!
                            //print(show["value"] as Any)
                        }
                        
                        for show in doc.css("input[id='__EVENTVALIDATION']") {
                            self.eventvalidation=show["value"]!
                            //print(show["value"] as Any)
                        }
                    }
                }
                //creating dictionary for parameters
                self.parameter = ["__LASTFOCUS":"",
                                  "__EVENTTARGET":"",
                                  "__EVENTARGUMENT":"",
                                  "__VIEWSTATE":self.viewstate,
                                  "__VIEWSTATEGENERATOR":self.viewstategenerator,
                                  "__EVENTVALIDATION":self.eventvalidation,
                                  
                                  "txtUserid":self.id,          //UserID
                                  "txtUserpw":self.password,    //Password

                                  "ibtnlogin.x":"45",
                                  "ibtnlogin.y":"13"              //マウスカーソルの位置 多分なんでもいい
                ]
                
            }
            .serializingString().value
    }
    
    func logIn() async throws -> String {
        
        let realm = try! await Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        return try await AF.request ("https://portal.xxx.ac.jp/pc/",method: .post, parameters: parameter, headers: headers)
            .responseString { response in
                //print("\(response.result)")
                //print(response)
                if let html = response.value {
                    if let doc = try? HTML(html: html, encoding: String.Encoding.utf8) {
                        
                        var YM: String = ""
                        var yearMonth: String = ""
                        var subjectCount = 0
                        var getDay: String = ""
                        var subjectDay = 0
                        for getYM in doc.xpath("//span[@id='tabCalender_tabPanelMonth_lblMonth']") {
                            YM = getYM.text ?? ""
                            yearMonth = YM.replacingOccurrences(of:"/", with:"")
                        }
                        
                        
                        
                        for week in 1 ..< 6 {
                            for day in 1 ..< 7 {
                                
                                //let subject = timeTable()
                                
                                
                                for per in 1 ..< 5 {
                                    subjectCount = 0
                                    let subject = timeTable()
                                    for days in doc.xpath("//a[@id='tabCalender_tabPanelMonth_lnkDay" + String(week) + "_" + String(day) + "']") {
                                        getDay = days.text ?? ""
                                        subjectDay = Int(getDay) ?? 0
                                    }
                                    
                                    for link in doc.xpath("//td[@id='tabCalender_tabPanelMonth_tblMCell" + String(week) + "_" + String(day) + "']/div[" + String(per) + "]//span[@class='long_text jugyo_link_style']") {
                                        //td[@id='tabCalender_tabPanelMonth_tblMCell1_4']//span[@class='long_text jugyo_link_style']
                                        
                                        if subjectCount == 0 {
                                            print(subjectCount)
                                            //print(String(yearMonth) + String(subjectDay))
                                            let dateeee = String(yearMonth) + String(format: "%02d" ,subjectDay)
                                            print(dateeee)
                                            subject.dateValue = Int(dateeee) ?? 0
                                            print(link.text)
                                            subject.time = link.text!
                                            
                                        }else if subjectCount == 1 {
                                            print(subjectCount)
                                            print(link.text)
                                            
                                        }else if subjectCount == 2 {
                                            print(subjectCount)
                                            print(link.text)
                                            subject.name = link.text!
                                            
                                        }else if subjectCount == 3 {
                                            print(subjectCount)
                                            print(link.text)
                                            subject.professor = link.text!
                                            
                                        }
                                        
                                        //print(count)
                                        subjectCount += 1
                                    }
                                    
                                    //すでにデータが有る場合スキップする(テスト)
                                    //まだユーザーが変わった場合や時間割が追加された場合に対応できていない
                                    if(subject.time == "" && subject.name == "" && subject.professor == ""){
                                        continue
                                    }else{
                                        
                                        let results = realm.objects(timeTable.self).filter("dateValue == %@ && time == %@", subject.dateValue, subject.time)
                                        //AND time == %@ AND name == %@ AND professor == %@
                                        //, subject.time, subject.name, subject.professor
                                        if(results.isEmpty) {
                                            try! realm.write {
                                                realm.add(subject)
                                            }
                                        }else{
                                            continue
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            .serializingString().value
    }
    
}
