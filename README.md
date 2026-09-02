# swift-tagged-serializer

Focused Serializer integration for the Tagged domain.

`Tagged Serializer` makes a tagged value `Serializable` whenever its underlying
value is serializable as itself. The adapter preserves the underlying
serializer's buffer and failure types while unwrapping the tag before emitting.
