for relation, G in graphs.items():
    families = list(nx.weakly_connected_components(G))
    for i, family in enumerate(families):
        if any(nx.has_path(G, u, v) and nx.has_path(G, v, u) for u, v in itertools.combinations(family, 2)):
            print(f"Loop found in relation {relation}. Family {i+1}: {family}")
        else:
            print(f"No loops found in relation {relation}. Family {i+1}: {family}")
