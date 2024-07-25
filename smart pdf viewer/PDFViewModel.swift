
//import SwiftUI
//import PDFKit
//import UniformTypeIdentifiers
//
//class PDFViewModel: ObservableObject {
//    @Published var pdfDocument: PDFDocument?
//    @Published var showingDocumentPicker = false
//    @Published var documentTitle: String = "Document"
//
//    func handleFileImport(result: Result<[URL], Error>) {
//        switch result {
//        case .success(let urls):
//            if let url = urls.first {
//                pdfDocument = PDFDocument(url: url)
//                
//                documentTitle =   URL(fileURLWithPath: url.lastPathComponent).deletingPathExtension().lastPathComponent // Set documentTile to file name
//            }
//        case .failure(let error):
//            print("Failed to import file: \(error.localizedDescription)")
//        }
//    }
//}

//above working----------------------------------------------------------------------------------------------------------------------------

import PDFKit
import SwiftUI
import UniformTypeIdentifiers

class PDFViewModel: ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var showingDocumentPicker = false
    @Published var documentTitle: String = "Document"
    @Published var recentPDFFiles: [URL] = []

    private var fileManager = FileManager.default

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
    
    func updatePageNumber(for pdfDetail: PDFDetails, pageNumber: Int) {
//            if let index = recentPDFs.firstIndex(where: { $0.id == pdfDetail.id }) {
//                recentPDFs[index].pageNumber = pageNumber
//                saveRecentPDFs()
//            }
        print(pageNumber)
        }
}

