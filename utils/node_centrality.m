function  [node, c] = node_centrality(net_mat, type, k)
% return different centrality of each node 1 * N
% input:
%   net_mat: adjacency matrix form of the given network.
%   type: 'degree', 'closeness', 'betweenness', 'pagerank', 'eigenvector'
%   k: int, return top k node 1*k
% output:
%   node: return top k node index 1*k
%   c: centrality of each node 1 * N

    c = centrality(graph(net_mat), type);
    [~, node] = sort(c, 'descend');
    node = node(1:k);
end