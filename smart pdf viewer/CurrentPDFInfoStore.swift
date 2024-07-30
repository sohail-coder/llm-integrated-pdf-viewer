//
//  CurrentPDFInfoStore.swift
//  smart pdf viewer
//
//  Created by sohail shaik on 7/25/24.
//

import Foundation
import Combine

class CurrentPDFInfoStore: ObservableObject {
    @Published var currentPDFInfo: PDFInfo?
    
    func updatePDFInfo(with pdfInfo: PDFInfo) {
        self.currentPDFInfo = pdfInfo
    }
}
