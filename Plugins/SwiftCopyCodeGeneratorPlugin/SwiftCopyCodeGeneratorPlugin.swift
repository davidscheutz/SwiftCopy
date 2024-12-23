import Foundation
import PackagePlugin

@main
struct SwiftCopyCodeGeneratorPlugin: BuildToolPlugin {
    func createBuildCommands (context: PluginContext, target: Target) throws -> [Command] {
        []
    }
}

#if canImport (XcodeProjectPlugin)
import XcodeProjectPlugin

extension SwiftCopyCodeGeneratorPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [PackagePlugin.Command] {
        [
            try sourcery(target: target, in: context)
        ]
    }
    
    private func sourcery(target: XcodeProjectPlugin.XcodeTarget, in context: XcodeProjectPlugin.XcodePluginContext) throws -> Command {
        let toolPath = try context.tool(named: "sourcery")
        let templatesPath = toolPath.path.removingLastComponent().removingLastComponent().appending("Templates")
        
        let root = context.xcodeProject.directory
        var paths: Set<String> = [target.displayName]
        
        let targetPath = root.appending(subpath: target.displayName).string
        
        target.inputFiles
            .filter { $0.path.string.hasPrefix(targetPath) && $0.path.string.hasSuffix(".swift") }
            .forEach {
                var new = $0.path.string.replacingOccurrences(of: "\(root.string)/", with: "")
                
                // skip build folder
                guard !new.hasPrefix("build") else { return }
                
                if new.contains("/") {
                    new = String(new.split(separator: "/")[0])
                }
                if paths.insert(new).inserted {
                    print("Found additional directory: '\(new)' for file: \($0.path)")
                }
            }
        
        print("\(target.displayName) source file root directories: \(paths)")
        
        return command(
            for: target,
            executable: toolPath.path,
            templates: templatesPath.string,
            root: root,
            paths: paths,
            output: context.pluginWorkDirectory
        )
    }
    
    private func command(for target: XcodeTarget, executable: Path, templates: String, root: Path, paths: Set<String>, output: Path) -> Command {
        
        var sources = [String]()
        paths.forEach {
            sources.append("--sources")
            sources.append("\(root.appending(subpath: $0))")
        }
        
        return Command.prebuildCommand(
            displayName: "SwiftCopy generate: \(target.displayName)",
            executable: executable,
            arguments: [
                "--templates",
                templates,
                "--args",
                "imports=[\"\(target.displayName)\"]"
            ] +
               sources
            + [
                "--output",
                output,
                "--disableCache",
                "--verbose"
            ],
            environment: [:],
            outputFilesDirectory: output
        )
    }
}
#endif
