//
//  ResultTableViewCell.swift
//  Employees
//
//  Created by Borislav Borisov on 12/12/2023.
//

import UIKit

final class ResultTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: ResultTableViewCell.self)

    @IBOutlet private weak var employeeID1Label: UILabel!
    @IBOutlet private weak var employeeID2Label: UILabel!
    @IBOutlet private weak var projectIDLabel: UILabel!
    @IBOutlet private weak var daysWorkedLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .white
        employeeID1Label.textColor = .black
        employeeID2Label.textColor = .black
        projectIDLabel.textColor = .black
        daysWorkedLabel.textColor = .black
    }

    func configure(with viewModel: ResultTableViewCellViewModel) {
        employeeID1Label.text = viewModel.employeeID1
        employeeID2Label.text = viewModel.employeeID2
        projectIDLabel.text = viewModel.projectID
        daysWorkedLabel.text = viewModel.daysWorked

        if viewModel.isTopPair {
            backgroundColor = .accent
            employeeID1Label.textColor = .white
            employeeID2Label.textColor = .white
            projectIDLabel.textColor = .white
            daysWorkedLabel.textColor = .white
        }
    }
}
