import SwiftUI
import PDFKit

struct PDFDetailView: View {
    @ObservedObject var pdfViewModel: PDFViewModel  // Observe changes in PDFViewModel
    
    @State private var isSearchBarVisible = false
    @State private var searchText = ""
    @State private var showChip = false
    
    private var documentTitle: String {
        let title = pdfViewModel.documentTitle
        return title.count > 10 ? String(title.prefix(10)) + "..." : title
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                PDFKitRepresentedView(pdfDocument: pdfViewModel.pdfDocument!)
                    .edgesIgnoringSafeArea(.all)
                if isSearchBarVisible {
                    HStack {
                        TextField("Search", text: $searchText, onCommit: {
                            searchInPDF()
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button {
                            isSearchBarVisible.toggle()
                            searchText = ""
                            removeHighlights()
                        } label: {
                            Image(systemName: "xmark.circle")
                        }
                    }
                    .padding()
                }
                VStack {
                    if showChip {
                        Text("No Results Found").bold()
                            .padding()
                            .background(.blackWhite.opacity(0.8))
                            .foregroundColor(.whiteBlack)
                            .cornerRadius(8)
                            .padding(.top, 10) // Adjust the position relative to the toolbar
                            .transition(.opacity) // Fade-in and fade-out transition
                            .animation(.easeInOut(duration: 0.8), value: showChip)
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitle(documentTitle, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isSearchBarVisible.toggle()
                    } label: {
                        Image(systemName: "doc.text.magnifyingglass")
                    }
                }
            }
        }
    }
    
    private func searchInPDF() {
        guard let pdfDocument = pdfViewModel.pdfDocument else { return }
        removeHighlights()
        
        let selections = pdfDocument.findString(searchText, withOptions: [.caseInsensitive])
        if selections.isEmpty {
            showChip = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                showChip = false
            }
        } else {
            selections.forEach { selection in
                selection.pages.forEach { page in
                    let highlight = PDFAnnotation(bounds: selection.bounds(for: page), forType: .highlight, withProperties: nil)
                    highlight.endLineStyle = .square
                    highlight.color = UIColor.orange.withAlphaComponent(0.5)
                    
                    page.addAnnotation(highlight)
                }
            }
        }
    }
    
    private func removeHighlights() {
        guard let pdfDocument = pdfViewModel.pdfDocument else { return }
        
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex) {
                let annotations = page.annotations
                for annotation in annotations {
                    if annotation.type == Optional("Highlight") {
                        page.removeAnnotation(annotation)
                        
                    }
                }
            }
        }
    }
    class Coordinator: NSObject, PDFViewDelegate {
           var parent: PDFKitRepresentedView

           init(_ parent: PDFKitRepresentedView) {
               self.parent = parent
           }

           func pdfViewWillChangePage(_ pdfView: PDFView) {
               if let currentPage = pdfView.currentPage,
                  let pageIndex = pdfView.document?.index(for: currentPage) {
                   print(pageIndex)
               }
           }
       }
}



