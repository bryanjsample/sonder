//
//  TokenError.swift
//  sonder
//
//  Created by Bryan Sample on 12/12/25.
//

enum TokenError: Error {
    case dataCastingError
    case dataEncodingError
    case dataDecodingError
    case tokenDidNotStore
    case tokenDidNotLoad
    case tokenDidNotClear
}
