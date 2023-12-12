//
//  EmployeeCSVParser.swift
//  Employees
//
//  Created by Borislav Borisov on 12/12/2023.
//

import Foundation

final class EmployeeCSVParser: CSVParser<EmployeeEntry> {

    override func parse(_ string: String) throws -> [EmployeeEntry] {
        var entries = [EmployeeEntry]()
        let normalizedString = string.replacingOccurrences(of: "\r\n", with: "\n")
        let rows = normalizedString.components(separatedBy: "\n")

        try setupParser(with: rows, indexForDateValues: 2)

        for row in rows {
            let columns = row.components(separatedBy: selectedColumnSeparator.rawValue)

            guard columns.count >= 4,
                  let dateFrom = dateParser.parse(from: columns[2], usingMethod: selectedDateParsingMethod),
                  let dateTo = dateParser.parse(from: columns[3], usingMethod: selectedDateParsingMethod) else {
                continue
            }

            let employeeID = columns[0]
            let projectID = columns[1]

            entries.append(
                EmployeeEntry(
                    employeeID: employeeID,
                    projectID: projectID,
                    dateFrom: dateFrom,
                    dateTo: dateTo
                )
            )
        }

        return entries
    }
}
