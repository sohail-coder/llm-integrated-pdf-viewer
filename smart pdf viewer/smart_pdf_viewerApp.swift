//
//  Samrt_PDF_ViewerApp.swift
//  Samrt PDF Viewer
//
//  Created by sohail shaik on 7/15/24.

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                  if let error = error {
                      print("Failed to restore previous sign-in: \(error)")
                  } else if let user = user {
                      print("Successfully restored sign-in for user: \(user)")
                  }
              }
              return true
  }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}


@main
struct Smart_PDF_ViewerApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    
    
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var pdfViewModel = PDFViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    init() {
        configureNavigationBarAppearance()
        createDataJSONIfNeeded()

    }

    var body: some Scene {
        
            WindowGroup {
//                ContentView(viewModel: pdfViewModel)
                if authViewModel.isSignedIn {
                                ContentView(viewModel: pdfViewModel)
                                    .environmentObject(authViewModel)
                            } else {
                                SignInView()
                                    .environmentObject(authViewModel)
                            }
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .background, .inactive:
                    print("Background")
                    pdfViewModel.saveDocument()
                    pdfViewModel.updatePdfInfo()
                
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
