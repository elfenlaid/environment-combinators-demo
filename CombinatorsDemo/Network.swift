//
//  Network.swift
//  CombinatorsDemo
//
//  Created by elfenlaid on 2021-10-20.
//

import Foundation

extension JSONEncoder {
  static let snakeCaseEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.keyEncodingStrategy = .convertToSnakeCase
    return encoder
  }()
}

extension JSONDecoder {
  static let snakeCaseDecoder: JSONDecoder = {
    let encoder = JSONDecoder()
    encoder.keyDecodingStrategy = .convertFromSnakeCase
    return encoder
  }()
}

extension URLRequest {
  static func makeJsonRequest<Payload: Codable>(endpoint: Endpoint, payload: Payload, encoder: JSONEncoder = .snakeCaseEncoder) -> URLRequest {
    var request = URLRequest(url: endpoint.url)

    request.httpMethod = endpoint.method
    request.httpBody = try! JSONEncoder.snakeCaseEncoder.encode(payload)
    request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

    return request
  }
}

enum Endpoint {
  case signIn
  case signOut

  var url: URL {
    switch self {
    case .signIn: return URL(string: "http://sketchql:4000/oauth/token")!
    case .signOut: return URL(string: "http://sketchql:4000/oauth/revoke")!
    }
  }

  var method: String {
    "POST"
  }
}

struct Credentials {
  var email: String
  var password: String
}

extension Credentials {
  static let editor = Credentials(email: "editor@example.com", password: "secret")
}

struct APISession: Codable {
  var accessToken: String
  var expiresIn: Int
  var refreshToken: String
  var tokenType: String
}

extension APISession: CustomStringConvertible {
  var description: String {
    """
    APISession:
      - access_token: \(accessToken.prefix(10))...
      - refresh_token: \(refreshToken)
      - token_type: \(tokenType)
      - expires_in: \(expiresIn)
    """
  }
}

extension APISession {
  static func stub(
    accessToken: String = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJTa2V0Y2giLCJleHAiOjE2MzQ3NDU3NzAsImZsYWdzIjpbIm9hdXRoIiwicHJlc2VuY2UtdjIiLCJjb2xsYWJvcmF0aXZlLWVkaXRpbmciXSwiaWF0IjoxNjM0NzQyMTcwLCJpc3MiOiJTa2V0Y2giLCJqdGkiOiIycW5zYWx1aTFra3ExcjFjNTgwMDE2NDEiLCJuYmYiOjE2MzQ3NDIxNzAsInNlcyI6IjU4YjAzYzgxLTliMjctNDVhMC04OTgzLWJlZjUxMmNjYWQzMCIsInN1YiI6IjFlMjExMDM1LTkwNmMtNGVmNC1hZDdlLTZhMjNmMWUzN2NhZiJ9.TCXzjwGqjpmoCDQKERL4xlHOnb9EcE4j15klbdkiyZxNrTauj9HjrtMKUxdWNMoGWAFAXGH8wkMQPVsclzOP1pIV5ErDpcaUKdT8IBI8Sg7B5JXExekSwbfh8_yy2likPzBESjmf1BVy-OuZpszRyQmASy-3hnsoduPQj5hkKPzSbTQdh-c-qSL-5MG5wK_SBjuQMOtiFmm4H78liu4V4ZJAJSnTsC3XMdMyv-owJzY9WLX9mckKDSq2wGAAx_u2mDJNLOg-OnkoNaw_G7-zZVyf5cwqRSu2fIxQrV-hBPNS_ajoPF36MXwrL2S6s3rpicJn5wuw7pLuxI_zUsVE9ZwLY2BY6-hTpebIqtWXH6eONT3CZGTfdHVjXnDOi2eHjrHWH8n93O2wKURvV2WbUdVOpHd3sqLCNfOwEoWICaKvnQ1X-G1Y_uF3GE9nQzl5UrcQPIuaK_DizOx5g7-9ETZ5mEhCfUMGsdt8L40QvN8mnDqwbz4NDd3d1B1xQGMgDISjhueQqzFpVLu8NtOXKLlPqnVKPHFg0YmZw5gM4MHiRmYZmDstmaxJuyz25Jk0h61CnGgqtNYblZxav-cn1s_epVYMvALcqIBiqdxMG0vFlerJRoCr5WWDF0GiyhtLAHzoXMs6H_9f__9puuVFVMsqau0LFp81MLyClz2usOw",
    expiresIn: Int = 3600,
    refreshToken: String = "67203ca0-ce72-4bac-ace3-c6b98bbdff69",
    tokenType: String = "bearer"
  ) -> APISession {
    APISession(accessToken: accessToken, expiresIn: expiresIn, refreshToken: refreshToken, tokenType: tokenType)
  }
}
