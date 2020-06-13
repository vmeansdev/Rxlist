struct Movie: Codable {

    // MARK: Properties

    let id: String
    let title: String
    let year: Int?
    let rated: String?
    let released: String?
    let runtime: String?
    let genre: String?
    let poster: String?

    // MARK: Keys

    enum CodingKeys: String, CodingKey {

        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case poster = "Poster"

    }

    // MARK: Initialization

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.year = try? container.decode(Int.self, forKey: .year)
        self.rated = try? container.decode(String.self, forKey: .rated)
        self.released = try? container.decode(String.self, forKey: .released)
        self.runtime = try? container.decode(String.self, forKey: .runtime)
        self.genre = try? container.decode(String.self, forKey: .genre)
        self.poster = try? container.decode(String.self, forKey: .poster)
    }

    // MARK: Encodable

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        if let year = year  {
            try container.encode(year, forKey: .year)
        }
        if let rated = rated {
            try container.encode(rated, forKey: .rated)
        }
        if let released = released {
            try container.encode(released, forKey: .released)
        }
        if let runtime = runtime {
            try container.encode(runtime, forKey: .runtime)
        }
        if let genre = genre {
            try container.encode(genre, forKey: .genre)
        }
        if let poster = poster {
            try container.encode(poster, forKey: .poster)
        }
    }
}

// MARK: -

extension Movie: Equatable {

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id &&
        lhs.title == rhs.title &&
        lhs.year == rhs.year &&
        lhs.rated == rhs.rated &&
        lhs.released == rhs.released &&
        lhs.runtime == rhs.runtime &&
        lhs.genre == rhs.genre &&
        lhs.poster == rhs.poster
    }

}

// MARK: -

extension Movie: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(year)
        hasher.combine(rated)
        hasher.combine(released)
        hasher.combine(runtime)
        hasher.combine(genre)
        hasher.combine(poster)
    }

}

// MARK: -

extension Movie: CustomDebugStringConvertible {

    var debugDescription: String {
        [
            "imdbId = \(id)",
            "title = \(title)",
            "year = \(year.map { String($0) } ?? notAvailable)",
            "rated = \(rated ?? notAvailable)",
            "released = \(released ?? notAvailable)",
            "runtime = \(runtime ?? notAvailable)",
            "genre = \(genre ?? notAvailable)",
            "poster = \(poster ?? notAvailable)"
        ].joined(separator: ", ")
    }

}

// MARK: -

private let notAvailable = "N/A"
