//
//  CustomCodable.swift
//
//
//  Created by 東　秀斗 on 2023/10/30.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct CustomCodable: MemberMacro {
    public static func expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        let memberList = declaration.memberBlock.members
        let types = declaration.inheritanceClause?.inheritedTypes
        guard let typeNames = types?.map({ $0.as(InheritedTypeSyntax.self)?.type.as(IdentifierTypeSyntax.self)?.name.text == "Codable" }),
              !typeNames.isEmpty
        else {
            throw CustomError.message("Codableは必須です")
        }
        let cases = memberList.compactMap({ member -> String? in
            guard let propertyName = member.decl.as(VariableDeclSyntax.self)?.bindings.first?.pattern.as(IdentifierPatternSyntax.self)?.identifier.text else { return nil }
            if let customeKeyMacro = member.decl.as(VariableDeclSyntax.self)?.attributes.first(where: { element in
                element.as(AttributeSyntax.self)?.attributeName.as(IdentifierTypeSyntax.self)?.description == "CodableKey"
            }) {
                guard let customeKeyValue = customeKeyMacro.as(AttributeSyntax.self)!.arguments!.as(LabeledExprListSyntax.self)!.first?.expression.as(StringLiteralExprSyntax.self)?.segments.first?.as(StringSegmentSyntax.self)?.content.text
                else { return nil }
                return "case \(propertyName) = \"\(customeKeyValue)\""
            } else {
                return "case \(propertyName)"
            }
        })
        
        let codingKeys: DeclSyntax = """
        enum CodingKeys: String, CodingKey {
            \(raw:  cases.joined(separator: "\n"))
        }
        """
        return [codingKeys]
    }
}
        
