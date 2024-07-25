//import PDFKit
//import SwiftUI
//import UniformTypeIdentifiers
//import Combine
//class PDFViewModel: ObservableObject {
//    @Published var pdfDocument: PDFDocument?
//    @Published var showingDocumentPicker = false
//    @Published var documentTitle: String = "Document"
//    @Published var recentPDFFiles: [URL] = []
//
//    private var fileManager = FileManager.default
//
//    init() {
//        loadRecentPDFFiles()
//    }
//
//    func handleFileImport(result: Result<[URL], Error>) {
//        switch result {
//        case .success(let urls):
//            if let url = urls.first {
//                let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                let destinationURL = documentDirectory.appendingPathComponent(url.lastPathComponent)
//                
//                if !fileManager.fileExists(atPath: destinationURL.path) {
//                    do {
//                        try fileManager.copyItem(at: url, to: destinationURL)
//                        pdfDocument = PDFDocument(url: destinationURL)
//                        documentTitle = destinationURL.deletingPathExtension().lastPathComponent
//                        addFileToRecentList(destinationURL)
//                    } catch {
//                        print("Error copying file: \(error.localizedDescription)")
//                    }
//                } else {
//                    pdfDocument = PDFDocument(url: destinationURL)
//                    documentTitle = destinationURL.deletingPathExtension().lastPathComponent
//                }
//            }
//        case .failure(let error):
//            print("Failed to import file: \(error.localizedDescription)")
//        }
//    }
//
//    private func addFileToRecentList(_ url: URL) {
//        if !recentPDFFiles.contains(url) {
//            recentPDFFiles.append(url)
//            saveRecentPDFFiles()
//        }
//    }
//
//    private func saveRecentPDFFiles() {
//        let urls = recentPDFFiles.map { $0.absoluteString }
//        UserDefaults.standard.set(urls, forKey: "recentPDFFiles")
//    }
//
//    private func loadRecentPDFFiles() {
//        if let urls = UserDefaults.standard.array(forKey: "recentPDFFiles") as? [String] {
//            recentPDFFiles = urls.compactMap { URL(string: $0) }
//        }
//    }
//    
//}
//

//import PDFKit
//import SwiftUI
//import UniformTypeIdentifiers
//import Combine
//
//class PDFViewModel: ObservableObject {
//    @Published var pdfDocument: PDFDocument?
//    @Published var showingDocumentPicker = false
//    @Published var documentTitle: String = "Document"
//    @Published var recentPDFFiles: [URL] = []
//
//    private var fileManager = FileManager.default
//
//    init() {
//        loadRecentPDFFiles()
//    }
//
//    func handleFileImport(result: Result<[URL], Error>) {
//        switch result {
//        case .success(let urls):
//            if let url = urls.first {
//                let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                let destinationURL = documentDirectory.appendingPathComponent(url.lastPathComponent)
//                
//                if !fileManager.fileExists(atPath: destinationURL.path) {
//                    do {
//                        try fileManager.copyItem(at: url, to: destinationURL)
//                        pdfDocument = PDFDocument(url: destinationURL)
//                        documentTitle = destinationURL.deletingPathExtension().lastPathComponent
//                        addFileToRecentList(destinationURL)
//                    } catch {
//                        print("Error copying file: \(error.localizedDescription)")
//                    }
//                } else {
//                    pdfDocument = PDFDocument(url: destinationURL)
//                    documentTitle = destinationURL.deletingPathExtension().lastPathComponent
//                }
//            }
//        case .failure(let error):
//            print("Failed to import file: \(error.localizedDescription)")
//        }
//    }
//
//    private func addFileToRecentList(_ url: URL) {
//        if !recentPDFFiles.contains(url) {
//            recentPDFFiles.append(url)
//            saveRecentPDFFiles()
//        }
//    }
//
//    private func saveRecentPDFFiles() {
//        let urls = recentPDFFiles.map { $0.absoluteString }
//        UserDefaults.standard.set(urls, forKey: "recentPDFFiles")
//    }
//
//    private func loadRecentPDFFiles() {
//        if let urls = UserDefaults.standard.array(forKey: "recentPDFFiles") as? [String] {
//            recentPDFFiles = urls.compactMap { URL(string: $0) }
//        }
//    }
//}
import PDFKit
import SwiftUI
import Combine

