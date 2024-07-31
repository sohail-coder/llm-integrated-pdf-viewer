import SwiftUI
import PDFKit

struct ContentView: View {
    @ObservedObject var viewModel: PDFViewModel
    @State private var shouldNavigate = false
    @StateObject var currentInfo = CurrentPDFInfoStore()
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
            .navigationBarItems(
                leading: Button(action: {
                    // Action for the exit button
                    authViewModel.signOut()
                }) {
                    Image(systemName: "rectangle.portrait.and.arrow.forward")
                },
                trailing: viewModel.recentPDFFiles.isEmpty ? nil : Button(action: {
                    viewModel.showingDocumentPicker.toggle()
                }) {
                    Image(systemName: "doc.badge.plus")
                }
            )

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
        .environmentObject(currentInfo)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: PDFViewModel())
    }
}

