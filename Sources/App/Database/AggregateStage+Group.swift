//
// Created by rafael on 2/23/22.
//

import MongoKitten

extension AggregateBuilderStage {
    public static func group(_ query: Document) -> AggregateBuilderStage {
        AggregateBuilderStage(document: [
            "$group": query
        ])
    }

    public static func group<Q: MongoKittenQuery>(_ query: Q) -> AggregateBuilderStage {
        AggregateBuilderStage(document: [
            "$group": query.makeDocument()
        ])
    }
}

public func group(_ query: Document) -> AggregateBuilderStage {
    .group(query)
}

public func group<Q: MongoKittenQuery>(_ query: Q) -> AggregateBuilderStage {
    .group(query.makeDocument())
}
