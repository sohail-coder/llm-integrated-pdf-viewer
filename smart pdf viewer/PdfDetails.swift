//
//  PdfDetails.swift
//  smart pdf viewer
//
//  Created by sohail shaik on 7/24/24.
//

import Foundation

struct PDFDetails: Codable, Identifiable {
    let id: UUID
    let title: String
    let url: URL
    let pageNumber: Int
}

