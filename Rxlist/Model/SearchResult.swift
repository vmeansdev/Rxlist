struct SearchResult<T: Codable & Hashable>: Codable {

    let items: [T]?

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = try? container.decode([T].self, forKey: .search)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let items = items {
            try container.encode(items, forKey: .search)
        }
    }

}

extension SearchResult: Equatable {

    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.items == rhs.items
    }

}

extension SearchResult: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(items)
    }

}
