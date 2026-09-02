public import Serializer
public import Tagged

extension Tagged::Tagged
where Underlying: Serializable, Underlying.Serializer.Output == Underlying {

    public struct UnderlyingSerializer {

        @inlinable
        public init() {}
    }
}

extension Tagged::Tagged.UnderlyingSerializer: Serializer::Serializer.`Protocol`
where
    Underlying: Serializable,
    Underlying.Serializer.Output == Underlying
{

    public typealias Output = Tagged::Tagged<Tag, Underlying>

    public typealias Buffer = Underlying.Serializer.Buffer

    public typealias Failure = Underlying.Serializer.Failure

    public typealias Body = Never

    @inlinable
    public borrowing func serialize(
        _ output: Tagged::Tagged<Tag, Underlying>,
        into buffer: inout Underlying.Serializer.Buffer
    ) throws(Underlying.Serializer.Failure) {
        try Underlying.serializer.serialize(output.underlying, into: &buffer)
    }
}

extension Tagged::Tagged: @retroactive Serializable
where
    Underlying: Serializable,
    Underlying.Serializer.Output == Underlying
{

    @inlinable
    public static var serializer: Tagged::Tagged<Tag, Underlying>.UnderlyingSerializer {
        Tagged::Tagged<Tag, Underlying>.UnderlyingSerializer()
    }
}
