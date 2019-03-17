import Foundation

public struct AnyAPIResponse: APIResponseProtocol {

    public typealias Request = AnyAPIRequest

    internal typealias Base = _AnyAPIResponse

    internal let base: Base

    public var request: Request {
        return self.base.request
    }

    public var data: Data? {
        return self.base.data
    }

    internal var jsonEncoder: JSONEncoder {
        return self.base.request.jsonEncoder
    }

    internal var jsonDecoder: JSONDecoder {
        return self.base.request.jsonDecoder
    }

    internal init
        (_ apiRequest: Request,
         data: Data? = nil)
        throws
    {
        self.base =
            try! Base(apiRequest,
                      data: data)
    }

    internal init
        (base: Base)
    {
        self.base = base
    }
}

internal class _AnyAPIResponse: _APIResponseProtocol {

    public typealias Request = AnyAPIRequest

    private let _request: Request
    private let _data: Data?

    public var request: Request {
        return self._request
    }

    public var data: Data? {
        return self._data
    }

    internal required init
        (_ apiRequest: _AnyAPIResponse.Request,
         data: Data?)
        throws
    {
        self._request = apiRequest
        self._data = data
    }
}
