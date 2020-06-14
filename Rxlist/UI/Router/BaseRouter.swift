import UIKit

// MARK: -

enum RouterError: Error {

    case viewControllerNotInitialized

}

// MARK: -

class BaseRouter<T: UIViewController> {

    // MARK: Properties

    let assemblyFactory: AssemblyFactory

    let serviceFactory: ServiceFactory

    weak var viewController: T?

    // MARK: Initialization

    init(assemblyFactory: AssemblyFactory, serviceFactory: ServiceFactory) {
        self.assemblyFactory = assemblyFactory
        self.serviceFactory = serviceFactory
    }

}
