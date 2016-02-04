import Foundation

protocol Decodable {
    static func decode(json: AnyObject) -> Self
}

extension Decodable {
    static func decodeMany(json: [AnyObject]) -> [Self] {
        return json.map { Self.decode($0) }
    }
}