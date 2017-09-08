//
//  FileData.swift
//

import Foundation

struct FileData {
    
    var data: Data
    var name: String
    var fileName: String
    var mimeType: String
    
    init(data: Data, name: String, fileName: String, mimeType: String) {
        self.data = data
        self.name = name
        self.fileName = fileName
        self.mimeType = mimeType
    }
}
