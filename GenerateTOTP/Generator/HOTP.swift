//
//  HOTP.swift
//  GenerateTOTP
//
//  Created by Halil Kaya on 22.12.2021.
//

import Foundation
import Combine
import CryptoKit

//implementation of RFC 4226.
//explaination on Wikipedia: https://en.wikipedia.org/wiki/HMAC-based_One-Time_Password
public func hotpCode(key: Data, digits: Double = 6, counter: UInt64) -> UInt64 {
    let counterBytes = withUnsafeBytes(of: counter.bigEndian, Array.init)
    assert(counterBytes.count == 8)
    let digest = Data(HMAC<Insecure.SHA1>.authenticationCode(for: counterBytes, using: SymmetricKey(data: key)))
    let i = digest.last! % 16
    let truncated = digest[i ..< i + 4]
    var code: UInt32 = 0
    assert(withUnsafeMutableBytes(of: &code) { truncated.copyBytes(to: $0) } == MemoryLayout.size(ofValue: code))
    return UInt64(code % UInt32(pow(2.0, 31))) % UInt64(pow(10, Double(digits)))
}
