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
    let plot: String?
    let director: String?
    let writer: String?
    let actors: String?
    let language: String?
    let country: String?
    let rating: String?


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
        case plot = "Plot"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case language = "Language"
        case country = "Country"
        case rating = "imdbRating"

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
        self.plot  = try? container.decode(String.self, forKey: .plot)
        self.director = try? container.decode(String.self, forKey: .director)
        self.writer = try? container.decode(String.self, forKey: .writer)
        self.actors = try? container.decode(String.self, forKey: .actors)
        self.language = try? container.decode(String.self, forKey: .language)
        self.country = try? container.decode(String.self, forKey: .country)
        self.rating = try? container.decode(String.self, forKey: .rating)
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
        if let plot = plot {
            try container.encode(plot, forKey: .plot)
        }
        if let director = director {
            try container.encode(director, forKey: .director)
        }
        if let writer = writer {
            try container.encode(writer, forKey: .writer)
        }
        if let actors = actors {
            try container.encode(actors, forKey: .actors)
        }
        if let language = language {
            try container.encode(language, forKey: .language)
        }
        if let country = country {
            try container.encode(country, forKey: .country)
        }
        if let rating = rating {
            try container.encode(rating, forKey: .rating)
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
        lhs.poster == rhs.poster &&
        lhs.plot == rhs.plot &&
        lhs.director == rhs.director &&
        lhs.writer == rhs.writer &&
        lhs.actors == rhs.actors &&
        lhs.language == rhs.language &&
        lhs.country == rhs.country &&
        lhs.rating == rhs.rating
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
        hasher.combine(plot)
        hasher.combine(director)
        hasher.combine(writer)
        hasher.combine(actors)
        hasher.combine(language)
        hasher.combine(country)
        hasher.combine(rating)
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
            "poster = \(poster ?? notAvailable)",
            "plot = \(plot ?? notAvailable)",
            "director = \(director ?? notAvailable)",
            "writer = \(writer ?? notAvailable)",
            "actors = \(actors ?? notAvailable)",
            "language = \(language ?? notAvailable)",
            "country = \(country ?? notAvailable)",
            "rating = \(rating ?? notAvailable)"
        ].joined(separator: ", ")
    }

}

// MARK: -

let notAvailable = "N/A"
