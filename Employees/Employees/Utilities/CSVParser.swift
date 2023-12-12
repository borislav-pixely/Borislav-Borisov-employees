//
//  CSVParser.swift
//  Employees
//
//  Created by Borislav Borisov on 12/12/2023.
//

import Foundation

class CSVParser<T: Codable> {

    enum CSVParserError: Error {
        case emptyFile
        case invalidFormat
        case parserNotImplemented
        case dateConversionFailed
    }

    enum ColumnSeparator: String, CaseIterable {
        case comma = ","
        case semicolon = ";"
        case dot = "."
        case pipe = "|"
        case space = " "
        case tab = "\t"
    }

    private(set) var selectedDateParsingMethod: DateParser.ParsingMethod = .inconsistent
    private(set) var selectedColumnSeparator: ColumnSeparator = .comma

    let dateParser = DateParser()

    // MARK: - Internal

    func parse(_ string: String) throws -> [T] {
        throw CSVParserError.parserNotImplemented
    }

    func setupParser(with rows: [String], indexForDateValues: Int) throws {
        try datermineColumnSeparator(for: rows)
        try determineDateParsingMethod(for: rows, indexForDateValues: indexForDateValues)
    }

    // MARK: - Private

    private func datermineColumnSeparator(for rows: [String]) throws {
        guard let firstRow = rows.first else {
            throw CSVParserError.emptyFile
        }

        var isDetermined = false
        for separator in ColumnSeparator.allCases {
            if firstRow.components(separatedBy: separator.rawValue).count <= 1 {
                continue
            } else {
                selectedColumnSeparator = separator
                isDetermined = true
            }
        }

        if !isDetermined {
            throw CSVParserError.invalidFormat
        }
    }

    private func determineDateParsingMethod(for rows: [String], indexForDateValues: Int) throws {
        let rowCount = min(5, rows.count)
        let dateFormatter = DateFormatter()
        var selectedDateFormat: DateParser.Format?

        for index in 0..<rowCount {
            let columns = rows[index].components(separatedBy: selectedColumnSeparator.rawValue)

            guard columns.indices.contains(indexForDateValues) else {
                continue
            }

            let dateString = columns[indexForDateValues]

            for format in DateParser.Format.allCases {
                dateFormatter.dateFormat = format.rawValue

                if dateFormatter.date(from: dateString) != nil {
                    if let selectedDateFormat, selectedDateFormat != format {
                        selectedDateParsingMethod = .inconsistent
                        return
                    } else if selectedDateFormat == nil {
                        selectedDateFormat = format
                    }
                }
            }
        }

        if let selectedDateFormat {
            selectedDateParsingMethod = .consistent(format: selectedDateFormat)
        } else {
            throw CSVParserError.dateConversionFailed
        }
    }
}
