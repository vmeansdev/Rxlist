import Foundation

class AssemblyFactory {

    // MARK: Properties

    private let serviceFactory: ServiceFactory

    // MARK: Initialization

    init(serviceFactory: ServiceFactory) {
        self.serviceFactory = serviceFactory
    }

    // MARK: Assemblies

    func searchAssembly() -> SearchAssembly {
        SearchAssembly(configuration: assemblyConfiguration)
    }

    // MARK: Configuration

    private var assemblyConfiguration: AssemblyConfiguration {
        return AssemblyConfiguration(
            assemblyFactory: self,
            serviceFactory: serviceFactory
        )
    }

}
