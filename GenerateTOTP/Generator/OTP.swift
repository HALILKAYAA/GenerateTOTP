//
//  OTP.swift
//  GenerateTOTP
//
//  Created by Halil Kaya on 22.12.2021.
//

import Foundation

public enum OtpEntry: Hashable {
    public static func == (lhs: OtpEntry, rhs: OtpEntry) -> Bool {
        switch (lhs, rhs) {
        case let (.hotp(lkey, ldigits, lcounter), .hotp(rkey, rdigits, rcounter)):
            return lkey == rkey && ldigits == rdigits && lcounter == rcounter
        case let (.totp(lkey, ldigits, linterval), .totp(rkey, rdigits, rinterval)):
            return lkey == rkey && ldigits == rdigits && linterval == rinterval
        default:
            return false
        }
    }
    
    case hotp(key: Data, digits: Int, counter: UInt64)
    case totp(key: Data, digits: Int, interval: Double)

    public mutating func code() -> UInt64 {
        switch self {
        case let .hotp(key, digits, counter):
            let code = hotpCode(key: key, digits: Double(digits), counter: counter)
            self = .hotp(key: key, digits: digits, counter: counter + 1)
            return code
        case let .totp(key, digits, interval):
            let counter = UInt64(Date().timeIntervalSince1970 / interval)
            return hotpCode(key: key, digits: Double(digits), counter: counter)
        }
    }

    public func get_display_value() -> Int {
        switch self {
        case let .hotp(_, _, counter):
            return Int(counter)
        case let .totp(_, _, interval):
            let time = Date().timeIntervalSince1970
            let nextUpdate = Double(ceil(time / interval) * interval)
            return Int((nextUpdate - time).rounded())
        }
    }
}
