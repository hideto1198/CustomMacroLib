import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(CustomMacroLibMacros)
import CustomMacroLibMacros

let testMacros: [String: Macro.Type] = [
    "CodableKey": CodableKey.self,
    "CustomCodable": CustomCodable.self,
    "Base": Base.self,
    "DependencyClient": DependencyClient.self,
    "Client": Client.self
]
#endif

final class CustomCodableTests: XCTestCase {
    func testCodableKey() throws {
#if canImport(CustomMacroLibMacros)
        assertMacroExpansion(
            """
            @CustomCodable
            struct Test: Codable, Equatable {
                @CodableKey(name: "OtherName1")
                var propertyWithOtherName1: String
                var propertyWithSameName: String
                @CodableKey(name: "OtherName2")
                var propertyWithOtherName2: String
            }
            """,
            expandedSource: """
            struct Test: Codable, Equatable {
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
    
    func testCodableKeyFiailureNotInheritedCodable() throws {
#if canImport(CustomMacroLibMacros)
        assertMacroExpansion(
            """
            @CustomCodable
            struct Test {
                @CodableKey(name: "OtherName1")
                var propertyWithOtherName1: String
                var propertyWithSameName: String
                @CodableKey(name: "OtherName2")
                var propertyWithOtherName2: String
            }
            """,
            expandedSource: """
            struct Test {
                var propertyWithOtherName1: String
                var propertyWithSameName: String
                var propertyWithOtherName2: String
            }
            """,
            diagnostics: [
                DiagnosticSpec(message: "message(\"Codableは必須です\")", line: 1, column: 1)
            ],
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testBaseState() throws {
#if canImport(CustomMacroLibMacros)
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
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    // アンチパターン
    func testBaseStateFailureOnStruct() throws {
#if canImport(CustomMacroLibMacros)
        assertMacroExpansion(
            """
            @Base(propertyName: "base")
            struct State: Equatable {}
            """,
            expandedSource:
            """
            struct State: Equatable {}
            """,
            diagnostics: [
                DiagnosticSpec(message: "message(\"このマクロはExtensionにのみ有効です\")", line: 1, column: 1)
            ],
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testBaseStateFailureOnOtherExtension() throws {
#if canImport(CustomMacroLibMacros)
        assertMacroExpansion(
            """
            @Base(propertyName: "base")
            extension State.OtherState: Equatable {}
            """,
            expandedSource:
            """
            extension State.OtherState: Equatable {}
            """,
            diagnostics: [
                DiagnosticSpec(message: "message(\"Stateの拡張でのみ使用可能です\")", line: 1, column: 1)
            ],
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testBaseStateFailureOnProperty() throws {
#if canImport(CustomMacroLibMacros)
        assertMacroExpansion(
            """
            extension State.OtherState: Equatable {
                @Base(propertyName: "base")
                var property: String
            }
            """,
            expandedSource:
            """
            extension State.OtherState: Equatable {
                var property: String
            }
            """,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }

    func testDependencyClient() throws {
#if canImport(CustomMacroLibMacros)
        assertMacroExpansion(
            """
            @DependencyClient
            struct TestClient {
            }
            
            @DependencyClient
            struct TrackingClient {
            }
            """,
            expandedSource:
            """
            struct TestClient {
            }
            
            extension DependencyValues {
                var testClient: TestClient {
                    get {
                        self [TestClient.self]
                    }
                    set {
                        self [TestClient.self] = newValue
                    }
                }
            }
            struct TrackingClient {
            }
            
            extension DependencyValues {
                var trackingClient: TrackingClient {
                    get {
                        self [TrackingClient.self]
                    }
                    set {
                        self [TrackingClient.self] = newValue
                    }
                }
            }
            """,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
    
    func testClient() throws {
#if canImport(CustomMacroLibMacros)
        assertMacroExpansion(
            """
            struct TestClient: Equatable {
            }
            
            @Client(type: TestClient.self)
            extension DependencyValues {}
            """,
            expandedSource:
            """
            struct TestClient: Equatable {
            }
            extension DependencyValues {
            
                var testClient: TestClient {
                    get {
                        self [TestClient.self]
                    }
                    set {
                        self [TestClient.self] = newValue
                    }
                }}
            """,
            macros: testMacros)
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
