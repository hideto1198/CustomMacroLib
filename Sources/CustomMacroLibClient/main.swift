import CustomMacroLib

@CustomCodable
struct Test {
    @CodableKey(name: "OtherName")
    var propertyWithOtherName: String
    var propertyWithSameName: String
}

struct State: Equatable {
    var base: Base
}

@Base(propertyName: "base")
extension State {
    struct Base: Equatable {
        var property1: String
        var property2: Bool
        var property3: Int
    }
}
