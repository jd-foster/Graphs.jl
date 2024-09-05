@testset "Eulerian tours/cycles" begin
    # a cycle (identical start/end)
    g0 = GenericGraph(SimpleGraph([Edge(1, 2), Edge(2, 3), Edge(3, 1)]))
    @test eulerian(g0, 1) == eulerian(g0)
    @test last(eulerian(g0, 1)) == 1 # a cycle

    # a tour (different start/end)
    g1_3 = GenericGraph(SimpleGraph([Edge(1, 2), Edge(2, 3)]))
    @test eulerian(g1_3, 3) == [3, 2, 1]
    g1_4 = GenericGraph(SimpleGraph([Edge(1, 2), Edge(2, 3), Edge(3, 4)]))
    @test eulerian(g1_4, 1) == [1, 2, 3, 4]
    # in a graph with an Eulerian trail but not cycle, you have to start at an odd degree vertex
    @test_throws ErrorException(
        "starting vertex has even degree but there are other vertices with odd degree: a eulerian cycle does not exist",
    ) eulerian(g1_3, 2)
    # too many odd degree vertices; Eulerian cycle does not exist
    # 3-pointed star with vertex 1 at the center
    g_star = GenericGraph(SimpleGraph([Edge(1, 2), Edge(1, 3), Edge(1, 4)]))
    @test_throws ErrorException(
        "starting vertex has odd degree but the total number of vertices of odd degree is not equal to 2: a eulerian trail does not exist",
    ) eulerian(g_star, 1)

    # a cycle with a node (vertex 2) with multiple neighbors
    g2 = GenericGraph(
        SimpleGraph([
            Edge(1, 2),
            Edge(2, 3),
            Edge(3, 4),
            Edge(4, 1),
            Edge(2, 5),
            Edge(5, 6),
            Edge(6, 2),
        ]),
    )
    @test eulerian(g2) == eulerian(g2, 1) == [1, 2, 5, 6, 2, 3, 4, 1]

    # graph with odd-degree vertices
    g3 = GenericGraph(
        SimpleGraph([
            Edge(1, 2), Edge(2, 3), Edge(3, 4), Edge(2, 4), Edge(4, 1), Edge(4, 2)
        ]),
    )
    @test_throws ErrorException(
        "starting vertex has even degree but there are other vertices with odd degree: a eulerian cycle does not exist",
    ) eulerian(g3, 1)

    # start/end point not in graph
    @test_throws ErrorException("starting vertex is not in the graph") eulerian(g3, 5)

    # disconnected components
    g4 = GenericGraph(
        SimpleGraph([
            Edge(1, 2),
            Edge(2, 3),
            Edge(3, 1),  # component 1
            Edge(4, 5),
            Edge(5, 6),
            Edge(6, 4),
        ]),
    ) # component 2
    @test_throws ErrorException(
        "graph is not connected: a eulerian cycle/trail does not exist"
    ) eulerian(g4)

    # zero-degree nodes
    g5′ = SimpleGraph(4)
    add_edge!(g5′, Edge(1, 2))
    add_edge!(g5′, Edge(2, 3))
    add_edge!(g5′, Edge(3, 1))
    g5 = GenericGraph(g5′)
    @test_throws ErrorException(
        "some vertices have degree zero (are isolated) and cannot be reached"
    ) eulerian(g5)

    # not yet implemented for directed graphs
    @test_broken eulerian(GenericDiGraph([Edge(1, 2), Edge(2, 3), Edge(3, 1)]))
end
