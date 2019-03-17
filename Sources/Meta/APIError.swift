import Foundation

/// An error that carries `AnyAPIRequest` or `AnyAPIResponse`.
public enum APIError: Error {

    /// An error by `URLSession` with `AnyAPIRequest`.
    case urlSession(error: Error, request: AnyAPIRequest)

    /// An error by `HTTPURLResponse` with `AnyAPIResponse`.
    ///
    /// Actually, this is a status code based custom error. If it can be
    /// ignored, `response` should be casted as `APIResponse<T>`.
    case httpURLResponse(statusCode: Int, response: AnyAPIResponse)

    /// An error by `JSONDecoder` with `AnyAPIResponse`.
    case jsonDecoder(error: DecodingError, response: AnyAPIResponse)
}
