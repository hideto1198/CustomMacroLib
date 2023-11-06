@attached(peer)
public macro CodableKey(name: String) = #externalMacro(module: "CustomMacroLibMacros", type: "CodableKey")

@attached(member, names: arbitrary)
public macro CustomCodable() = #externalMacro(module: "CustomMacroLibMacros", type: "CustomCodable")

@attached(member, names: arbitrary)
public macro Base(propertyName: String) = #externalMacro(module: "CustomMacroLibMacros", type: "Base")

@attached(extension, names: arbitrary)
public macro DependencyClient() = #externalMacro(module: "CustomMacroLibMacros", type: "DependencyClient")

@attached(member, names: arbitrary)
public macro Client<T>(type: T.Type) = #externalMacro(module: "CustomMacroLibMacros", type: "Client")
