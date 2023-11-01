@attached(peer)
public macro CodableKey(name: String) = #externalMacro(module: "CustomMacroLibMacros", type: "CodableKey")

@attached(member, names: arbitrary)
public macro CustomCodable() = #externalMacro(module: "CustomMacroLibMacros", type: "CustomCodable")

@attached(member, names: arbitrary)
public macro Base(propertyName: String) = #externalMacro(module: "CustomMacroLibMacros", type: "Base")

@attached(peer)
public macro DependencyClient() = #externalMacro(module: "CustomMacroLibMacros", type: "DependencyClient")
