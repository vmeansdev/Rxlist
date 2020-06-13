import UIKit

// MARK: Navigation

extension UIViewController {

    func withNavigation() -> UINavigationController {
        UINavigationController(rootViewController: self)
    }

}


// MARK: Chlid Controllers

extension UIViewController {

    func attachChild(_ vc: UIViewController, into view: UIView) {
        addChild(vc)
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

    func attachChild(_ vc: UIViewController) {
        attachChild(vc, into: view)
    }

    func detachFromParent() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

}
