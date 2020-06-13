import RxSwift

extension ObservableType where Element: ResultConvertible {

    func skipNil() -> Observable<Element.Success> {
        return map { try? $0.value() }
            .filter { $0 != nil }
            .map { $0! }
    }

}

// MARK: - Threading

extension ObservableType {

    func subscribeOn(
        scheduler: ImmediateSchedulerType = MainScheduler.instance,
        _ onNext: @escaping (Element) -> Void
    ) -> Disposable {
        return observeOn(scheduler).subscribe(onNext: onNext)
    }

    func subscribeInBackground(_ onNext: @escaping (Element) -> Void) -> Disposable {
        return subscribeOn(scheduler: SerialDispatchQueueScheduler(qos: .userInitiated), onNext)
    }

}

/// Represent an optional value
///
/// This is needed to restrict our Observable extension to Observable that generate
/// .Next events with Optional payload

protocol OptionalType {

    associatedtype Wrapped

    var asOptional:  Wrapped? { get }

}

/// Implementation of the OptionalType protocol by the Optional type

extension Optional: OptionalType {

    var asOptional: Wrapped? { return self }

}

extension Observable where Element: OptionalType {

    /// Returns an Observable where the nil values from the original Observable are
    /// skipped

    func skipNil() -> Observable<Element.Wrapped> {
        return self.filter { $0.asOptional != nil }.map { $0.asOptional! }
    }

}
