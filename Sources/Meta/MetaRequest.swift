import Foundation
import Poste

public struct MetaRequest<Object>: MetaRequestProtocol
where Object: Decodable {

    public typealias Response = MetaResponse<Object>
    public typealias Result = MetaResult<Response, MetaError>

    internal typealias Base = AnyMetaRequest

    internal let base: Base

    public var method: MetaMethod {
        return self.base.method
    }

    public var url: URL {
        return self.base.url
    }

    public var headers: [AnyHashable : Any] {
        return self.base.headers
    }

    public var queries: [AnyHashable : Any]? {
        return self.base.queries
    }

    public var data: Data? {
        return self.base.data
    }

    public var jsonEncoder: JSONEncoder {
        return self.base.jsonEncoder
    }

    public var jsonDecoder: JSONDecoder {
        return self.base.jsonDecoder
    }

    public init
        (method: MetaMethod,
         url: URL,
         headers: [AnyHashable: Any],
         queries: [AnyHashable: Any]?,
         data: Data?)
    {
        self.base =
            Base(method: method,
                 url: url,
                 headers: headers,
                 queries: queries,
                 data: data)
    }

    public init<Request>
        (_ request: Request,
         headers: [AnyHashable: Any],
         queries: [AnyHashable: Any]?,
         data: Data?)
        where Request: MetaRequestProtocol
    {
        self.base =
            Base(request as! Base,
                 headers: headers,
                 queries: queries,
                 data: data)
    }

    internal init
        (base: Base)
    {
        self.base = base
    }

    public func sync
        (headers: [AnyHashable: Any]?,
         queries: [AnyHashable: Any]?,
         data: Data?,
         qos: DispatchQoS)
        throws
        -> MetaResponse<Object>
    {
        let response =
            try self.base.sync(headers: headers,
                               queries: queries,
                               data: data,
                               qos: qos)
        return try Response(base: response.base)
    }

    public func async
        (headers: [AnyHashable: Any]?,
         queries: [AnyHashable: Any]?,
         data: Data?,
         qos: DispatchQoS,
         _ completionHandler: @escaping (Result) -> Void)
        -> VoidPoste
    {
        return self.base.async(headers: headers,
                               queries: queries,
                               data: data,
                               qos: qos)
        {
            (result) in
            switch result {
            case .success(let response):
                do {
                    completionHandler(.success(try Response(base: response.base)))
                }
                catch {
                    completionHandler(.failure(error as! MetaError))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

extension MetaRequest {

    internal init
        (base: Base.Base)
    {
        self.init(base: Base(base: base))
    }
}
