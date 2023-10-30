import CustomMacroLib

@CustomCodable
struct Test {
    @CodableKey(name: "OtherName")
    var propertyWithOtherName: String
    var propertyWithSameName: String
}

