import Foundation
import RxSwift
import RxCocoa
import Moya

class ViewModel {
    var searchText = Variable("")
    let searchResults: Driver<[Repo]>
    
    private let provider: RxMoyaProvider<GitHub>
    
    init(provider: RxMoyaProvider<GitHub>) {
        self.provider = provider
        
        searchResults = searchText.asObservable()
            .flatMapLatest { query in
               provider.request(GitHub.RepoSearch(query: query))
                .retry(3)
            }
            .mapJSON()
            .mapToRepos()
            .asDriver(onErrorJustReturn: [])
    }
}

extension Observable {
    func mapToRepos() -> Observable<[Repo]> {
        return self.map { json in
            let dict = json as? [String: AnyObject]
            if let items = dict?["items"] as? [AnyObject] {
                return Repo.decodeMany(items)
            } else {
                return []
            }
        }
    }
}