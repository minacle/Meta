import Foundation
import Poste

/// Basic variables and methods for requests.
public protocol APIRequestProtocol {

    /// A response type that associated of the request type.
    associatedtype Response: APIResponseProtocol

    typealias Result = APIResult<Response, APIError>

    var method: APIMethod {get}
    var url: URL {get}
    var headers: [AnyHashable: Any] {get}
    var queries: [AnyHashable: Any]? {get}
    var data: Data? {get}

    init(method: APIMethod,
         url: URL,
         headers: [AnyHashable: Any],
         queries: [AnyHashable: Any]?,
         data: Data?)

    init(_ apiRequest: Self,
         headers: [AnyHashable: Any],
         queries: [AnyHashable: Any]?,
         data: Data?)

    /// Send synchonised request.
    ///
    /// Requests can be customised by the parameters.
    ///
    /// - Parameters:
    ///   - headers:
    ///     Additional headers.
    ///   - queries:
    ///     Additional queries.
    ///   - data:
    ///     Replacement of data.
    ///   - qos:
    ///     Quality of service.
    ///
    /// - Throws:
    ///   One of case of `APIError`.
    ///
    /// - Returns:
    ///   A `Response` of this request.
    func sync
        (headers: [AnyHashable: Any]?,
         queries: [AnyHashable: Any]?,
         data: Data?,
         qos: DispatchQoS)
        throws
        -> Response

    /// Send asynchronised request.
    ///
    /// Requests can be customised by the parameters.
    ///
    /// - Parameters:
    ///   - headers:
    ///     Additional headers.
    ///   - queries:
    ///     Additional queries.
    ///   - data:
    ///     Replacement of data.
    ///   - qos:
    ///     Quality of service.
    ///
    /// - Returns:
    ///   A `Poste` to track asynchronous task.
    @discardableResult
    func async
        (headers: [AnyHashable: Any]?,
         queries: [AnyHashable: Any]?,
         data: Data?,
         qos: DispatchQoS,
         _ completionHandler: @escaping (Result) -> Void)
        -> VoidPoste
}

extension APIRequestProtocol {

    @inlinable
    public init
        (method: APIMethod = .get,
         url: URL,
         headers: [AnyHashable: Any] = [:],
         queries: [AnyHashable: Any]? = nil,
         data: Data? = nil)
    {
        self.init(method: method,
                  url: url,
                  headers: headers,
                  queries: queries,
                  data: data)
    }

    @inlinable
    public init
        (_ apiRequest: Self,
         headers: [AnyHashable: Any] = [:],
         queries: [AnyHashable: Any]? = nil,
         data: Data? = nil)
    {
        self.init(apiRequest,
                  headers: headers,
                  queries: queries,
                  data: data)
    }

    @inlinable
    public func sync
        (headers: [AnyHashable: Any]? = nil,
         queries: [AnyHashable: Any]? = nil,
         data: Data? = nil,
         qos: DispatchQoS = .unspecified)
        throws
        -> Response
    {
        return
            try self.sync(headers: headers,
                          queries: queries,
                          data: data,
                          qos: qos)
    }

    @discardableResult
    @inlinable
    public func async
        (headers: [AnyHashable: Any]? = nil,
         queries: [AnyHashable: Any]? = nil,
         data: Data? = nil,
         qos: DispatchQoS = .unspecified,
         _ completionHandler: @escaping (Result) -> Void = {_ in})
        -> VoidPoste
    {
        return
            self.async(headers: headers,
                       queries: queries,
                       data: data,
                       qos: qos,
                       completionHandler)
    }
}

internal protocol _APIRequestProtocol: APIRequestProtocol {}

extension _APIRequestProtocol {}
