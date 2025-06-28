import UIKit

// -------------------------------------------------------------------------------------------------------------------------------------------------
class FGUINavigationController: UINavigationController {
    // ---------------------------------------------------------------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationBar()
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.nightMode) {
//            return .lightContent
//        } else {
//            return .default
//        }
//    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func setNavigationBar() {
        if #available(iOS 13.0, *) {
            let compactAppearance = UINavigationBarAppearance()
            compactAppearance.configureWithTransparentBackground()
            compactAppearance.titleTextAttributes = [.foregroundColor: UIColor.white1]
            compactAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white1]
            compactAppearance.backgroundColor = .clear

            navigationBar.standardAppearance = compactAppearance
            navigationBar.compactAppearance = compactAppearance
            navigationBar.scrollEdgeAppearance = compactAppearance
            navigationBar.tintColor = .white1
        } else {
            navigationBar.isTranslucent = false
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white1]
            navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white1]
            navigationBar.barTintColor = .clear
            navigationBar.tintColor = .white1
            navigationBar.shadowImage = UIImage()
        }
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------
    func setBackground(color: UIColor) {
        if #available(iOS 13.0, *) {
            navigationBar.standardAppearance.backgroundColor = color
            navigationBar.compactAppearance?.backgroundColor = color
            navigationBar.scrollEdgeAppearance?.backgroundColor = color
        } else {
            navigationBar.barTintColor = .navBarColor
        }
    }

    func setTitleColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: color]
            navigationBar.standardAppearance.largeTitleTextAttributes = [.foregroundColor: color]
            navigationBar.compactAppearance?.titleTextAttributes = [.foregroundColor: color]
            navigationBar.compactAppearance?.largeTitleTextAttributes = [.foregroundColor: color]
            navigationBar.scrollEdgeAppearance?.titleTextAttributes = [.foregroundColor: color]
            navigationBar.scrollEdgeAppearance?.largeTitleTextAttributes = [.foregroundColor: color]
        } else {
            navigationBar.titleTextAttributes = [.foregroundColor: color]
            navigationBar.largeTitleTextAttributes = [.foregroundColor: color]
        }
    }
}
