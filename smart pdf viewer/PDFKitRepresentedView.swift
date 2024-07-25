
import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    let pdfDocument: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true  // Disable auto scaling
//        pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit  // Set initial scale factor to fit width
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
    }

    static func dismantleUIView(_ uiView: PDFView, coordinator: Self.Coordinator) {
        uiView.document = nil
    }
}
//--above working



