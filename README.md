# CustomMacroLib
Swift Macrosを少し勉強し、実際に使えそうなものをサンプル等参考に作成しました。

## CustomCodable & CodableKey
`@CustomCodable`と`@CodableKey(name:)`を使用することで、CodingKeysのコードを自動生成することが可能です。
入力ミスを防ぐことが可能で、コードの可読性も上がります。

before
```swift
struct Something: Codable {
    var property1: String
    var property2: Bool

    enum CodingKeys: String, CodingKey {
        case property1 = "otherName"
        case property2
    }
}
```
after
```swift
@CustomCodable
struct Something: Codable {
    @CodableKey(name: "OtherName")
    var property1: String
    var property2: Bool
}

/* expanded
struct Something: Codable {
    @CodableKey(name: "OtherName")
    var property1: String
    var property2: Bool

    enum CodingKeys: String, CodingKey {
        case property1 = "otherName"
        case property2
    }
}
*/
```

## Base
TCA用のマクロです。用途は限られていますが、BaseをStateに展開したい時に便利です。
展開するメリットは、マクロで、`extension Store.State`内にBaseのプロパティのコンピューテッドプロパティを自動生成するのでReducer内からbaseにアクセスする際に少し楽ができます。

before
```swift
struct Store: Reducer {
    struct State: Equatable {
        var base: Base
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .test:
                state.base.property1 = "test" // ← baseを指定しないといけない
                return .none
            }            
        }
    }
}

extension Store.State {
    struct Base: Equatable {
        var property1: String = ""
    }
}
```
after
```swift
struct Store: Reducer {
    struct State: Equatable {
        var base: Base
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .test:
                state.property1 = "test" // ← baseを指定しなくても良い
                return .none
            }            
        }
    }
}

@Base(name: "base")
extension Store.State {
    struct Base: Equatable {
        var property1: String = ""
    }
}

/* expanded
extension Store.State {
    struct Base: Equatable {
        var property1: String = ""
    }

    var property1: String {
        get { base.property1 } ← @Base(name:)の引数がState内の変数と一致する
        set { base.property1 = newValue }
    }
}
*/
```

## ~~DependencyClient~~

~~TCAのDependencyValuesのextensionを自動生成します。~~

before
```swift
struct SomeClient {}

extension DependencyValues {
    var someClient: SomeClient {
        get { self[SomeClient.self] }
        set { self[SomeClient.self] = newValue }
    }
}
```

after
```swift
@DependencyClient
struct SomeClient {}

/* expanded
extension DependencyValues {
    var someClient: SomeClient {
        get { self[SomeClient.self] }
        set { self[SomeClient.self] = newValue }
    }
}
*/
```
