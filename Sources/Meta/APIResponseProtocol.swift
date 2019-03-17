import Foundation

/// Basic variables for response.
public protocol APIResponseProtocol {

    associatedtype Request: APIRequestProtocol

    var request: Request {get}
    var data: Data? {get}
}

extension APIResponseProtocol {}

internal protocol _APIResponseProtocol: APIResponseProtocol {

    init(_ apiRequest: Request, data: Data?) throws
}

extension _APIResponseProtocol {}
