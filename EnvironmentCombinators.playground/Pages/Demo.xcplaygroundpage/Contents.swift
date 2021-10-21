@testable import CombinatorsDemo
import Combine
import Foundation
import CombineSchedulers
import XCTestDynamicOverlay



struct World {
  var now = { Date() }
  var calendar = Calendar.autoupdatingCurrent
  var mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
}

var Current = World()

Current.now = { Date(timeIntervalSince1970: 0) }

Current.calendar = Calendar.init(identifier: .gregorian)
Current.calendar.timeZone = TimeZone(identifier: "Atlantic/Reykjavik")!


let scheduler = DispatchQueue.test
Current.mainQueue = scheduler.eraseToAnyScheduler()


final class Clock {
  @Published private(set) var time: Time?

  private var timer: Any?

  func start() {
    timer = Current.mainQueue.timerPublisher(every: .seconds(1))
       .autoconnect()
       .sink { [weak self] _ in
         self?.tick()
       }
  }

  private func tick() {
    time = Time(date: Current.now(), calendar: Current.calendar)
  }
}

let clock = Clock()

let subscription = clock.$time.compactMap { $0 }.sinkPrint()
clock.start()


scheduler.advance(by: 1)
scheduler.advance(by: 1)

Current.now = { Current.calendar.date(from: .init(hour: 8, minute: 0))! }
scheduler.advance(by: 1)

Current.now = { Current.calendar.date(from: .init(hour: 22, minute: 30))! }
scheduler.advance(by: 1)
