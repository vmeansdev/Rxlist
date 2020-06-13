import RxSwift
import RxRelay

// MARK: -

struct AppInitializationViewModelState: LoadableState {

    // MARK: Properties

    let loadingState: LoadingState

    let hasData: Bool

    // MARK: Updates

    func updated(withLoadingState loadingState: LoadingState) -> AppInitializationViewModelState {
        return AppInitializationViewModelState(loadingState: loadingState, hasData: hasData)
    }

}

// MARK: -

class AppInitializationViewModel: Loadable {

    // MARK: Types

    typealias State = AppInitializationViewModelState

    // MARK: Loadable

    private let _state = BehaviorRelay(value: State(loadingState: .idle, hasData: false))

    private(set) lazy var state = ReadOnlyVariable<State>(_state)

    @discardableResult func reload() -> Bool {
        initializationManager.start()
        return true
    }

    // MARK: Properties

    private let initializationManager: AppInitializationManager

    private let disposeBag = DisposeBag()

    // MARK: Initialization

    init(initializationManager: AppInitializationManager) {
        self.initializationManager = initializationManager
        bindInitializationManager()
    }

    // MARK: Bindings

    private func bindInitializationManager() {
        initializationManager.state.asObservable()
            .subscribeOn { [weak self] state in
                switch state {
                case .notInitialized:
                    self?._state.accept(State(loadingState: .idle, hasData: false))
                case .initialized:
                    self?._state.accept(State(loadingState: .idle, hasData: true))
                case .initializing:
                    self?._state.accept(State(loadingState: .loading, hasData: false))
                case .error(let error):
                    self?._state.accept(State(loadingState: .error(error), hasData: false))
                }
            }
            .disposed(by: disposeBag)
    }

}
