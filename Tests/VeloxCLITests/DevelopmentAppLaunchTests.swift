import Foundation
import XCTest
@testable import VeloxCLI
import VeloxRuntime

final class DevelopmentAppLaunchTests: XCTestCase {
  func testLaunchUsesExecutableInsideAppBundleAndResourcesWorkingDirectory() {
    let bundleURL = URL(fileURLWithPath: "/tmp/Cleaning Dev.app")

    let launch = DevelopmentAppLaunch(
      bundleURL: bundleURL,
      target: "CleanSpaceDesktop"
    )

    XCTAssertEqual(
      launch.executableURL.path,
      "/tmp/Cleaning Dev.app/Contents/MacOS/CleanSpaceDesktop"
    )
    XCTAssertEqual(
      launch.workingDirectory.path,
      "/tmp/Cleaning Dev.app/Contents/Resources"
    )
  }

  func testDevelopmentBundleUsesAppOnlyAndAdHocSigning() {
    let production = BundleConfig(
      active: true,
      targets: [.app, .dmg],
      resources: ["libRuntime.dylib"],
      macos: MacOSBundleConfig(
        minimumSystemVersion: "15.0",
        infoPlist: "Support/Info.plist",
        signingIdentity: "Developer ID Application: Example",
        hardenedRuntime: true,
        dmg: DmgConfig(enabled: true)
      )
    )

    let development = developmentBundleConfig(from: production)

    XCTAssertEqual(development.targets, [.app])
    XCTAssertEqual(development.resources, ["libRuntime.dylib"])
    XCTAssertEqual(development.macos?.minimumSystemVersion, "15.0")
    XCTAssertEqual(development.macos?.infoPlist, "Support/Info.plist")
    XCTAssertEqual(development.macos?.signingIdentity, "-")
    XCTAssertEqual(development.macos?.hardenedRuntime, false)
    XCTAssertNil(development.macos?.dmg)
    XCTAssertNil(development.macos?.notarization)
  }
}
