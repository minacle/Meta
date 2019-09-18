import Foundation
import Poste

public struct AnyMetaRequest: MetaRequestProtocol {

    public static let jsonEncoder = JSONEncoder()
    public static let jsonDecoder = JSONDecoder()

    public static var headers = [AnyHashable: Any]()

    public typealias Response = AnyMetaResponse
    public typealias Result = MetaResult<Response, MetaError>

    internal typealias Base = _AnyMetaRequest

    internal let base: Base

    public var method: MetaMethod {
        return self.base.method
    }

    public var url: URL {
        return self.base.url
    }

    public var headers: [AnyHashable: Any] {
        return self.base.headers
    }

    public var queries: [AnyHashable: Any]? {
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

    public init<Request>
        (_ apiRequest: Request,
         headers: [AnyHashable: Any],
         queries: [AnyHashable: Any]?,
         data: Data?)
        where Request: MetaRequestProtocol
    {
        self.base =
            Base(apiRequest,
                 headers: headers,
                 queries: queries,
                 data: data)
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
        -> AnyMetaResponse
    {
        return
            try self.base.sync(headers: headers,
                               queries: queries,
                               data: data)
    }

    public func async
        (headers: [AnyHashable: Any]?,
         queries: [AnyHashable: Any]?,
         data: Data?,
         qos: DispatchQoS,
         _ completionHandler: @escaping (Result) -> Void)
        -> VoidPoste
    {
        return
            self.base.async(headers: headers,
                            queries: queries,
                            data: data,
                            completionHandler)
    }
}

internal class _AnyMetaRequest: _MetaRequestProtocol {

    public typealias Response = AnyMetaResponse
    public typealias Result = MetaResult<Response, MetaError>

    private let defaultHeaders = AnyMetaRequest.headers

    public let method: MetaMethod
    public let url: URL
    public let headers: [AnyHashable: Any]
    public let queries: [AnyHashable: Any]?
    public let data: Data?

    public let jsonEncoder: JSONEncoder
    public let jsonDecoder: JSONDecoder

    private func url(queries: [AnyHashable: Any]? = nil) -> URL {
        var urlString = url.absoluteString
        if var combinedQueries = queries {
            if let queries = self.queries {
                combinedQueries.merge(queries, uniquingKeysWith: {$1})
            }
            urlString += "?\(combinedQueries.formEncodedString())"
        }
        return URL(string: urlString)!
    }

    public required init
        (method: MetaMethod,
         url: URL,
         headers: [AnyHashable : Any],
         queries: [AnyHashable : Any]?,
         data: Data?)
    {
        self.method = method
        self.url = url
        self.headers = headers
        self.queries = queries
        self.data = data
        self.jsonEncoder = JSONEncoder(AnyMetaRequest.jsonEncoder)
        self.jsonDecoder = JSONDecoder(AnyMetaRequest.jsonDecoder)
    }

    public required convenience init<Request>
        (_ apiRequest: Request,
         headers: [AnyHashable: Any],
         queries: [AnyHashable: Any]?,
         data: Data?)
        where Request: MetaRequestProtocol
    {
        let method = apiRequest.method
        let url = apiRequest.url
        let headers = apiRequest.headers.merging(headers, uniquingKeysWith: {$1})
        let queries = queries ?? apiRequest.queries
        let data = apiRequest.data
        self.init(method: method,
                  url: url,
                  headers: headers,
                  queries: queries,
                  data: data)
    }

    public func sync
        (headers: [AnyHashable: Any]?,
         queries: [AnyHashable: Any]?,
         data: Data?,
         qos: DispatchQoS)
        throws
        -> AnyMetaResponse
    {
        let urlRequest = self.urlRequest(headers: headers, queries: queries, data: data)
        let poste = self.poste(urlRequest: urlRequest, qos: qos)
        return try Poste.await(poste)
    }

    @discardableResult
    public func async
        (headers: [AnyHashable: Any]?,
         queries: [AnyHashable: Any]?,
         data: Data?,
         qos: DispatchQoS,
         _ completionHandler: @escaping (Result) -> Void)
        -> VoidPoste
    {
        let urlRequest = self.urlRequest(headers: headers, queries: queries, data: data)
        let poste = self.poste(urlRequest: urlRequest, qos: qos)
        return Poste.async {
            do {
                completionHandler(.success(try Poste.await(poste)))
            }
            catch {
                completionHandler(.failure(error as! MetaError))
            }
        }
    }

    private func urlRequest
        (headers: [AnyHashable: Any]?,
         queries: [AnyHashable: Any]?,
         data: Data?)
        -> URLRequest
    {
        let url = self.url(queries: self.queries?.merging(queries ?? [:], uniquingKeysWith: {$1}))
        var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        urlRequest.httpMethod = self.method.rawValue
        var combinedHeaders = self.defaultHeaders
        combinedHeaders.merge(self.headers, uniquingKeysWith: {$1})
        if let headers = headers {
            combinedHeaders.merge(headers, uniquingKeysWith: {$1})
        }
        for (key, value) in combinedHeaders {
            urlRequest.setValue("\(value)", forHTTPHeaderField: "\(key)")
        }
        urlRequest.httpBody = data ?? self.data
        dump(urlRequest)
        print(String(data: urlRequest.httpBody ?? Data(), encoding: .utf8)!)
        return urlRequest
    }

    private func poste
        (urlRequest: URLRequest,
         qos: DispatchQoS)
        -> ThrowingNonnullPoste<Response>
    {
        return Poste.async(qos: qos) {
            let dispatchSemaphore = DispatchSemaphore(value: 0)
            var apiResponse: Response?
            var error: MetaError?
            var data: Data?
            let task = URLSession.shared.dataTask(with: urlRequest) {
                let interface = AnyMetaRequest(base: self)
                defer {
                    dispatchSemaphore.signal()
                }
                data = $0
                guard let data = data else {
                    return error = .urlSession(error: $2!, request: interface)
                }
                if let httpURLResponse = $1 as? HTTPURLResponse {
                    if case 400 ..< 600 = httpURLResponse.statusCode {
                        return error = .httpURLResponse(statusCode: httpURLResponse.statusCode, response: try! Response(interface, data: data))
                    }
                }
                apiResponse = try! Response(interface, data: data)
            }
            task.resume()
            dispatchSemaphore.wait()
            if let error = error {
                throw error
            }
            return apiResponse!
        }
    }
}
