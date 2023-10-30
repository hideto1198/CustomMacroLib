import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CustomMacroLibMacros)
import CustomMacroLibMacros

let testMacros: [String: Macro.Type] = [
    "CodableKey": CodableKey.self,
    "CustomCodable": CustomCodable.self
]
#endif

final class CustomCodableTests: XCTestCase {
    func testMacro() throws {
        #if canImport(CustomMacroLibMacros)
        assertMacroExpansion(
            """
            @CustomCodable
            struct Test: Codable {
                @CodableKey(name="OtherName")
                var propertyWithOtherName: String
                var propertyWithSameName: String
            }
            """,
            expandedSource: """
            struct Test: Codable {
                var propertyWithOtherName: String
                var propertyWithSameName: String
            
                enum CodingKeys: String, CodingKey {
                    case propertyWithOtherName = "OtherName"
                    case propertyWithSameName
                }
            }
            """,
            macros: testMacros
        )
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}
