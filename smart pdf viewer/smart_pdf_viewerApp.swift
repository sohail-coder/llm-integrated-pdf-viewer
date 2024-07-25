//
//  Samrt_PDF_ViewerApp.swift
//  Samrt PDF Viewer
//
//  Created by sohail shaik on 7/15/24.

import SwiftUI

@main
struct Smart_PDF_ViewerApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var pdfViewModel = PDFViewModel()
    init() {
        configureNavigationBarAppearance()
        createDataJSONIfNeeded()

    }

//    @StateObject private var viewModel = DocumentPickerViewModel()

    var body: some Scene {
            WindowGroup {
                ContentView(viewModel: pdfViewModel)
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .background:
                    print("Background")
                    pdfViewModel.saveDocument()
                case .inactive:
                    print("Inactive")
                case .active:
                    print("Active")
                    if let data = pdfViewModel.savedDocumentData {
                        pdfViewModel.loadDocument(from: data)
                    }
                @unknown default:
                    print("Unknown")
                }
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
    private func createDataJSONIfNeeded() {
            let fileManager = FileManager.default
            let libraryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            let dataFileURL = libraryURL.appendingPathComponent("data.json")

            if !fileManager.fileExists(atPath: dataFileURL.path) {
                // Create the data.json file
                createDataJSONInLibraryDirectory()
            }
        }

        private func createDataJSONInLibraryDirectory() {
            let fileManager = FileManager.default
            let libraryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            let dataFileURL = libraryURL.appendingPathComponent("data.json")

            // Sample PDFInfo data
            let pdfInfo = PDFInfo.sampleData()

            do {
                let jsonData = try JSONEncoder().encode(pdfInfo)
                try jsonData.write(to: dataFileURL)
                print("Data.json created at: \(dataFileURL)")
            } catch {
                print("Error creating data.json: \(error)")
            }
        }

}
extension Color {
    static let textColor = Color("BlackWhite")
}

extension UIColor {
    static let textColor = UIColor(named: "BlackWhite")!
}
