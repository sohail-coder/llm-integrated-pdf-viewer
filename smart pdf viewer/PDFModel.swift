//import Foundation
//import PDFKit
//
//class PDFModel: ObservableObject {
//    @Published var pdfDocument: PDFDocument?
//    
//    func loadPDF(from url: URL) {
//        if url.startAccessingSecurityScopedResource() {
//            pdfDocument = PDFDocument(url: url)
//            url.stopAccessingSecurityScopedResource()
//        }
//    }
//}
