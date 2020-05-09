//
//  _LocalPDF.swift
//  PDFCreator
//
//  Created by Lahiru Chathuranga on 2/19/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import Foundation
import RealmSwift

class _LocalPDF: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var fileUrl: String = ""
    @objc dynamic var date: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    class func current() -> _LocalPDF? {
        let pdfFiles = try! Realm().objects(_LocalPDF.self)
        return pdfFiles.first
    }
    
    class func savePdfFile(file: LocalPDF) {
        
        let newPDF = _LocalPDF()
        newPDF.name = file.name ?? ""
        newPDF.fileUrl = file.url ?? ""
        newPDF.date = file.date ?? ""
        
        RealmService.shared.crete(object: newPDF)
    }
}
