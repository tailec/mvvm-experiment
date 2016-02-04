//
//  ViewController.swift
//  github-search-osx
//
//  Created by krawiecp on 03/02/2016.
//  Copyright © 2016 Pawel Krawiec. All rights reserved.
//

import Cocoa
import RxSwift
import RxCocoa

class ViewController: NSViewController {

    @IBOutlet weak var searchTextField: NSSearchField!
    @IBOutlet weak var tableView: NSTableView!
    
    var datasource = [Repo]()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToRx()
    }
    
    private func bindToRx() {
        let vm = ViewModel(provider: GitHubProvider)
        
        _ = searchTextField.rx_text.bindTo(vm.searchText).addDisposableTo(disposeBag)
        _ = vm.searchResults.debug().driveNext { [weak self] results in
            self?.datasource = results
            self?.tableView.reloadData()
            }
            .addDisposableTo(disposeBag)
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

extension ViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        return datasource.count
    }
}

extension ViewController: NSTableViewDelegate {
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var cellIdentifier = ""
        var text = ""
        if tableColumn == tableView.tableColumns[0] {
            text = datasource[row].name
            cellIdentifier = "cell1"
        } else if tableColumn == tableView.tableColumns[1] {
            text = datasource[row].description
            cellIdentifier = "cell2"
        }
                
        if let cell = tableView.makeViewWithIdentifier(cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }
        
        return nil
    }
}