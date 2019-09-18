import Foundation

public struct MetaResponse<Object>: MetaResponseProtocol
where Object: Decodable {

    public typealias Request = MetaRequest<Object>

    internal typealias Base = AnyMetaResponse

    internal let base: Base

    public var request: MetaRequest<Object> {
        return MetaRequest<Object>(base: self.base.request)
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
            throw MetaError.jsonDecoder(error: error as! DecodingError, response: self.base)
        }
    }
}

extension MetaResponse {

    internal init
        (base: Base.Base)
        throws
    {
        try self.init(base: Base(base: base))
    }
}
