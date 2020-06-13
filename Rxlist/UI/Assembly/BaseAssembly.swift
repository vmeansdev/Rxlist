struct AssemblyConfiguration {

    // MARK: Properties

    let assemblyFactory: AssemblyFactory

    let serviceFactory: ServiceFactory

}

// MARK: -

class BaseAssembly {

    // MARK: Properties

    let configuration: AssemblyConfiguration

    // MARK: Initialization

    init(configuration: AssemblyConfiguration) {
        self.configuration = configuration
    }

}



