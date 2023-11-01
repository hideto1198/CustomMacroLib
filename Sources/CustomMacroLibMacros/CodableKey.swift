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
//        let keyword: TokenSyntax = .keyword(.var)
//        let patternBindingSyntax: PatternBindingSyntax = .init(pattern: PatternSyntax("hoge"),
//                                                               typeAnnotation: TypeAnnotationSyntax(type: TypeSyntax("String")))
//        let bindings: PatternBindingListSyntax = .init([patternBindingSyntax])
//        let result = VariableDeclSyntax(bindingSpecifier: keyword, bindings: bindings)
//        let decl: DeclSyntax = """
//            { 
//                \(result) = "2"
//                return hoge
//            }
//        """
//        return [decl]
        []
    }
}
