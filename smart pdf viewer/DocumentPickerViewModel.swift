//import SwiftUI
//import PDFKit
//
//class DocumentPickerViewModel: ObservableObject {
//    @Published var pdfDocument: PDFDocument?
//    @Published var recentPDFFiles: [PDFFileInfo] = []  // Using a custom struct to hold file info
//
//    private var fileManager = FileManager.default
//
//    struct PDFFileInfo {
//        let url: URL
//        let title: String
//        // Add more properties as needed (e.g., author, creation date, etc.)
//    }
//
//    init() {
//        loadRecentPDFFiles()
//    }
//
////    func selectPDF() {
////        DocumentPickerController.shared.presentDocumentPicker { [weak self] urls in
////            guard let self = self else { return }
////            if let selectedURL = urls.first {
////                titlePrint(from: selectedURL)
////                self.loadPDF(from: selectedURL)
////                self.loadRecentPDFFiles() // Refresh the list of recent PDF files
////            }
////        }
////    }
//
//
//    func loadRecentPDFFiles() {
//        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//        let allFiles = (try? fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)) ?? []
//        recentPDFFiles = allFiles
//            .filter { $0.pathExtension == "pdf" }
//            .map { PDFFileInfo(url: $0, title: $0.lastPathComponent) }  // Example: Using lastPathComponent as title
//            .sorted(by: { $0.url.lastPathComponent > $1.url.lastPathComponent })
//    }
//
//    func loadPDF(from url: URL) {
//        pdfDocument = PDFDocument(url: url)
//        
//    }
//    func titlePrint(from url: URL){
//        print("hello world")
//        print("Selected PDF URL: \(url)")
//        print("PDF Title: \(url.lastPathComponent)")
//        
//    }
//}
