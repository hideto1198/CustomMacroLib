//
//  File.swift
//  
//
//  Created by 東　秀斗 on 2023/11/01.
//

import SwiftSyntax
import SwiftSyntaxMacros

public struct DependencyClient: ExtensionMacro {
    public static func expansion(of node: AttributeSyntax, attachedTo declaration: some DeclGroupSyntax, providingExtensionsOf type: some TypeSyntaxProtocol, conformingTo protocols: [TypeSyntax], in context: some MacroExpansionContext) throws -> [ExtensionDeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else { throw CustomError.message("structにのみ使用可能です") }
        let propertyType = structDecl.name.text
        let propertyName = structDecl.name.text.camelCased
        
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
            extendedType: TypeSyntax("DependencyValues"),
            memberBlock: MemberBlockSyntax(members: members)
        )
        return [result]
    }
}
