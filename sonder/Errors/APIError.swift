//
//  APIError.swift
//  sonder
//
//  Created by Bryan Sample on 12/12/25.
//

import Foundation

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
    
    case undefinedServerBaseURL
    case invalidURL
    case invalidResponse
    
    
    var statusCode: Int? {
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
        default:
            return nil
        }
    }
}

extension HTTPURLResponse {
    func propagateError() throws {
        let successfulStatusCodes = [200, 201, 202]
        
        guard successfulStatusCodes.contains(self.statusCode) else {
            switch self.statusCode {
            case 400:
                throw APIError.badRequest
            case 401:
                throw APIError.unauthorized
            case 403:
                throw APIError.forbidden
            case 404:
                throw APIError.notFound
            case 405:
                throw APIError.methodNotAllowed
            case 406:
                throw APIError.notAcceptable
            case 408:
                throw APIError.requestTimeout
            case 409:
                throw APIError.conflict
            case 500:
                throw APIError.interalServerError
            case 501:
                throw APIError.notImplemented
            case 502:
                throw APIError.badGateway
            case 503:
                throw APIError.serviceUnavailable
            default:
                throw APIError.unexpectedErrorFromServer
            }
        }
    }
}
