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
        
        return command(
            for: target,
            executable: toolPath.path,
            templates: templatesPath.string,
            root: context.xcodeProject.directory,
            output: context.pluginWorkDirectory
        )
    }
    
    private func command(for target: XcodeTarget, executable: Path, templates: String, root: Path, output: Path) -> Command {
        Command.prebuildCommand(
            displayName: "SwiftCopy generate: \(target.displayName)",
            executable: executable,
            arguments: [
                "--templates",
                templates,
                "--args",
                "imports=[\"\(target.displayName)\"]",
                "--sources",
                root.appending(subpath: target.displayName),
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
