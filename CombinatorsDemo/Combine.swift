//
//  MapToResult.swift
//  CombinatorsDemo
//
//  Created by elfenlaid on 2021-10-20.
//

import Combine
import Foundation

public struct FlakyError: Error {}

public extension Publisher {
  func mapToResult() -> AnyPublisher<Result<Output, Failure>, Never> {
    map(Result.success)
      .catch { Just(.failure($0)) }
      .eraseToAnyPublisher()
  }

  func sinkPrint() -> AnyCancellable {
    sink(receiveCompletion: {
      switch $0 {
      case .failure(let error):
        Swift.print("❌ \(error)")
      case .finished:
        Swift.print("🏁")
      }


    }, receiveValue: { Swift.print("✅ \($0)") })
  }
}

public extension Publisher where Failure == Error {
  func flaky() -> AnyPublisher<Output, Error> {
    flatMap { (value: Output) -> AnyPublisher<Output, Failure> in
      if Bool.random() {
        return Just(value).setFailureType(to: Failure.self).eraseToAnyPublisher()
      } else {
        return Fail(error: FlakyError() as Error).eraseToAnyPublisher()
      }
    }
    .eraseToAnyPublisher()
  }
}
