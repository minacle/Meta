import Foundation

public struct AnyMetaResponse: MetaResponseProtocol {

    public typealias Request = AnyMetaRequest

    internal typealias Base = _AnyMetaResponse

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

internal class _AnyMetaResponse: _MetaResponseProtocol {

    public typealias Request = AnyMetaRequest

    private let _request: Request
    private let _data: Data?

    public var request: Request {
        return self._request
    }

    public var data: Data? {
        return self._data
    }

    internal required init
        (_ apiRequest: _AnyMetaResponse.Request,
         data: Data?)
        throws
    {
        self._request = apiRequest
        self._data = data
    }
}
