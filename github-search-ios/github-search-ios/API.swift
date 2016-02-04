import Foundation
import Moya
import RxSwift

let GitHubProvider = RxMoyaProvider<GitHub>()

public enum GitHub {
    case RepoSearch(query: String)
}

extension GitHub: TargetType {
    public var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }
    
    public var path: String {
        switch self {
        case .RepoSearch(_):
            return "/search/repositories"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .RepoSearch(_):
            return .GET
        }
    }
    
    public var parameters: [String: AnyObject]? {
        switch self {
        case .RepoSearch(let query):
            return ["q": query.URLEscapedString]
        }
    }
    
    public var sampleData: NSData {
        switch self {
        case .RepoSearch(_):
            return "Half measures are as bad as nothing at all.".dataUsingEncoding(NSUTF8StringEncoding)!
        }
    }
}

private extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
}

