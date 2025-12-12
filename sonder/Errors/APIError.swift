//
//  APIError.swift
//  sonder
//
//  Created by Bryan Sample on 12/12/25.
//

enum APIError: Error {
    case badRequest // 400
    case unauthorized // 401
    case forbidden // 403
    case notFound // 404
    case methodNotAllowed // 405
    case notAcceptable // 406
    case requestTimeout // 408
    case conflict // 409
    case interalServerError // 500
    case notImplemented // 501
    case badGateway // 502
    case serviceUnavailable // 503
    case unexpectedErrorFromServer
    
    var statusCode: Int {
        switch self {
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .forbidden:
            return 403
        case .notFound:
            return 404
        case .methodNotAllowed:
            return 405
        case .notAcceptable:
            return 406
        case .requestTimeout:
            return 408
        case .conflict:
            return 409
        case .interalServerError:
            return 500
        case .notImplemented:
            return 501
        case .badGateway:
            return 502
        case .serviceUnavailable:
            return 503
        case .unexpectedErrorFromServer:
            return 0
        }
    }
}
