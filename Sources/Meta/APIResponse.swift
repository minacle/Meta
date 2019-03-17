import Foundation

public struct APIResponse<Object>: APIResponseProtocol
where Object: Decodable {

    public typealias Request = APIRequest<Object>

    internal typealias Base = AnyAPIResponse

    internal let base: Base

    public var request: APIRequest<Object> {
        return APIRequest<Object>(base: self.base.request)
    }

    public var data: Data? {
        return self.base.data
    }

    private var _object: Object?

    public var object: Object? {
        return self._object
    }

    internal init
        (base: Base)
        throws
    {
        self.base = base
        guard let data = self.data else {
            return
        }
        do {
            self._object = try self.base.jsonDecoder.decode(Object.self, from: data)
        }
        catch {
            throw APIError.jsonDecoder(error: error as! DecodingError, response: self.base)
        }
    }
}

extension APIResponse {

    internal init
        (base: Base.Base)
        throws
    {
        try self.init(base: Base(base: base))
    }
}
