import Foundation

/// Basic variables for response.
public protocol MetaResponseProtocol {

    associatedtype Request: MetaRequestProtocol

    var request: Request {get}
    var data: Data? {get}
}

extension MetaResponseProtocol {}

internal protocol _MetaResponseProtocol: MetaResponseProtocol {

    init(_ apiRequest: Request, data: Data?) throws
}

extension _MetaResponseProtocol {}
