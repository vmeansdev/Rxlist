extension Error {

    func assertFailure() {
        assertionFailure(String(describing: self))
    }

    func withAssertFailure() -> Self {
        assertFailure()
        return self
    }

}
