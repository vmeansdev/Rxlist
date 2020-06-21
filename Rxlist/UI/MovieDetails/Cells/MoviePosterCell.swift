import AlamofireImage
import SnapKit

final class MoviePosterCell: UITableViewCell {

    // MARK: Types

    struct Model: Equatable {

        let imageURL: URL?

    }

    // MARK: Properties

    var model: Model? {
        didSet {
            guard model != oldValue else {
                return
            }
            updateUI()
        }
    }

    // MARK: Subviews

    private let posterView = UIImageView().with {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        preservesSuperviewLayoutMargins = false
        contentView.addSubview(posterView)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout

    private func configureLayout() {
        posterView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalTo(500)
        }
    }

    // MARK: UI

    private func updateUI() {
        guard let url = model?.imageURL else {
            return
        }
        posterView.af.setImage(withURL: url, cacheKey: url.absoluteString, imageTransition: .crossDissolve(0.2))
    }

}
