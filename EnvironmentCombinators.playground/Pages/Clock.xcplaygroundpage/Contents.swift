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
    time = Time(date: Date())
  }
}



























let clock = Clock()
let subscription = clock.$time.compactMap { $0 }.sink { print($0) }
clock.start()
