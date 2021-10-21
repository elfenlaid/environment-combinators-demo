import Cocoa
import Combine
@testable import CombinatorsDemo

final class Clock {
  @Published private(set) var time: Time?
  private var timer: Timer?

  func start() {
    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
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

  // locale
  // device
  // screen orientation
  // file system
  //
  // alongside usual onces
  // network
  // database
}

var Current = World(
  now: { Date(timeIntervalSince1970: 0) }
)

calendar: do {
  Current.calendar = Calendar.init(identifier: .gregorian)
  Current.calendar.timeZone = TimeZone(identifier: "Europe/Lisbon")!
}

// MARK: Ticking

let clock = Clock()
let subscription = clock.$time.compactMap { $0 }.sink { print($0) }
clock.start()
