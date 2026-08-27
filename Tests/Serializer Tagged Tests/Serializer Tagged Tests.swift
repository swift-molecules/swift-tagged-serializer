import Serializer
import Serializer_Tagged
import Tagged
import Testing

private enum IdentifierTag {}

private enum TestFailure: Swift.Error, Equatable {
    case rejected
}

private struct Value: Serializable {
    let rawValue: Int

    static var serializer: ValueSerializer { ValueSerializer() }
}

private struct ValueSerializer: Serializer.`Protocol` {
    typealias Output = Value
    typealias Buffer = [Int]
    typealias Failure = TestFailure
    typealias Body = Never

    func serialize(_ output: Value, into buffer: inout [Int]) throws(TestFailure) {
        guard output.rawValue >= 0 else { throw .rejected }
        buffer.append(output.rawValue)
    }
}

private typealias Identifier = Tagged<IdentifierTag, Value>

@Suite struct `Serializer Tagged Tests` {

    @Test
    func `Tagged is serializable when its underlying value is serializable`() {
        let _: Identifier.UnderlyingSerializer = Identifier.serializer
    }

    @Test
    func `lifted serializer delegates the underlying value`() throws {
        let identifier = Identifier(_unchecked: Value(rawValue: 42))
        let buffer: [Int] = try Identifier.serializer.serialize(identifier)
        #expect(buffer == [42])
    }

    @Test
    func `lifted serializer appends into an existing buffer`() throws {
        let identifier = Identifier(_unchecked: Value(rawValue: 42))
        var buffer = [1, 2]
        try Identifier.serializer.serialize(identifier, into: &buffer)
        #expect(buffer == [1, 2, 42])
    }

    @Test
    func `lifted serializer preserves the underlying failure`() {
        let identifier = Identifier(_unchecked: Value(rawValue: -1))
        var buffer: [Int] = []

        do throws(TestFailure) {
            try Identifier.serializer.serialize(identifier, into: &buffer)
        } catch {
            #expect(error == .rejected)
        }
        #expect(buffer.isEmpty)
    }
}
