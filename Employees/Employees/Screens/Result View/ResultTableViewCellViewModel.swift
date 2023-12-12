//
//  ResultTableViewCellViewModel.swift
//  Employees
//
//  Created by Borislav Borisov on 12/12/2023.
//

import Foundation

final class ResultTableViewCellViewModel {
    
    let employeeID1: String
    let employeeID2: String
    let projectID: String
    let daysWorked: String
    let isTopPair: Bool

    init(employeeID1: String, employeeID2: String, projectID: String, daysWorked: Int, isTopPair: Bool) {
        self.employeeID1 = employeeID1
        self.employeeID2 = employeeID2
        self.projectID = projectID
        self.daysWorked = "\(daysWorked.formattedWithSeparator) days"
        self.isTopPair = isTopPair
    }
}
