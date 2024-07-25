//
//  DocumentPickerController.swift
//  smart pdf viewer
//
//  Created by sohail shaik on 7/15/24.
//


import UIKit
import SwiftUI

class DocumentPickerController {
    static let shared = DocumentPickerController()
    
    private init() {}
    
    func presentDocumentPicker(completion: @escaping ([URL]) -> Void) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        documentPicker.delegate = DocumentPickerDelegate(completion: completion)
        
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            rootVC.present(documentPicker, animated: true, completion: nil)
        }
    }
}

private class DocumentPickerDelegate: NSObject, UIDocumentPickerDelegate {
    private let completion: ([URL]) -> Void
    
    init(completion: @escaping ([URL]) -> Void) {
        self.completion = completion
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        completion(urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        // Handle cancellation
    }
}
