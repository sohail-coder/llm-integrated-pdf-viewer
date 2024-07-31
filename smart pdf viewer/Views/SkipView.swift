//
//  SkipView.swift
//  smart pdf viewer
//
//  Created by sohail shaik on 7/29/24.
//
import SwiftUI

struct SkipView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Skipped")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
    }
}

#Preview {
    SkipView()
}
