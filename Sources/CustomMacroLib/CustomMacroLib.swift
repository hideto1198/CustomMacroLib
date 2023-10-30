@attached(peer)
public macro CodableKey(name: String) = #externalMacro(module: "CustomMacroLibMacros", type: "CodableKey")

@attached(member, names: arbitrary)
public macro CustomCodable() = #externalMacro(module: "CustomMacroLibMacros", type: "CustomCodable")
