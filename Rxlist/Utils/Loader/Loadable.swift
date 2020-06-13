// MARK: -

enum LoadingState: Equatable {

    case idle
    case loading
    case pulledToRefresh
    case error(Error)

}

func ==(lhs: LoadingState, rhs: LoadingState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
        return true
    case (.loading, .loading):
        return true
    case (.pulledToRefresh, .pulledToRefresh):
        return true
    default:
        return false
    }
}

// MARK: -

protocol LoadableState {

    var loadingState: LoadingState { get }

    var hasData: Bool { get }

}

// MARK: -

protocol Reloadable: class {

    @discardableResult func reload() -> Bool

}

// MARK: -

protocol Loadable: Reloadable {

    // MARK: Required Protocol

    associatedtype State: LoadableState

    var state: ReadOnlyVariable<State> { get }

    // MARK: Protocol with Default Implementation

    @discardableResult func pulledToRefresh() -> Bool

}

// MARK: -

extension Loadable {

    @discardableResult func pulledToRefresh() -> Bool {
        return reload()
    }

    @discardableResult func reloadIfNeeded() -> Bool {
        return !state.value.hasData ? reload() : false
    }

}
