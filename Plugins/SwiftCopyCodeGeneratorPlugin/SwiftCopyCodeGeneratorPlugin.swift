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
        
        let sourceryCommand = Command.prebuildCommand(
            displayName: "Sourcery Generate \(target.displayName)",
            executable: toolPath.path,
            arguments: [
                "--templates",
                templatesPath,
                "--args",
                "imports=[\"\(target.displayName)\"]",
                "--sources",
                context.xcodeProject.directory,
                "--output",
                context.pluginWorkDirectory,
                "--disableCache",
                "--verbose"
            ],
            environment: [:],
            outputFilesDirectory: context.pluginWorkDirectory
        )
        return sourceryCommand
    }
}
#endif
