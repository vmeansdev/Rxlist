protocol ResultConvertible {

    associatedtype Success
    associatedtype Failure: Error

    func asResult() -> Result<Success, Failure>

}

extension ResultConvertible {

    func value() throws -> Success {
        try asResult().get()
    }

    func assertedValue() throws -> Success {
        do {
            return try value()
        } catch {
            throw error.withAssertFailure()
        }
    }

}

extension Result: ResultConvertible {

    func asResult() -> Result<Success, Failure> {
        self
    }

}
