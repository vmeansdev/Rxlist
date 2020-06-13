import Foundation
import RxRelay

// MARK: -

enum AppInitializationError: Error {

    case someBaseURLNotInitialized

}

// MARK: -

enum AppInitializationState {

    case notInitialized
    case initializing
    case initialized(ServiceFactory, AssemblyFactory)
    case error(Error)

}

final class AppInitializationManager {

    // MARK: State

    private let _state = BehaviorRelay(value: AppInitializationState.notInitialized)

    private(set) lazy var state = ReadOnlyVariable(_state)

    // MARK: Properties

    private var serviceFactory: ServiceFactory?

    // MARK: Initialization mehtods

    func start() {
        switch _state.value {
        case .initializing:
            return
        case .error, .initialized, .notInitialized:
            break
        }

        _state.accept(.initializing)

        // FIXME: Obtain base url and stuff like that from somewhere else (some Settings Manager)

        guard let omdbBaseURL = URL(string: "https://www.omdbapi.com") else {
            _state.accept(.error(AppInitializationError.someBaseURLNotInitialized))
            return
        }
        let omdbAPIKey = "{OMDB_API_KEY}"
        let serviceFactory = ServiceFactory(omdbBaseURL: omdbBaseURL, omdbAPIKey: omdbAPIKey)
        let assemblyFactory = AssemblyFactory(serviceFactory: serviceFactory)
        self.serviceFactory = serviceFactory
        _state.accept(.initialized(serviceFactory, assemblyFactory))
    }

}
