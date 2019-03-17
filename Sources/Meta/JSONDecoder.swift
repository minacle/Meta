// Internal extension for 'Foundation.JSONDecoder'

import Foundation

extension JSONDecoder {

    internal convenience init(_ jsonDecoder: JSONDecoder) {
        self.init()
        self.keyDecodingStrategy = jsonDecoder.keyDecodingStrategy
        self.userInfo = jsonDecoder.userInfo
        self.dateDecodingStrategy = jsonDecoder.dateDecodingStrategy
        self.dataDecodingStrategy = jsonDecoder.dataDecodingStrategy
        self.nonConformingFloatDecodingStrategy = jsonDecoder.nonConformingFloatDecodingStrategy
    }
}
