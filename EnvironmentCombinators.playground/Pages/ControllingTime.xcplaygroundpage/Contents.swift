import Cocoa
import Combine
import CombineSchedulers
@testable import CombinatorsDemo

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

// MARK: - World

struct World {
  var now = { Date() }
  var calendar = Calendar.autoupdatingCurrent
  var mainQueue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
}

var Current = World()

timeMachine: do {
  let scheduler = DispatchQueue.test
  Current.mainQueue = scheduler.eraseToAnyScheduler()
}


// MARK: Ticking

let clock = Clock()
let subscription = clock.$time.compactMap { $0 }.sink { print($0) }
clock.start()

timeTraveling: do {
//  Current.now = { Current.calendar.date(from: .init(hour: 8, minute: 0))! }
//  scheduler.advance(by: 1)
//
//  Current.now = { Current.calendar.date(from: .init(hour: 22, minute: 30))! }
//  scheduler.advance(by: 1)
}
