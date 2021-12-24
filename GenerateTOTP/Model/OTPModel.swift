//
//  OTPModel.swift
//  GenerateTOTP
//
//  Created by Halil Kaya on 21.12.2021.
//

import Foundation

public struct OtpModel: Identifiable, Hashable {
    public static func == (lhs: OtpModel, rhs: OtpModel) -> Bool {
        lhs.id == rhs.id || (lhs.issuer == rhs.issuer && lhs.name == rhs.name && lhs.entry == rhs.entry)
    }
    
    public let id = UUID()
    public var issuer: String?
    public var name: String?
    public var entry: OtpEntry

    public init(issuer: String? = nil, name: String? = nil, entry: OtpEntry) {
        self.issuer = issuer
        self.name = name
        self.entry = entry
    }
}
