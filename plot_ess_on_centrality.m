% Run simulation first.
% [~, mean_ratio, ~, ~] = sim_DB_sync_ctrl_script(pm, net_mat, alph, T, p_ini, repeat_num, is_zlt, zealots);
% Then calculate the theoretic results.
% [~, total_result] = temporal_solver(net_mat, alph, p_ini, T, pm, is_zlt, zealots);
% theo_mean_ratio = sum(total_result);

% plot ess over different number of seed user, considering five different node centrality
clc; clear;
%load data and parameters
load('networks\facebook_net.mat');
T = 300;% 可调 稳定
pm = wrapPayoff(0.4, 0.6,0.6,1);% fixed
alph = 0.1;% fixed
repeat_num = 1000;% 可调
is_zlt = true;
results = [];
theorys = [];
types = {'degree', 'closeness', 'betweenness', 'pagerank', 'eigenvector'};
for i = 1:length(types)
    result = [];
    theory = [];    
    for k = [2,4,6,8,10]
        [p_ini, ~] = node_centrality(net_mat, types{i}, k);
        zealots = p_ini;
        [~, mean_ratio, ~, ~] = sim_DB_sync_ctrl_script(pm, net_mat, alph, T, p_ini, repeat_num, is_zlt, zealots);
        [~, total_result] = temporal_solver(net_mat, alph, p_ini, T, pm, is_zlt, zealots);
        sim_mean = mean( mean_ratio(T*0.9+1 : end) ); %mean value of last 10% T
        result = [result sim_mean]; % 1*5
        theory_mean = sum(total_result); % sum
        theory = [theory theory_mean(T)]; % stable ess at T 1*5
    end
    results = [results; result];
    theorys = [theorys; theory];
end

figure();
x = [2,4,6,8,10];
for i = 1:length(theorys)
    plot(x, results(i,:), 'o-');
    hold on
    plot(x, theorys(i,:), '*--');
    hold on
end
% legend('degree', 'closeness', 'betweenness', 'pagerank', 'eigenvector');
legend('sim-degree', 'theory-degree','sim-closeness', 'theory-closeness','sim-betweenness', 'theory-betweenness',...
'sim-pagerank', 'theory-pagerank','sim-eigenvector', 'theory-eigenvector');
xlabel('k'); ylabel('ESS');



