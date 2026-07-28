import Foundation

struct DevelopmentAppLaunch: Sendable {
  let executableURL: URL
  let workingDirectory: URL

  init(bundleURL: URL, target: String) {
    executableURL = bundleURL
      .appendingPathComponent("Contents/MacOS")
      .appendingPathComponent(target)
    workingDirectory = bundleURL.appendingPathComponent("Contents/Resources")
  }
}
