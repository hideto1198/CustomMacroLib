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
    func testCodableKey() throws {
        #if canImport(CustomMacroLibMacros)
        assertMacroExpansion(
            """
            @CustomCodable
            struct Test: Codable {
                @CodableKey(name="OtherName1")
                var propertyWithOtherName1: String
                var propertyWithSameName: String
                @CodableKey(name="OtherName2")
                var propertyWithOtherName2: String
            }
            """,
            expandedSource: """
            struct Test: Codable {
                var propertyWithOtherName1: String
                var propertyWithSameName: String
                var propertyWithOtherName2: String
            
                enum CodingKeys: String, CodingKey {
                    case propertyWithOtherName1 = "OtherName1"
                    case propertyWithSameName
                    case propertyWithOtherName2 = "OtherName2"
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
