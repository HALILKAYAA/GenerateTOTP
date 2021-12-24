//
//  AddingPageView.swift
//  GenerateTOTP
//
//  Created by Halil Kaya on 22.12.2021.
//

import Foundation
import SwiftUI

public struct AddingPageView: View {
    @Binding public var accounts: [OtpModel]
    @Binding public var addingAccount: Bool
    @State private var issuer: String = ""
    @State private var name: String = ""
    @State private var key: String = ""
    @State private var digits = 6
    @State private var interval = 30
    @State private var counter = 0
    @State private var isHotp = false
    @State private var numberFormatter: NumberFormatter = {
        var formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
    private let backgroundColor = Color(UIColor.systemFill)
    private let textColor = Color(UIColor.label)
    private let disabledColor = Color(UIColor.placeholderText)

    public var body: some View {
        VStack {
            ZStack {
                VStack {
                    Picker(selection: $isHotp, label: EmptyView()) {
                        Text("TOTP").tag(false)
                        Text("HOTP").tag(true)
                    }.pickerStyle(SegmentedPickerStyle())
                    SecureField("OTP Key", text: $key)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    if self.isHotp {
                        Stepper(
                            onIncrement: {
                                counter += 1
                            },
                            onDecrement: {
                                counter = max(counter - 1, 0)
                            },
                            label: {
                                Text("Counter: \(counter)")
                            }
                        )
                    } else {
                        Stepper(
                            onIncrement: {
                                interval += 1
                            },
                            onDecrement: {
                                interval = max(interval - 1, 1)
                            },
                            label: {
                                Text("\(interval) seconds")
                            }
                        )
                    }
                    Stepper(
                        onIncrement: {
                            digits = min(digits + 1, 10)
                            numberFormatter.minimumIntegerDigits = digits
                        },
                        onDecrement: {
                            digits = max(digits - 1, 6)
                            numberFormatter.minimumIntegerDigits = digits
                        },
                        label: { () -> AnyView in
                            numberFormatter.minimumIntegerDigits = digits
                            return AnyView(Text(numberFormatter.string(from: 0) ?? "\(digits) digits"))
                        }
                    )
                }
                .padding(10)
            }
            .modifier(
                ColourBoard(
                    base: RoundedRectangle(cornerRadius: 5),
                    color: Color.gray,
                    brightness: 0.025,
                    innerSize: 2,
                    middleSize: 3,
                    outerSize: 5,
                    innerBlur: 0,
                    blur: 5
                )
            )
            Divider().padding(.vertical, 5)
            ZStack {
                VStack {
                    TextField("Issuer", text: $issuer)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Account Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }.padding(10)
            }.modifier(
                ColourBoard(
                    base: RoundedRectangle(cornerRadius: 5),
                    color: Color.gray,
                    brightness: 0.025,
                    innerSize: 2,
                    middleSize: 3,
                    outerSize: 5,
                    innerBlur: 0,
                    blur: 5
                )
            )
            Divider().padding(.vertical, 5)
            HStack {
                Button(action: {
                    let issuer = self.issuer.trimmingCharacters(in: .whitespacesAndNewlines)
                    let name = self.name.trimmingCharacters(in: .whitespacesAndNewlines)
                    var entry: OtpEntry
                    if self.isHotp {
                        entry = .hotp(
                            key: self.key.trimmingCharacters(in: .whitespacesAndNewlines).data(using: .utf8)!,
                            digits: self.digits,
                            counter: UInt64(self.counter)
                        )
                    } else {
                        entry = .totp(
                            key: self.key.trimmingCharacters(in: .whitespacesAndNewlines).data(using: .utf8)!,
                            digits: self.digits,
                            interval: Double(self.interval)
                        )
                    }
                    withAnimation(Animation.easeInOut(duration: 1)) {
                        self.accounts.append(OtpModel(
                            issuer: issuer.isEmpty ? nil : issuer,
                            name: name.isEmpty ? nil : name,
                            entry: entry
                        ))
                    }
                    self.addingAccount = false
                }, label: {
                    Text("Add")
                        .foregroundColor(textColor)
                        .opacity(key.isEmpty || interval < 1 || digits < 6 || digits > 10 ? 0.25 : 1.0)
                        .padding()
                })
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(backgroundColor.overlay(Color.green.opacity(0.75)).blendMode(.hardLight))
                    .disabled(key.isEmpty || interval < 1 || digits < 6 || digits > 10)
                    .cornerRadius(15)
                    .modifier(ColourBoard(
                        base: RoundedRectangle(cornerRadius: 15),
                        color: .green,
                        brightness: 0.1,
                        innerSize: 1,
                        middleSize: 2,
                        outerSize: 4,
                        blur: 5
                    )).padding(.horizontal, 5)

                Button(action: {
                    self.addingAccount = false
                }, label: {
                    Text("Cancel")
                        .foregroundColor(textColor)
                        .padding()
                })
                    .buttonStyle(BorderlessButtonStyle())
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(backgroundColor.overlay(Color.red.opacity(0.75)).blendMode(.hardLight))
                    .cornerRadius(15)
                    .modifier(
                        ColourBoard(
                            base: RoundedRectangle(cornerRadius: 15),
                            color: .red,
                            brightness: 0.1,
                            innerSize: 1,
                            middleSize: 2,
                            outerSize: 4,
                            blur: 5
                        )
                    ).padding(.horizontal, 5)
            }
        }.padding()
    }
}
