import PDFKit
import SwiftUI
import Combine

class PDFViewModel: ObservableObject {
    @Published var pdfDocument: PDFDocument?
    @Published var showingDocumentPicker = false
    @Published var documentTitle: String = "Document"
    @Published var recentPDFFiles: [URL] = []
    @Published var currentPageNumber: Int = 1
    @Published var pdfView: PDFView?
    
    
    
    @EnvironmentObject var currentInfo: CurrentPDFInfoStore
    
    private var fileManager = FileManager.default
    private let dataFileURL: URL
    var savedDocumentData: Data?
    
    init() {
        let libraryURL = fileManager.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        dataFileURL = libraryURL.appendingPathComponent("data.json")
        loadRecentPDFFiles()
        if pdfView == nil {
            print("was nill")
            pdfView = PDFView()
        }
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
                    } catch {
                        print("Error copying file: \(error.localizedDescription)")
                        return
                    }
                }
                
                let pdfInfo = PDFInfo(title: destinationURL.deletingPathExtension().lastPathComponent, url: destinationURL.absoluteString)
                if let existingPDFInfo = checkIfPDFExists(pdfInfo: pdfInfo) {
                    print("existing")
                    // Load the document from the recentPageNumber
                    pdfDocument = PDFDocument(url: destinationURL)
                    documentTitle = pdfInfo.title
                    
                    currentPageNumber = existingPDFInfo.recentPageNumber
                    print("Current page number is :\(currentPageNumber)")
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                    self.goToPage(self.currentPageNumber)
                       
                    }
                }
                else {
                    print("inside else for adding")
                    // Append new PDF details and update recentPageNumber
                    addFileToRecentList(destinationURL)
                    
                    appendPDFInfo(pdfInfo: pdfInfo)
                    pdfDocument = PDFDocument(url: destinationURL)
                    documentTitle = pdfInfo.title
                    //                        currentInfo.updatePDFInfo(with: pdfInfo)
                    updatePdfInfo()
                }
            }
        case .failure(let error):
            print("Failed to import file: \(error.localizedDescription)")
        }
    }
    
    func goToPage(_ pageNumber: Int) {
        var newPageNumber = 0
        print("inside go to page")
        guard let pdfView = pdfView else {
            print("pdfView is nil")
            return
        }
        guard let pdfDocument = pdfDocument else {
            print("pdfDocument is nil")
            return
        }
        newPageNumber = pageNumber-1==0 ? 0 :pageNumber
        if let page = pdfDocument.page(at: newPageNumber-1) {
            print("going to page")
            pdfView.go(to: page)
            print("gone to page")
        } else {
            print("Page number \(pageNumber) not found")
        }

    }
    
    func updatePdfInfo() {
        guard let pdfDocument = pdfDocument else {
            print("No PDF document is currently loaded.")
            return
        }
        print(currentPageNumber)
        var pdfInfos: [PDFInfo] = []
        if let data = try? Data(contentsOf: dataFileURL) {
            let decoder = JSONDecoder()
            pdfInfos = (try? decoder.decode([PDFInfo].self, from: data)) ?? []
        }
        
        if let index = pdfInfos.firstIndex(where: { $0.url == pdfDocument.documentURL?.absoluteString }) {
            var updatedPDFInfo = pdfInfos[index]
            updatedPDFInfo.recentPageNumber = currentPageNumber // Update with current page number
            pdfInfos[index] = updatedPDFInfo
            
            let encoder = JSONEncoder()
            if let data = try? encoder.encode(pdfInfos) {
                try? data.write(to: dataFileURL)
            }
        } else {
            print("PDF document not found in the list.")
        }
    }
    
    private func addFileToRecentList(_ url: URL) {
        if !recentPDFFiles.contains(url) {
            recentPDFFiles.append(url)
            saveRecentPDFFiles()
            print("inside addFilesTorecentList fn")
        }
    }
    private func saveRecentPDFFiles() {
        let urls = recentPDFFiles.map { $0.absoluteString }
        UserDefaults.standard.set(urls, forKey: "recentPDFFiles")
        print("inside saveRecentPDFFiles fn")
    }
    
    
    private func checkIfPDFExists(pdfInfo: PDFInfo) -> PDFInfo? {
        var pdfInfos: [PDFInfo] = []
        if let data = try? Data(contentsOf: dataFileURL) {
            let decoder = JSONDecoder()
            pdfInfos = (try? decoder.decode([PDFInfo].self, from: data)) ?? []
        }
        return pdfInfos.first { $0.url == pdfInfo.url }
    }
    
    private func appendPDFInfo(pdfInfo: PDFInfo) {
        var pdfInfos: [PDFInfo] = []
        if let data = try? Data(contentsOf: dataFileURL) {
            let decoder = JSONDecoder()
            pdfInfos = (try? decoder.decode([PDFInfo].self, from: data)) ?? []
        }
        pdfInfos.append(pdfInfo)
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(pdfInfos) {
            try? data.write(to: dataFileURL)
        }
    }
    
    private func loadRecentPDFFiles() {
        if let data = try? Data(contentsOf: dataFileURL) {
            let decoder = JSONDecoder()
            if let pdfInfos = try? decoder.decode([PDFInfo].self, from: data) {
                recentPDFFiles = pdfInfos.compactMap { URL(string: $0.url) }
            }
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

