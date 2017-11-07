import UIKit
import Gzip
import Dispatch

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        do {
            let chunkSize = 1_000_000

            let d1 = Array.init(repeating: "appleapple", count: 100_000).joined().data(using: .utf8)!
            let d2 = Array.init(repeating: "strawberry", count: 100_000).joined().data(using: .utf8)!
            // use this instead if you want random values not to lower gzipped size
            //            var d1 = Data()
            //            d1.append(contentsOf: (0..<chunkSize).map {_ in UInt8(arc4random() & 0xff)})
            //            var d2 = Data()
            //            d2.append(contentsOf: (0..<chunkSize).map {_ in UInt8(arc4random() & 0xff)})

            // data with 2 fragments
            let dd1 = d1.withUnsafeBytes {DispatchData(bytes: UnsafeRawBufferPointer(UnsafeBufferPointer<UInt8>(start: $0, count: chunkSize)))}
            let dd2 = d2.withUnsafeBytes {DispatchData(bytes: UnsafeRawBufferPointer(UnsafeBufferPointer<UInt8>(start: $0, count: chunkSize)))}
            let dds = __dispatch_data_create_concat(dd1 as __DispatchData, dd2 as __DispatchData)
            NSLog("%@", "dds = \(dds.debugDescription)")

            // pseudo response from URLSession.dataTask. with Xcode 9.1, URLSession may return OS_dispatch_data with referencing to 8K bytes fragments.
            let data = dds as AnyObject as! Data
            NSLog("%@", "data = \(data.debugDescription)")

            // random crash on devices (iPhone 8, iPad Pro 12.9 (1G)), not crash on iPhone 8 Simulator of Xcode 9.1

            let gzipped = try data.gzipped() // deflate can crash
            NSLog("%@", "gzipped = \(gzipped.debugDescription)")

            let gunzipped = try gzipped.gunzipped() // inflate can crash
            NSLog("%@", "gunzipped = \(gunzipped.debugDescription)")
        } catch {
            NSLog("%@", "error: \(error)")
        }

        return true
    }
}
