let clock = Clock()
let subscription = clock.$time.compactMap { $0 }.sink { print($0) }
clock.start()


///

  // locale
  // device
  // screen orientation
  // file system
  //
  // alongside usual onces
  // network
  // database

struct World {
  var now = { Date() }
  var calendar = Calendar.autoupdatingCurrent
}

var Current = World(
  now: { Date(timeIntervalSince1970: 0) }
)

calendar: do {
  Current.calendar = Calendar.init(identifier: .gregorian)
  Current.calendar.timeZone = TimeZone(identifier: "Europe/Lisbon")!
  Current.calendar.timeZone = TimeZone(identifier: "Atlantic/Reykjavik")!
}

///

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

timeTraveling: do {
 Current.now = { Current.calendar.date(from: .init(hour: 8, minute: 0))! }
 scheduler.advance(by: 1)

 Current.now = { Current.calendar.date(from: .init(hour: 22, minute: 30))! }
 scheduler.advance(by: 1)
}

///

let subscription = Current.api.signIn(.init(email: "123", password: "123")).sinkPrint()
