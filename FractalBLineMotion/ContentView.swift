//
//  ContentView.swift
//  FractalBLineMotion
//
//  Created by Astemir Eleev on 11/6/24.
//

import SwiftUI

struct ContentView: View {
    private let start = Date()
    private let flineMotion = ShaderFunction(
        library: .default,
        name: "FractalBLineMotion::main"
    )
    
    @State private var time: CGFloat = 1.0
    @State private var spread: CGFloat = 0.85
    @State private var iterations: CGFloat = 5
    
    private let colors: [Float] = [
        1.0, 0.2, 0.0,
        0.0, 1.0, 0.3,
        0.7, 0.1, 1.0,
        0.0, 0.4, 1.0
    ]
    
    var body: some View {
        TimelineView(.animation) { context in
            Rectangle()
                .fill(.black)
                .colorEffect(
                    flineMotion(
                        .boundingRect,
                        .float(context.date.timeIntervalSince(start) * time),
                        .float(spread),
                        .float(iterations),
                        .floatArray(colors)
                    )
                )
        }
        .overlay(alignment: .bottom) {
            settings
                .padding(24)
                .preferredColorScheme(.dark)
        }
    }
    
    var settings: some View {
        GroupBox {
            VStack {
                slider(
                    for: $time,
                    in: 0.1...2,
                    step: 0.05,
                    named: "Time"
                )

                slider(
                    for: $spread,
                    in: 0.5...5,
                    step: 0.1,
                    named: "Spread"
                )
                
                slider(
                    for: $iterations,
                    in: 1...10,
                    step: 1,
                    named: "Iterations"
                )
            }
            .font(.footnote)
            .fontDesign(.monospaced)
        }
    }
    
    private func slider<T>(
        for binding: Binding<T>,
        in range: ClosedRange<T>,
        step: T,
        named name: String) -> some View where T: BinaryFloatingPoint & Strideable & _FormatSpecifiable, T.Stride: BinaryFloatingPoint {
        Slider(
            value: binding,
            in: range,
            step: T.Stride(step)
        )  {
            EmptyView()
        } minimumValueLabel: {
            Text(name)
        } maximumValueLabel: {
            label(for: binding.wrappedValue)
        }
    }
    
    private func label<T>(for value: T, specifierFLength: Int = 1) -> Text where T: BinaryFloatingPoint & _FormatSpecifiable {
        Text("\(value, specifier: "%.\(specifierFLength)f")")
    }
}


#Preview {
    ContentView()
        .ignoresSafeArea()
}
