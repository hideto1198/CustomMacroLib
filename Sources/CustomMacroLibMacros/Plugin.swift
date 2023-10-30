//
//  Plugin.swift
//  
//
//  Created by 東　秀斗 on 2023/10/30.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct CustomCodablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CustomCodable.self,
        CodableKey.self,
        Base.self
    ]
}
