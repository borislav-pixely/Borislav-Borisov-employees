//
//  FilePickerViewController.swift
//  Employees
//
//  Created by Borislav Borisov on 12/12/2023.
//

import UIKit

final class FilePickerViewController: UIViewController {

    private enum Constant {
        static let resultViewSegue = "presentResultView"
    }

    // MARK: - Lifecycle

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constant.resultViewSegue:
            if let resultViewController = segue.destination as? ResultViewController,
               let urls = sender as? [URL] {
                resultViewController.setup(with: urls)
            }
        default:
            break
        }
    }

    // MARK: - Private

    private func presentFilePicker() {
        let documentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: [.commaSeparatedText])
        documentPickerController.modalPresentationStyle = .formSheet
        documentPickerController.delegate = self
        
        present(documentPickerController, animated: true)
    }
    
    // MARK: - IBAction
    
    @IBAction private func selectFile(_ sender: UIButton) {
        presentFilePicker()
    }
}

extension FilePickerViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        performSegue(withIdentifier: Constant.resultViewSegue, sender: urls)
    }
}
