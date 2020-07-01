import RxDataSources

struct MoviesSection {

    var items: [Item]

}

extension MoviesSection: SectionModelType {

    typealias Item = Movie

    init(original: MoviesSection, items: [Item]) {
        self = original
        self.items = items
    }

}
