import Foundation

/// An error that carries `AnyMetaRequest` or `AnyMetaResponse`.
public enum MetaError: Error {

    /// An error by `URLSession` with `AnyMetaRequest`.
    case urlSession(error: Error, request: AnyMetaRequest)

    /// An error by `HTTPURLResponse` with `AnyMetaResponse`.
    ///
    /// Actually, this is a status code based custom error. If it can be
    /// ignored, `response` should be casted as `MetaResponse<T>`.
    case httpURLResponse(statusCode: Int, response: AnyMetaResponse)

    /// An error by `JSONDecoder` with `AnyMetaResponse`.
    case jsonDecoder(error: DecodingError, response: AnyMetaResponse)
}
