//
//  Time.swift
//  CombinatorsDemo
//
//  Created by elfenlaid on 2021-10-19.
//

import Foundation

struct Time {
  @Clamping(0 ... 23) var hours: Int = 0
  @Clamping(0 ... 59) var minutes: Int = 0
  @Clamping(0 ... 59) var seconds: Int = 0
}

extension Time {
  init(date: Date, calendar: Calendar = .current) {
    self.init(
      hours: calendar.component(.hour, from: date),
      minutes: calendar.component(.minute, from: date),
      seconds: calendar.component(.second, from: date)
    )
  }
}

extension Time: CustomStringConvertible {
  var description: String {
    String(format: "%02d:%02d:%02d", hours, minutes, seconds)
  }
}
