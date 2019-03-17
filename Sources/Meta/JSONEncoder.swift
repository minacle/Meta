// Internal extension for 'Foundation.JSONEncoder'

import Foundation

extension JSONEncoder {

    internal convenience init(_ jsonEncoder: JSONEncoder) {
        self.init()
        self.outputFormatting = jsonEncoder.outputFormatting
        self.keyEncodingStrategy = jsonEncoder.keyEncodingStrategy
        self.userInfo = jsonEncoder.userInfo
        self.dateEncodingStrategy = jsonEncoder.dateEncodingStrategy
        self.dataEncodingStrategy = jsonEncoder.dataEncodingStrategy
        self.nonConformingFloatEncodingStrategy = jsonEncoder.nonConformingFloatEncodingStrategy
    }
}
