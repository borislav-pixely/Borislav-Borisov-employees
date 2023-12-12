//
//  DateParser.swift
//  Employees
//
//  Created by Borislav Borisov on 12/12/2023.
//

import Foundation

final class DateParser {
    
    private enum Constant {
        static let null = "NULL"
    }

    enum Format: String, CaseIterable {
        case ddMMMyy = "dd-MMM-yy"
        case ddMMMyyyy = "dd-MMM-yyyy"
        case yyyyMMdd = "yyyy-MM-dd"
        case ddMMyyyy = "dd-MM-yyyy"
        case MMddyyyy = "MM-dd-yyyy"
        case yyyyddMM = "yyyy-dd-MM"
    }
    
    enum ParsingMethod {
        case consistent(format: Format)
        case inconsistent
    }
    
    // MARK: - Public
    
    func parse(from dateString: String, usingMethod method: ParsingMethod) -> Date? {
        guard dateString.uppercased() != Constant.null else {
            return Date()
        }
        
        let dateFormatter = DateFormatter()
        
        switch method {
        case .consistent(let format):
            dateFormatter.dateFormat = format.rawValue
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        case .inconsistent:
            for format in Format.allCases {
                dateFormatter.dateFormat = format.rawValue
                if let date = dateFormatter.date(from: dateString) {
                    return date
                }
            }
        }
        
        return nil
    }
}
