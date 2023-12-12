//
//  ResultViewController.swift
//  Employees
//
//  Created by Borislav Borisov on 12/12/2023.
//

import UIKit
import Combine

final class ResultViewController: UIViewController {
    
    private let viewModel = ResultViewModel()
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityLabel: UILabel!
    @IBOutlet private weak var entriesLabel: UILabel!
    @IBOutlet private weak var headerView: UIView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupObservers()
        viewModel.getResults()
    }

    // MARK: - Public

    func setup(with urls: [URL]) {
        viewModel.setDocumentURLs(to: urls)
    }

    // MARK: - Private

    private func setupObservers() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateView(with: state)
            }
            .store(in: &cancellables)

        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.presentErrorAlert(for: errorMessage)
            }
            .store(in: &cancellables)
    }

    private func updateView(with state: ResultViewModel.State) {
        activityLabel.text = viewModel.activityMessage

        switch state {
        case .completed:
            tableView.reloadData()
            headerView.isHidden = false
            activityIndicator.stopAnimating()
            entriesLabel.text = viewModel.entriesText
        default:
            break
        }
    }

    private func presentErrorAlert(for errorMessage: String?) {
        guard let errorMessage else {
            return
        }

        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        activityIndicator.stopAnimating()
        present(alertController, animated: true)
    }

    // MARK: - IBAction

    @IBAction private func goToTop(_ sender: UIButton) {
        guard viewModel.pairs.count > 0 else {
            return
        }

        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ResultTableViewCell.reuseIdentifier,
                                                       for: indexPath) as? ResultTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: viewModel.getCellViewModel(at: indexPath))
        return cell
    }
}
