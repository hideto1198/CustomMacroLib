//
//  Base.swift
//
//
//  Created by 東　秀斗 on 2023/10/30.
//

import SwiftSyntax
import SwiftSyntaxMacros

enum CustomError: Error {
    case message(String)
}

public struct Base: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let parentPropertyName = node.arguments?.as(LabeledExprListSyntax.self)?.first?.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text,
              !parentPropertyName.isEmpty
        else { throw CustomError.message("Invaild arguments")}
        let memberList = declaration.memberBlock.members
        
        let cases = memberList.compactMap({ member -> String? in
            guard member.decl.as(StructDeclSyntax.self)?.name.text == "Base" else { return nil }
            let members = member.decl.as(StructDeclSyntax.self)?.memberBlock.members.compactMap({ variableMember -> String? in
                let bindingsFirst = variableMember.decl.as(VariableDeclSyntax.self)?.bindings.first
                guard let propertyName = bindingsFirst?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text,
                      let propertyType = bindingsFirst?.typeAnnotation?.as(TypeAnnotationSyntax.self)?.type.as(IdentifierTypeSyntax.self)?.name.text
                else { return nil }
                return """
                var \(propertyName): \(propertyType) {
                    get { \(parentPropertyName).\(propertyName) }
                    set { \(parentPropertyName).\(propertyName) = newValue }
                }
                """
            }).joined(separator: "\n")
            return members
        })
        let result: DeclSyntax = """
        \(raw: cases.joined(separator: "\n"))
        """
        return [result]
    }
}
