//
//  ColourBoard.swift
//  GenerateTOTP
//
//  Created by Halil Kaya on 23.12.2021.
//

import Foundation
import SwiftUI

public struct ColourBoard<S: Shape>: ViewModifier {
    public var base: S
    public var color: Color
    public var brightness: Double
    public var innerSize: Double
    public var middleSize: Double?
    public var outerSize: Double?
    public var innerBlur: Double?
    public var blur: Double
    
    public func body(content: Content) -> some View {
        content
            .overlay(
                self.base
                    .stroke(self.color, lineWidth: CGFloat(self.innerSize))
                    .brightness(self.brightness)
                    .blur(radius: CGFloat(self.innerBlur ?? self.blur))
                    .allowsHitTesting(false)
            )
            .overlay(
                self.base
                    .stroke(self.color, lineWidth: CGFloat(self.middleSize ?? self.innerSize))
                    .brightness(self.brightness)
                    .allowsHitTesting(false)
            )
            .background(
                self.base
                    .stroke(self.color, lineWidth: CGFloat(self.outerSize ?? (self.middleSize ?? self.innerSize)))
                    .brightness(self.brightness)
                    .blur(radius: CGFloat(self.blur))
                    .allowsHitTesting(false)
            )
            .background(
                self.base
                    .stroke(self.color, lineWidth: CGFloat(self.outerSize ?? (self.middleSize ?? self.innerSize)))
                    .brightness(self.brightness)
                    .blur(radius: CGFloat(self.blur))
                    .opacity(0.2)
                    .allowsHitTesting(false)
            )
    }
}
