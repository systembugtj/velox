import XCTest
@testable import VeloxRuntime

final class DevelopmentIdentityTests: XCTestCase {
  func testDevelopmentIdentityOverridesBundleIdentityWithoutMutatingProduction() {
    let production = VeloxConfig(
      productName: "Cleaning",
      identifier: "me.systembug.cleaning",
      app: AppConfig(windows: [WindowConfig(label: "main", title: "Cleaning")]),
      development: DevelopmentConfig(
        productName: "Cleaning Dev",
        identifier: "me.systembug.cleaning.dev",
        windowTitle: "Cleaning Dev"
      )
    )

    let development = production.applyingDevelopmentIdentity()

    XCTAssertEqual(development.productName, "Cleaning Dev")
    XCTAssertEqual(development.identifier, "me.systembug.cleaning.dev")
    XCTAssertEqual(development.app.windows.first?.title, "Cleaning Dev")
    XCTAssertEqual(production.productName, "Cleaning")
    XCTAssertEqual(production.identifier, "me.systembug.cleaning")
    XCTAssertEqual(production.app.windows.first?.title, "Cleaning")
  }

  func testDevelopmentIdentityKeepsProductionValuesWhenOverrideIsAbsent() {
    let production = VeloxConfig(
      productName: "Cleaning",
      identifier: "me.systembug.cleaning"
    )

    let development = production.applyingDevelopmentIdentity()

    XCTAssertEqual(development.productName, "Cleaning")
    XCTAssertEqual(development.identifier, "me.systembug.cleaning")
  }
}
