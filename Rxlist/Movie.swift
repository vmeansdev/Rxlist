struct Movie: Codable {

    // MAKR: Properties

    let title: String
    let year: Int?
    let rated: String?
    let released: String?
    let runtime: String?
    let genre: String?

    // MARK: Codable

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.year = try? container.decode(Int.self, forKey: .year)
        self.rated = try? container.decode(String.self, forKey: .rated)
        self.released = try? container.decode(String.self, forKey: .released)
        self.runtime = try? container.decode(String.self, forKey: .runtime)
        self.genre = try? container.decode(String.self, forKey: .genre)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
    }
}
