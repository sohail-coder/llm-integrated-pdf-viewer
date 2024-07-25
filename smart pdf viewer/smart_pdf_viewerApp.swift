//
//  Samrt_PDF_ViewerApp.swift
//  Samrt PDF Viewer
//
//  Created by sohail shaik on 7/15/24.

import SwiftUI

@main
struct Smart_PDF_ViewerApp: App {
    init() {
        configureNavigationBarAppearance()
    }

    @StateObject private var viewModel = DocumentPickerViewModel()

    var body: some Scene {
            WindowGroup {
                ContentView(viewModel: PDFViewModel())
            }
        }

    private func configureNavigationBarAppearance() {
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithOpaqueBackground()
        coloredNavAppearance.backgroundColor = .systemBackground
        coloredNavAppearance.titleTextAttributes = [
                        .foregroundColor: UIColor.blackWhite,
                        .font: UIFont.systemFont(ofSize: 20, weight: .bold)
                    ]
                    coloredNavAppearance.largeTitleTextAttributes = [
                        .foregroundColor: UIColor.blackWhite,
                        .font: UIFont.systemFont(ofSize: 34, weight: .bold)
                    ]
        
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        UINavigationBar.appearance().compactAppearance = coloredNavAppearance
    }
}
extension Color {
    static let textColor = Color("BlackWhite")
}

extension UIColor {
    static let textColor = UIColor(named: "BlackWhite")!
}
