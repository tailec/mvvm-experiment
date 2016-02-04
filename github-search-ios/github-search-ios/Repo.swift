import Foundation
import SwiftyJSON

struct Repo {
    let name: String
    let description: String
}

extension Repo: Decodable {
    static func decode(json: AnyObject) -> Repo {
        let json = JSON(json)
        
        let name = json["full_name"].stringValue
        let description = json["description"].stringValue
        
        return Repo(name: name,
            description: description)
    }
}