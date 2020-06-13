import RxCocoa
import RxSwift

// MARK: -

struct SearchViewModelState: LoadableState, Equatable {

    // MARK: Properties

    var loadingState: LoadingState

    var items: [Movie]

    var hasData: Bool {
        return !items.isEmpty
    }

    // MARK: Initialization

    init(items: [Movie] = [], loadingState: LoadingState = .idle) {
        self.items = items
        self.loadingState = loadingState
    }

    // MARK: Updates

    func updated(withLoadingState loadingState: LoadingState) -> SearchViewModelState {
        SearchViewModelState(items: items, loadingState: loadingState)
    }

    // MARK: Equatable

    static func == (lhs: SearchViewModelState, rhs: SearchViewModelState) -> Bool {
        lhs.items == rhs.items &&
        lhs.loadingState == rhs.loadingState
    }

}

final class SearchViewModel: Loadable {

    // MARK: Types

    typealias State = SearchViewModelState

    // MARK: Properties

    let searchText = BehaviorRelay(value: "")

    private let service: OMDBService

    private let disposeBag = DisposeBag()

    // MARK: Initialization

    init(service: OMDBService) {
        self.service = service
    }

    // MARK: Loadable

    private let _state = BehaviorRelay(value: State())

    private(set) lazy var state = ReadOnlyVariable(_state)

    @discardableResult
    func reload() -> Bool {
        reload(startingWith: .loading)
    }

    func pulledToRefresh() -> Bool {
        reload(startingWith: .pulledToRefresh)
    }

    private func reload(startingWith loadingState: LoadingState) -> Bool {
        if [.loading, .pulledToRefresh].contains(_state.value.loadingState) {
            return false
        }

        _state.accept(_state.value.updated(withLoadingState: loadingState))

        _ = searchText.asObservable()
            .filter { !$0.isEmpty }
            .flatMap { [weak self] in self?.service.getMoviesByTitle($0) ?? Observable.empty() }
            .subscribeOn(SerialDispatchQueueScheduler(qos: .userInitiated))
            .do(onNext: { debugPrint("Movies found: \($0.items ?? [])") })
            .map { [weak self] result in self?.state(for: result.items ?? []) }
            .skipNil()
            .observeOn(MainScheduler.instance)
            .catchError { [weak self] in
                debugPrint("Error happened: \($0)")
                var state = State()
                state.loadingState = .error($0)
                self?._state.accept(state)
                return Observable.just(state)
            }.bind(to: _state)
            .disposed(by: disposeBag)

        return true
    }

    // MARK: Implementation

    private func state(for items: [Movie]) -> State {
        return State(items: items)
    }

}
