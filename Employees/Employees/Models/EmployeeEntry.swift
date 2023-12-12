//
//  EmployeeEntry.swift
//  Employees
//
//  Created by Borislav Borisov on 12/12/2023.
//

import Foundation

struct EmployeeEntry: Codable {
    let employeeID: String
    let projectID: String
    let dateFrom: Date
    let dateTo: Date
}
