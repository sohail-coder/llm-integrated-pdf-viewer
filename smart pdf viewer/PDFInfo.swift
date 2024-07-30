//
//  PDFInfo.swift
//  smart pdf viewer
//
//  Created by sohail shaik on 7/25/24.
//

// PDFInfo.swift
import Foundation

struct PDFInfo: Codable {
    let id: String
    let title: String
    let url: String
    var recentPageNumber: Int
    
    init(id: String = UUID().uuidString, title: String, url: String, recentPageNumber: Int = 1) {
        self.id = id
        self.title = title
        self.url = url
        self.recentPageNumber = recentPageNumber
    }
    static func sampleData() -> PDFInfo {
            return PDFInfo(title: "Sample Title", url: "sample_url")
        }
    
}
