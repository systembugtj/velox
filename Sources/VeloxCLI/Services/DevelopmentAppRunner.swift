import Foundation
import VeloxBundler
import VeloxRuntime

func developmentBundleConfig(from source: BundleConfig?) -> BundleConfig {
  var result = source ?? BundleConfig()
  var macOS = result.macos ?? MacOSBundleConfig()

  result.active = true
  result.targets = [.app]
  macOS.signingIdentity = "-"
  macOS.hardenedRuntime = false
  macOS.notarization = nil
  macOS.dmg = nil
  result.macos = macOS

  return result
}

struct DevelopmentAppRunner: Sendable {
  let processManager: ProcessManager
  let target: String
  let release: Bool
  let devUrl: String?
  let packageDirectory: URL
  let config: VeloxConfig
  let additionalEnv: [String: String]

  func run(needsRebuild: Bool) async throws {
#if os(macOS)
    let launch = try await prepareMacOSLaunch(needsRebuild: needsRebuild)
    try await processManager.runExecutable(
      at: launch.executableURL,
      workingDirectory: launch.workingDirectory,
      devUrl: devUrl,
      additionalEnv: additionalEnv
    )
#else
    if needsRebuild {
      try await processManager.runSwiftApp(
        target: target,
        release: release,
        devUrl: devUrl,
        packageDirectory: packageDirectory,
        additionalEnv: additionalEnv
      )
    } else {
      try await processManager.restartSwiftApp(
        target: target,
        release: release,
        devUrl: devUrl,
        packageDirectory: packageDirectory,
        additionalEnv: additionalEnv
      )
    }
#endif
  }

#if os(macOS)
  private func prepareMacOSLaunch(needsRebuild: Bool) async throws -> DevelopmentAppLaunch {
    let configuration = release ? "release" : "debug"
    let bundleName = config.productName ?? target
    let bundleURL = packageDirectory
      .appendingPathComponent(".build")
      .appendingPathComponent(configuration)
      .appendingPathComponent("\(bundleName).app")

    guard needsRebuild else {
      return DevelopmentAppLaunch(bundleURL: bundleURL, target: target)
    }

    try await buildSwiftApp()
    try await runBeforeBundleCommand(configuration: configuration)

    let bundleConfig = developmentBundleConfig(from: config.bundle)
    let output = try VeloxBundler(logger: logger).createBundle(
      target: target,
      config: config,
      bundleConfig: bundleConfig,
      configuration: configuration,
      packageDirectory: packageDirectory,
      bundleTargets: [.app]
    )
    return DevelopmentAppLaunch(bundleURL: output.bundleURL, target: target)
  }

  private func runBeforeBundleCommand(configuration: String) async throws {
    guard let command = config.build?.beforeBundleCommand else { return }

    logger.info("[hook] Running beforeBundleCommand: \(command)")
    var environment = additionalEnv
    environment["VELOX_BUNDLE_CONFIGURATION"] = configuration
    guard let shell = resolveExecutable("sh") else {
      throw ProcessManager.ProcessError.buildFailed("Cannot find sh in PATH")
    }
    try await runProcess(
      executable: shell,
      arguments: ["-c", command],
      workingDirectory: packageDirectory,
      additionalEnv: environment
    )
    logger.info("[hook] beforeBundleCommand completed")
  }

  private func buildSwiftApp() async throws {
    guard let swift = resolveExecutable("swift") else {
      throw ProcessManager.ProcessError.buildFailed("Swift executable not found in PATH")
    }
    var arguments = ["build", "--disable-sandbox", "--product", target]
    if release {
      arguments.append(contentsOf: ["-c", "release"])
    }
    try await runProcess(
      executable: swift,
      arguments: arguments,
      workingDirectory: packageDirectory,
      additionalEnv: additionalEnv
    )
  }

  private func runProcess(
    executable: String,
    arguments: [String],
    workingDirectory: URL,
    additionalEnv: [String: String]
  ) async throws {
    let process = Process()
    process.executableURL = URL(fileURLWithPath: executable)
    process.arguments = arguments
    process.currentDirectoryURL = workingDirectory
    process.environment = ProcessInfo.processInfo.environment.merging(additionalEnv) {
      _, override in override
    }
    process.standardOutput = FileHandle.standardOutput
    process.standardError = FileHandle.standardError

    try process.run()
    await withCheckedContinuation { continuation in
      process.terminationHandler = { _ in continuation.resume() }
    }
    guard process.terminationStatus == 0 else {
      throw ProcessManager.ProcessError.buildFailed(
        "\(executable) exited with status \(process.terminationStatus)"
      )
    }
  }
#endif
}
