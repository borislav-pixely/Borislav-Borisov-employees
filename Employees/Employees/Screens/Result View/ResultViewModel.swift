//
//  ResultViewModel.swift
//  Employees
//
//  Created by Borislav Borisov on 12/12/2023.
//

import Foundation

final class ResultViewModel: ObservableObject {

    enum State {
        case idle
        case parsingFile
        case calculatingPairs(pairsFound: Int, percentageCompleted: Int)
        case completed
    }

    private var urls = [URL]()

    @Published private(set) var state: State = .idle
    @Published private(set) var errorMessage: String?
    private(set) var pairs = [EmployeePairEntry]()

    var entriesText: String {
        "Entries: \(pairs.count.formattedWithSeparator)"
    }

    var activityMessage: String? {
        switch state {
        case .parsingFile:
            return "Parsing file..."
        case .calculatingPairs(let pairsFound, let percentageCompleted):
            return "Looking for pairs... \(percentageCompleted)%\nFound \(pairsFound.formattedWithSeparator)"
        case .completed:
            if pairs.isEmpty {
                return "No pairs found."
            } else {
                fallthrough
            }
        case .idle:
            return nil
        }
    }

    // MARK: - Public

    func setDocumentURLs(to urls: [URL]) {
        self.urls = urls
    }

    func getResults() {
        guard let firstURL = urls.first, firstURL.startAccessingSecurityScopedResource() else {
            errorMessage = "☹️ Unable to access the selected file."
            return
        }
        
        state = .parsingFile
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let fileContents = try String(contentsOf: firstURL, encoding: .utf8)
                let entries = try EmployeeCSVParser().parse(fileContents)
                let pairs = self?.calculatePairs(entries: entries) ?? []

                DispatchQueue.main.async { [weak self] in
                    self?.pairs = pairs
                    self?.state = .completed
                    firstURL.stopAccessingSecurityScopedResource()
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    self?.errorMessage = "☹️ Failed to parse due to error: \(error.localizedDescription)"
                    firstURL.stopAccessingSecurityScopedResource()
                }
            }
        }
    }

    func getCellViewModel(at indexPath: IndexPath) -> ResultTableViewCellViewModel {
        return ResultTableViewCellViewModel(
            employeeID1: pairs[indexPath.row].employeeID1,
            employeeID2: pairs[indexPath.row].employeeID2,
            projectID: pairs[indexPath.row].projectID,
            daysWorked: pairs[indexPath.row].daysWorked,
            isTopPair: indexPath.row == .zero
        )
    }

    // MARK: - Private

    private func calculatePairs(entries: [EmployeeEntry]) -> [EmployeePairEntry] {
        state = .calculatingPairs(pairsFound: 0, percentageCompleted: 0)

        let sortedEntries = entries.sorted {
            $0.projectID != $1.projectID ? $0.projectID < $1.projectID :
            $0.dateFrom != $1.dateFrom ? $0.dateFrom < $1.dateFrom : $0.dateTo < $1.dateTo
        }

        var totalDaysWorked = [String: Int]()

        for i in 0..<sortedEntries.count {
            for j in (i + 1)..<sortedEntries.count {
                let entry1 = sortedEntries[i]
                let entry2 = sortedEntries[j]

                if entry1.projectID == entry2.projectID {
                    let overlap = calculateOverlap(entry1: entry1, entry2: entry2)
                    if overlap > 0 {
                        let pairKey = if entry1.employeeID > entry2.employeeID {
                            "\(entry2.employeeID)-\(entry1.employeeID)-\(entry1.projectID)"
                        } else {
                            "\(entry1.employeeID)-\(entry2.employeeID)-\(entry1.projectID)"
                        }
                        totalDaysWorked[pairKey, default: 0] = overlap
                    }
                } else {
                    break
                }
            }

            let percentageCompleted = Int((Double(i) / Double(sortedEntries.count)) * 100.0)
            state = .calculatingPairs(pairsFound: totalDaysWorked.count, percentageCompleted: percentageCompleted)
        }

        let pairs = totalDaysWorked.compactMap { key, daysWorked -> EmployeePairEntry? in
            let ids = key.components(separatedBy: "-")

            guard ids.count == 3 else {
                return nil
            }

            return EmployeePairEntry(
                employeeID1: ids[0],
                employeeID2: ids[1],
                projectID: ids[2],
                daysWorked: daysWorked
            )
        }

        return pairs.sorted(by: { $0.daysWorked > $1.daysWorked })
    }

    private func calculateOverlap(entry1: EmployeeEntry, entry2: EmployeeEntry) -> Int {
        let latestStart = max(entry1.dateFrom, entry2.dateFrom)
        let earliestEnd = min(entry1.dateTo, entry2.dateTo)

        if latestStart > earliestEnd {
            return 0
        }

        return Calendar.current.dateComponents([.day], from: latestStart, to: earliestEnd).day ?? 0
    }
}
