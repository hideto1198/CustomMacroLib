//
//  CodableKey.swift
//  
//
//  Created by 東　秀斗 on 2023/10/30.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct CodableKey: PeerMacro {
    public static func expansion(of node: AttributeSyntax, providingPeersOf declaration: some DeclSyntaxProtocol, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        []
    }
}
