public import Serializer
public import Tagged

extension Tagged where Underlying: Serializable, Underlying.Serializer.Output == Underlying {

    /// A serializer that delegates a tagged value to its underlying serializer.
    public struct UnderlyingSerializer: SerializerProtocol {

        @inlinable
        public init() {}
    }
}

extension Tagged.UnderlyingSerializer
where Underlying: Serializable, Underlying.Serializer.Output == Underlying {

    public typealias Output = Tagged<Tag, Underlying>

    public typealias Buffer = Underlying.Serializer.Buffer

    public typealias Failure = Underlying.Serializer.Failure

    public typealias Body = Never

    @inlinable
    public borrowing func serialize(
        _ output: Tagged<Tag, Underlying>,
        into buffer: inout Underlying.Serializer.Buffer
    ) throws(Underlying.Serializer.Failure) {
        try Underlying.serializer.serialize(output.underlying, into: &buffer)
    }
}

extension Tagged: @retroactive Serializable
where
    Underlying: Serializable,
    Underlying.Serializer.Output == Underlying
{

    /// The underlying value's serializer, lifted to this tag.
    @inlinable
    public static var serializer: Tagged<Tag, Underlying>.UnderlyingSerializer {
        Tagged<Tag, Underlying>.UnderlyingSerializer()
    }
}
