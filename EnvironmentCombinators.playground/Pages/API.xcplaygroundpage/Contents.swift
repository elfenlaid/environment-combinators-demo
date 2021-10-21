@testable import CombinatorsDemo
import Combine
import Foundation
import CombineSchedulers
import XCTestDynamicOverlay






struct APIClient {
  var signIn: (Credentials) -> AnyPublisher<APISession, Error>
  var signOut: (APISession) -> AnyPublisher<Void, Error>
}


































extension APIClient {
  static let live: APIClient = {
    APIClient(
      signIn: { credentials in
        struct SignInPayload: Codable {
          var email: String
          var password: String
          var grantType: String = "password"

          init(credentials: Credentials) {
            self.email = credentials.email
            self.password = credentials.password
          }
        }

        let request = URLRequest.makeJsonRequest(endpoint: .signIn, payload: SignInPayload(credentials: credentials))

        return URLSession.shared
          .dataTaskPublisher(for: request)
          .map(\.data)
          .decode(type: APISession.self, decoder: JSONDecoder.snakeCaseDecoder)
          .eraseToAnyPublisher()
      },
      signOut: { session in
        struct SignOutPayload: Codable {
          var token: String
          var tokenTypeHint: String = "access_token"

          init(session: APISession) {
            self.token = session.accessToken
          }
        }

        let request = URLRequest.makeJsonRequest(endpoint: .signOut, payload: SignOutPayload(session: session))

        return URLSession.shared
          .dataTaskPublisher(for: request)
          .map { _ in () }
          .mapError { $0 }
          .eraseToAnyPublisher()
      }
    )
  }()
}


























extension APIClient {
  static let happyPath = APIClient(
    signIn: { _ in Just(.stub()).setFailureType(to: Error.self).eraseToAnyPublisher() },
    signOut: { _ in Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
  )

  struct IntentionalFail: Error {}

  static let failing = APIClient(
    signIn: { _ in Fail(error: IntentionalFail()).eraseToAnyPublisher() },
    signOut: { _ in Fail(error:IntentionalFail()).eraseToAnyPublisher() }
  )

  func delayed() -> APIClient {
    APIClient(
      signIn: {
        self.signIn($0).delay(for: .seconds(3), scheduler: RunLoop.main).eraseToAnyPublisher()
      },
      signOut: {
        self.signOut($0).delay(for: .seconds(3), scheduler: RunLoop.main).eraseToAnyPublisher()
      }
    )
  }

  func flaky() -> APIClient {
    return APIClient(
      signIn: {
        self.signIn($0).flaky()
      },
      signOut: {
        self.signOut($0).flaky()
      }
    )
  }
}




























struct World {
  var api = APIClient.happyPath.flaky()
}

var Current = World()

let subscription = Current.api.signIn(.editor).print("network").sinkPrint()
