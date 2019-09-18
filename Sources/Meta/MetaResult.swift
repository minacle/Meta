#if swift(>=5.0)
#else
/// A value that represents either a success or a failure, including an
/// associated value in each case.
///
/// This is a minimised type of Result which is included since Swift 5.
public enum Result<Success, Failure>
where Failure: Error {

    /// A success, storing a `Success` value.
    case success(Success)

    /// A failure, storing a `Failure` value.
    case failure(Failure)

    /// Returns the success value as a throwing expression.
    ///
    /// Use this method to retrieve the value of this result if it
    /// represents a success, or to catch the value if it represents a
    /// failure.
    ///
    ///     let integerResult: Result<Int, Error> = .success(5)
    ///     do {
    ///         let value = try integerResult.get()
    ///         print("The value is \(value).")
    ///     }
    ///     catch {
    ///         print("Error retrieving the value: \(error)")
    ///     }
    ///     // Prints "The value is 5."
    ///
    /// - Returns:
    ///   The success value, if the instance represents a success.
    public func get
        ()
        throws
        -> Success
    {
        switch self {
        case let .success(success):
            return success
        case let .failure(failure):
            throw failure
        }
    }
}

extension Result: Equatable
where Success: Equatable, Failure: Equatable {}

extension Result: Hashable
where Success: Hashable, Failure: Hashable {}
#endif

/// An alias for `Result` type.
///
/// Do not try to use `Result` directly instead of `MetaResult`. This
/// is a reserved type for future.
///
/// - Note:
///   This type must be compatible with `Result` type.
public typealias MetaResult = Result
