import CustomMacroLib

@CustomCodable
struct Test: Codable, Equatable {
    @CodableKey(name: "OtherName")
    var propertyWithOtherName: String
    var propertyWithSameName: String
}

struct Store {
    struct State: Equatable {
        var base: Base
    }
}

@Base(propertyName: "base")
extension Store.State {
    struct Base: Equatable {
        var property1: String
        var property2: Bool
        var property3: Int
    }
}

@DependencyClient
struct TestClient: Equatable {
    
}

let testClient = TestClient()
print(testClient.test)
