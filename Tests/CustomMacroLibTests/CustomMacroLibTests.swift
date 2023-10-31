import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CustomMacroLibMacros)
import CustomMacroLibMacros

let testMacros: [String: Macro.Type] = [
    "CodableKey": CodableKey.self,
    "CustomCodable": CustomCodable.self,
    "Base": Base.self
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
    
    func testBaseState() throws {
        assertMacroExpansion(
            """
            @Base(propertyName: "base")
            extension Store.State {
                var property3: String { return "" }
                struct Base: Equatable {
                    var property1: String
                    var property2: Bool
                }
            
                struct BaseFake: Equatable {
                    var property4: Int
                }
            }
            """,
            expandedSource:
            """
            extension Store.State {
                var property3: String { return "" }
                struct Base: Equatable {
                    var property1: String
                    var property2: Bool
                }
            
                struct BaseFake: Equatable {
                    var property4: Int
                }
            
                var property1: String {
                    get {
                        base.property1
                    }
                    set {
                        base.property1 = newValue
                    }
                }
                var property2: Bool {
                    get { base.property2 }
                    set { base.property2 = newValue }
                }
            }
            """,
            macros: testMacros)
    }
}
