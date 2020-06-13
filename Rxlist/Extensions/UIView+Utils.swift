import UIKit

extension UIView {

    func addSubviews(_ subviews: UIView...) {
        addSubviews(subviews)
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }

}