class PDFViewModel: ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var showingDocumentPicker = false
    @Published var documentTitle: String = "Document"
    @Published var recentPDFFiles: [URL] = []

    private var fileManager = FileManager.default
    var savedDocumentData: Data?

    init() {
        loadRecentPDFFiles()
    }

    func handleFileImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destinationURL = documentDirectory.appendingPathComponent(url.lastPathComponent)
                
                if !fileManager.fileExists(atPath: destinationURL.path) {
                    do {
                        try fileManager.copyItem(at: url, to: destinationURL)
                        pdfDocument = PDFDocument(url: destinationURL)
                        documentTitle = destinationURL.deletingPathExtension().lastPathComponent
                        addFileToRecentList(destinationURL)
                    } catch {
                        print("Error copying file: \(error.localizedDescription)")
                    }
                } else {
                    pdfDocument = PDFDocument(url: destinationURL)
                    documentTitle = destinationURL.deletingPathExtension().lastPathComponent
                }
            }
        case .failure(let error):
            print("Failed to import file: \(error.localizedDescription)")
        }
    }

    private func addFileToRecentList(_ url: URL) {
        if !recentPDFFiles.contains(url) {
            recentPDFFiles.append(url)
            saveRecentPDFFiles()
        }
    }

    private func saveRecentPDFFiles() {
        let urls = recentPDFFiles.map { $0.absoluteString }
        UserDefaults.standard.set(urls, forKey: "recentPDFFiles")
    }

    private func loadRecentPDFFiles() {
        if let urls = UserDefaults.standard.array(forKey: "recentPDFFiles") as? [String] {
            recentPDFFiles = urls.compactMap { URL(string: $0) }
        }
    }

    func saveDocument() {
        guard let pdfDocument = pdfDocument else { return }
        savedDocumentData = pdfDocument.dataRepresentation()
    }

    func loadDocument(from data: Data) {
        pdfDocument = PDFDocument(data: data)
    }
}



//import PDFKit
//import SwiftUI
//import Combine
//
//class PDFViewModel: ObservableObject {
//    @Published var pdfDocument: PDFDocument?
//    @Published var showingDocumentPicker = false
//    @Published var documentTitle: String = "Document"
//    @Published var recentPDFFiles: [URL] = []
//
//    private var fileManager = FileManager.default
//    private let dataFileURL: URL
//    var savedDocumentData: Data?
//
//    init() {
//        // Initialize the URL for data.json in the Library directory
//        let libraryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
//        dataFileURL = libraryURL.appendingPathComponent("data.json")
//        loadRecentPDFFiles()
//    }
//
//    func handleFileImport(result: Result<[URL], Error>) {
//        switch result {
//        case .success(let urls):
//            if let url = urls.first {
//                let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                let destinationURL = documentDirectory.appendingPathComponent(url.lastPathComponent)
//                
//                if !fileManager.fileExists(atPath: destinationURL.path) {
//                    do {
//                        try fileManager.copyItem(at: url, to: destinationURL)
//                    } catch {
//                        print("Error copying file: \(error.localizedDescription)")
//                        return
//                    }
//                }
//                
//                let pdfInfo = PDFInfo(title: destinationURL.deletingPathExtension().lastPathComponent, url: destinationURL.absoluteString)
//                if let existingPDFInfo = checkIfPDFExists(pdfInfo: pdfInfo) {
//                    // Load the document from the recentPageNumber
//                    pdfDocument = PDFDocument(url: destinationURL)
//                    documentTitle = pdfInfo.title
//                    let pdfView=PDFView()
//                    if let recentPage = pdfDocument?.page(at: existingPDFInfo.recentPageNumber - 1) {
//                        pdfView.go(to: recentPage)
//                    }
////                    let recentPage = pdfDocument?.page(at: existingPDFInfo.recentPageNumber - 1)
////                    pdfDocument?.go(to: recentPage)
//                } else {
//                    // Append new PDF details and update recentPageNumber
//                    appendPDFInfo(pdfInfo: pdfInfo)
//                    pdfDocument = PDFDocument(url: destinationURL)
//                    documentTitle = pdfInfo.title
//                }
//            }
//        case .failure(let error):
//            print("Failed to import file: \(error.localizedDescription)")
//        }
//    }
//
//    private func checkIfPDFExists(pdfInfo: PDFInfo) -> PDFInfo? {
//        var pdfInfos: [PDFInfo] = []
//        if let data = try? Data(contentsOf: dataFileURL) {
//            let decoder = JSONDecoder()
//            pdfInfos = (try? decoder.decode([PDFInfo].self, from: data)) ?? []
//        }
//        return pdfInfos.first { $0.url == pdfInfo.url }
//    }
//
//    private func appendPDFInfo(pdfInfo: PDFInfo) {
//        var pdfInfos: [PDFInfo] = []
//        if let data = try? Data(contentsOf: dataFileURL) {
//            let decoder = JSONDecoder()
//            pdfInfos = (try? decoder.decode([PDFInfo].self, from: data)) ?? []
//        }
//        pdfInfos.append(pdfInfo)
//        let encoder = JSONEncoder()
//        if let data = try? encoder.encode(pdfInfos) {
//            try? data.write(to: dataFileURL)
//        }
//    }
//
//    private func loadRecentPDFFiles() {
//        if let data = try? Data(contentsOf: dataFileURL) {
//            let decoder = JSONDecoder()
//            if let pdfInfos = try? decoder.decode([PDFInfo].self, from: data) {
//                recentPDFFiles = pdfInfos.compactMap { URL(string: $0.url) }
//            }
//        }
//    }
//
//    func saveDocument() {
//        guard let pdfDocument = pdfDocument else { return }
//        savedDocumentData = pdfDocument.dataRepresentation()
//    }
//
//    func loadDocument(from data: Data) {
//        pdfDocument = PDFDocument(data: data)
//    }
//}
