//
//  Timetable.swift
//  PortalLogin
//
//  Created by Shouri on 2022/06/11.
//

import Foundation
import RealmSwift

class timeTable: Object {
    @objc dynamic var dateValue = 20180101
    var date: Date? {
        get {
            let year = (dateValue / 10000)
            let month = (dateValue % 10000) / 100
            let day = (dateValue % 100)
            let dateComponent = DateComponents(calendar: Calendar.current, year: year, month: month, day: day)
            return dateComponent.date
        }
        set {
            if let date = newValue {
                let year = Calendar.current.component(.year, from: date)
                let month = Calendar.current.component(.month, from: date)
                let day = Calendar.current.component(.day, from: date)
                dateValue = year * 10000 + month * 100 + day
            }
        }
    }
    @objc dynamic var time: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var professor: String = ""
}
