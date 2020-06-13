import RxRelay
import RxSwift

final class ReadOnlyVariable<Element>: ObservableType {

    private let relay: BehaviorRelay<Element>

    var value: Element {
        relay.value
    }

    init(_ relay: BehaviorRelay<Element>) {
        self.relay = relay
    }

    func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.Element == Element {
        relay.subscribe(observer)
    }

    func asObservable() -> Observable<Element> {
        relay.asObservable()
    }

}
