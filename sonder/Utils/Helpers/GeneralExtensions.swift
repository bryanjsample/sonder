//
//  GeneralExtensions.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

import Foundation

extension Date {
    func adding(minutes: Int) -> Date? {
        guard let future = Calendar.current.date(byAdding: .minute, value: minutes, to: self) else {
            print("Error adding time to current date")
            return nil
        }
        return future
    }
    func adding(hours: Int) -> Date? {
        guard let future =  Calendar.current.date(byAdding: .hour, value: hours, to: self) else {
            print("Error adding time to current date")
            return nil
        }
        return future
    }
    func adding(days: Int) -> Date? {
        guard let future = Calendar.current.date(byAdding: .day, value: days, to: self) else {
            print("Error adding time to current date")
            return nil
        }
        return future
    }
}
