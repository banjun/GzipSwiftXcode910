import UIKit
import Gzip

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        do {
            let data = Array(repeating: "strawberry", count: 1_000).joined().data(using: .utf8)!
            NSLog("%@", "data = \(data.debugDescription)")

            let gzipped = try data.gzipped()
            NSLog("%@", "gzipped = \(gzipped.debugDescription)")

            let gunzipped = try gzipped.gunzipped()
            NSLog("%@", "gunzipped = \(gunzipped.debugDescription)")
        } catch {
            NSLog("%@", "error: \(error)")
        }

        return true
    }
}
