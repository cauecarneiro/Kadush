import Foundation

enum Config {
    enum Error: Swift.Error {
        case missingKey
        case invalidValue
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum APIKeys {
    static var openAIKey: String {
        get throws {
            try Config.value(for: "OPENAI_API_KEY")
        }
    }
} 