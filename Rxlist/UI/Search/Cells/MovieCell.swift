import AlamofireImage
import SnapKit

final class MovieCell: UITableViewCell {

    // MARK: Types

    struct Model: Equatable {

        let imageLink: String?
        let title: String

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

    private let titleLabel = UILabel().with {
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    // MARK: Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubviews(posterView, titleLabel)
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout

    private func configureLayout() {
        posterView.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(8)
            $0.top.equalTo(contentView.snp.top).offset(8)
            $0.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-8)
            $0.width.equalTo(150)
            $0.height.equalTo(200)
        }
        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(posterView.snp.trailing).offset(8)
            $0.top.equalTo(posterView.snp.top)
            $0.trailing.equalTo(contentView.snp.trailing).offset(-8)
            $0.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-8)
        }
    }

    // MARK: UI

    private func updateUI() {
        guard let url = model?.imageLink.flatMap({ URL(string: $0) }) else {
            return
        }
        posterView.af.setImage(withURL: url, cacheKey: url.absoluteString, imageTransition: .crossDissolve(0.2))
        titleLabel.text = model?.title
    }

}
