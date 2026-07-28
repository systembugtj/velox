import Foundation
import Logging
import XCTest
@testable import VeloxBundler
import VeloxRuntime

final class BundlerEffectiveConfigTests: XCTestCase {
  func testBundleResourcesContainEffectiveConfigPassedToBundler() throws {
    let packageDirectory = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString, isDirectory: true)
    defer { try? FileManager.default.removeItem(at: packageDirectory) }

    let buildDirectory = packageDirectory
      .appendingPathComponent(".build", isDirectory: true)
      .appendingPathComponent("debug", isDirectory: true)
    try FileManager.default.createDirectory(
      at: buildDirectory,
      withIntermediateDirectories: true
    )
    try Data("executable".utf8).write(
      to: buildDirectory.appendingPathComponent("TestApp")
    )

    let production = VeloxConfig(
      productName: "Cleaning",
      identifier: "me.systembug.cleaning"
    )
    try JSONEncoder().encode(production).write(
      to: packageDirectory.appendingPathComponent("velox.json")
    )

    let development = VeloxConfig(
      productName: "Cleaning Dev",
      identifier: "me.systembug.cleaning.dev"
    )
    let output = try VeloxBundler(logger: Logger(label: "test")).createBundle(
      target: "TestApp",
      config: development,
      bundleConfig: nil,
      configuration: "debug",
      packageDirectory: packageDirectory,
      bundleTargets: [.app]
    )

    let bundledConfigURL = output.bundleURL
      .appendingPathComponent("Contents/Resources/velox.json")
    let bundledConfig = try JSONDecoder().decode(
      VeloxConfig.self,
      from: Data(contentsOf: bundledConfigURL)
    )

    XCTAssertEqual(bundledConfig.productName, "Cleaning Dev")
    XCTAssertEqual(bundledConfig.identifier, "me.systembug.cleaning.dev")
  }
}
