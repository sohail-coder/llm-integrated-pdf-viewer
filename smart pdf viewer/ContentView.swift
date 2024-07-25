//import SwiftUI
//import PDFKit
//
//struct ContentView: View {
//    @ObservedObject var viewModel: PDFViewModel
//    @State private var shouldNavigate = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                Text("Select a PDF to display")
//                    .foregroundColor(.gray)
//            }
//            .navigationBarTitle("PDF Viewer", displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                viewModel.showingDocumentPicker.toggle()
//            }) {
//                Image(systemName: "doc")
//            })
//            .fileImporter(
//                isPresented: $viewModel.showingDocumentPicker,
//                allowedContentTypes: [.pdf],
//                allowsMultipleSelection: false
//            ) { result in
//                viewModel.handleFileImport(result: result)
//                if viewModel.pdfDocument != nil {
//                    shouldNavigate = true
//                }
//            }.navigationDestination(
//                isPresented: $shouldNavigate) {
//                    PDFDetailView(pdfViewModel: viewModel)
//                    
//                }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(viewModel: PDFViewModel())
//    }
//}
//

//--working fine above

//import SwiftUI
//import PDFKit
//
//struct ContentView: View {
//    @ObservedObject var viewModel: PDFViewModel
//    @State private var shouldNavigate = false
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                if viewModel.recentPDFFiles.isEmpty {
//                    Text("Select a PDF to display")
//                        .foregroundColor(.gray)
//                } else {
//                    Section(header: Text("Recently Visited PDFs")){
//                        List(viewModel.recentPDFFiles, id: \.self) { url in
//                            Button(action: {
//                                viewModel.pdfDocument = PDFDocument(url: url)
//                                viewModel.documentTitle = url.deletingPathExtension().lastPathComponent
//                                shouldNavigate = true
//                            }) {
//                                Text(url.deletingPathExtension().lastPathComponent)
//                            }
//                        }
//                    }
//
//
//                }
//            }
//            .navigationBarTitle("PDF Viewer", displayMode: .inline)
//            .navigationBarItems(trailing: Button(action: {
//                viewModel.showingDocumentPicker.toggle()
//            }) {
//                Image(systemName: "doc")
//            })
//            .fileImporter(
//                isPresented: $viewModel.showingDocumentPicker,
//                allowedContentTypes: [.pdf],
//                allowsMultipleSelection: false
//            ) { result in
//                viewModel.handleFileImport(result: result)
//                if viewModel.pdfDocument != nil {
//                    shouldNavigate = true
//                }
//            }
//            .navigationDestination(
//                isPresented: $shouldNavigate) {
//                    PDFDetailView(pdfViewModel: viewModel)
//                }
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(viewModel: PDFViewModel())
//    }
//}
//
//working with recently added pdf's


import SwiftUI
import PDFKit

struct ContentView: View {
    @ObservedObject var viewModel: PDFViewModel
    @State private var shouldNavigate = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Recently Visited PDFs")) {
                    if viewModel.recentPDFFiles.isEmpty {
                        Text("No recent PDFs")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.recentPDFFiles, id: \.self) { url in
                            Button(action: {
                                viewModel.pdfDocument = PDFDocument(url: url)
                                viewModel.documentTitle = url.deletingPathExtension().lastPathComponent
                                shouldNavigate = true
                            }) {
                                Text(url.lastPathComponent)
                            }
                        }
                    }
                }
                if viewModel.recentPDFFiles.isEmpty{
                    Section {
                        Button(action: {
                            viewModel.showingDocumentPicker.toggle()
                        }) {
                            HStack {
                                Image(systemName: "doc")
                                Text("Select a PDF to display")
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle("PDF Viewer", displayMode: .inline)
            .navigationBarItems(trailing: viewModel.recentPDFFiles.isEmpty ? nil : Button(action: {
                            viewModel.showingDocumentPicker.toggle()
                        }) {
                            Image(systemName: "doc.badge.plus")
                        })
            .fileImporter(
                isPresented: $viewModel.showingDocumentPicker,
                allowedContentTypes: [.pdf],
                allowsMultipleSelection: false
            ) { result in
                viewModel.handleFileImport(result: result)
                if viewModel.pdfDocument != nil {
                    shouldNavigate = true
                }
            }
            .navigationDestination(
                isPresented: $shouldNavigate) {
                    PDFDetailView(pdfViewModel: viewModel)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: PDFViewModel())
    }
}

