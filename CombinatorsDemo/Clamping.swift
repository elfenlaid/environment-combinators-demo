//
//  Clamping.swift
//  CombinatorsDemo
//
//  Created by elfenlaid on 2021-10-19.
//

import Foundation

@propertyWrapper
struct Clamping<Value: Comparable> {
  var value: Value
  let range: ClosedRange<Value>

  init(wrappedValue value: Value, _ range: ClosedRange<Value>) {
    precondition(range.contains(value))
    self.value = value
    self.range = range
  }

  var wrappedValue: Value { value }
}
