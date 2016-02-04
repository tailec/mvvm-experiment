import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    private var datasource = [Repo]()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToRx()        
    }
    
    private func bindToRx() {
        let vm = ViewModel(provider: GitHubProvider)
        
        _ = searchBar.rx_text.bindTo(vm.searchText).addDisposableTo(disposeBag)
        _ = vm.searchResults.debug().driveNext { [weak self] results in
                self?.datasource = results
                self?.tableView.reloadData()
            }
            .addDisposableTo(disposeBag)
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        let repo = datasource[indexPath.row]
        cell.textLabel?.text = repo.name
        cell.detailTextLabel?.text = repo.description

        return cell
    }
}

