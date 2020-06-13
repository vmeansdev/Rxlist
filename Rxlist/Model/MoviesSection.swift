import RxDataSources

struct MoviesSection {

    var header: String
    var items: [Item]

}

extension MoviesSection: SectionModelType {

    typealias Item = Movie

    init(original: MoviesSection, items: [Item]) {
        self = original
        self.items = items
    }

}
