//
//  Client.swift
//  
//
//  Created by 東　秀斗 on 2023/11/05.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct Client: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let extensionDecl = declaration.as(ExtensionDeclSyntax.self) else { throw CustomError.message("only for extensions") }
        guard let propertyType = extensionDecl.attributes.as(AttributeListSyntax.self)?.first?.as(AttributeSyntax.self)?.arguments?.as(LabeledExprListSyntax.self)?.first?.as(LabeledExprSyntax.self)?.expression.as(MemberAccessExprSyntax.self)?.base?.as(DeclReferenceExprSyntax.self)?.baseName.text
        else {
            throw CustomError.message("need a argument")
        }
        let propertyName = propertyType.camelCased
        let subscriptSyntax: SubscriptCallExprSyntax = SubscriptCallExprSyntax(calledExpression: DeclReferenceExprSyntax(baseName: .keyword(.self)),
                                                                               arguments:LabeledExprListSyntax([
                                                                                LabeledExprSyntax(expression:
                                                                                                    MemberAccessExprSyntax(base: DeclReferenceExprSyntax(baseName: .identifier(propertyType)),
                                                                                                                           name: .keyword(.self) ))
                                                                               ]))
        let accessorBlock: AccessorBlockSyntax = AccessorBlockSyntax(accessors: .accessors(
            AccessorDeclListSyntax() {
                AccessorDeclSyntax(accessorSpecifier: .keyword(.get)) {
                    subscriptSyntax
                }
                AccessorDeclSyntax(accessorSpecifier: .keyword(.set)) {
                    InfixOperatorExprSyntax(leftOperand: subscriptSyntax,
                                            operator: AssignmentExprSyntax(equal: TokenSyntax("=")),
                                            rightOperand: DeclReferenceExprSyntax(baseName: TokenSyntax("newValue")))
                }
            }))
        let patternSyntax: PatternBindingSyntax = .init(pattern: PatternSyntax(stringLiteral: propertyName),
                                                        typeAnnotation: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: propertyType)),
                                                        accessorBlock: accessorBlock)
        let variableBuilder = VariableDeclSyntax(bindingSpecifier: .keyword(.var), bindings: .init([patternSyntax]))
        let members = MemberBlockItemListSyntax([MemberBlockItemSyntax(decl: variableBuilder)])
        let result = ExtensionDeclSyntax(
            extendedType: TypeSyntax(stringLiteral: propertyType),
            memberBlock: MemberBlockSyntax(members: members)
        )
        return [DeclSyntax(variableBuilder)]
    }
}
