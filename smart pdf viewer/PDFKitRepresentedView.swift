import SwiftUI
import PDFKit

struct PDFKitRepresentedView: UIViewRepresentable {
    var pdfDocument: PDFDocument
    @Binding var currentPageNumber: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true

        // Set up notification observer
        NotificationCenter.default.addObserver(
            context.coordinator,
            selector: #selector(Coordinator.pageChangedNotification(_:)),
            name: .PDFViewPageChanged,
            object: pdfView
        )
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
        if let page = pdfDocument.page(at: currentPageNumber - 1) {
            pdfView.go(to: page)
        }
    }
    
    static func dismantleUIView(_ uiView: PDFView, coordinator: Coordinator) {
        // Remove the observer when the view is dismantled
        NotificationCenter.default.removeObserver(coordinator, name: .PDFViewPageChanged, object: uiView)
    }
    
    class Coordinator: NSObject {
        var parent: PDFKitRepresentedView

        init(_ parent: PDFKitRepresentedView) {
            self.parent = parent
        }
        
        @objc func pageChangedNotification(_ notification: Notification) {
            guard let pdfView = notification.object as? PDFView,
                  let currentPage = pdfView.currentPage else { return }
            
            let pageIndex = pdfView.document?.index(for: currentPage) ?? 0
            DispatchQueue.main.async {
                self.parent.currentPageNumber = pageIndex + 1
//                print("Current Page: \(self.parent.currentPageNumber)")
            }
        }
    }
}
