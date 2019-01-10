function evaluatedCostNetwork = evaluateConnections(parameters, costNetwork,connectionNetwork)
	% for each stage in the connection network
	%	for each stage in the connection
	%		check to see if the has a better value than the one stored in
	%		the cost network. if there is no connection stored in the cost
	%		network i.e. the optimal policy and optimal value are not set
	%		then this connection should take the place
	for i = 1:length(connectionNetwork)
		for j = 1:size(connectionNetwork,1) 
			% for each row in the stage of the connection network. a row
			% stores a connection in the form [state_i, state_i+1, action]
			node(j) = evaluateConnection(costNetwork, connectionNetwork{i}(j,:));
		end
	end
end

function node = evaluateConnection(costNetwork, connection)
	node = [];
	L = (length(connection)-1)/2;
	sz = size(costNetwork);
	concuridx = arrsub2ind(sz, connection(1:L));	% current state index
	connxtidx = arrsub2ind(sz, connection(L+1:end-1));
	
	%% some logic determining whether or not to update the node
	% begin:
	
	% - connection to get to the optimal next state
	plcy = costNetwork{concuridx}.optimal_policy;
	
	% - get the cost of the current connection
	currentCost = costNetwork{concuridx}.optimal_value;
	
	% -- stops
	% if the state with the connection is empty then 
	if isempty(costNetwork{connxtidx}.optimal_value)
		return
	end
	
	% NAN signifies a state whose optimal value is not set. if the optimal
	% value isnt set then add the node as the optimal value
	if isnan(currentCost)
		node = costNetwork{concuridx};
		node.optimal_policy = connection(end);
		node.optimal_value =...
			costNetwork{connxtidx}.optimal_value +...
			costNetwork{concuridx}.connections{connection(end)}(end);
		return
	end
	% -- stops
	
	% - get the cost of the new connection: (next state optimal value) + (the
	% cost to get there)
	newCost = costNetwork{connxtidx}.optimal_value + ...
		costNetwork{concuridx}.connections{connection(end)}(end);
	
	% - compare the cost ## put a few stops before here to prevent NANs##
	if newCost < currentCost
		% update new cost 
		node = costNetwork{concuridx};
		node.optimal_policy = connection(end);
		node.optimal_value = newCost;
	else
		% return and do nothing
		return
	end
	
end

function index = arrsub2ind(sz,arrsub)
	alteredsize = [1 sz(1:end-1)];
	index=1;
	for i = 1:length(arrsub)
		index = index + (arrsub(i)-1)*prod(alteredsize(1:i));
	end
end

function arr = extract_state(arrsub, states)
	arr = nan(size(states));
	for i = 1:length(states)
		arr(i) = states{i}(arrsub(i));
	end
end
% function network = evaluateConnections(parameters,output_filename, network)
% 	% set the goal node 
% 	data = load(parameters.filename,'connections');
% 	connections = data.connections;
% 	network{parameters.goal(1),parameters.goal(2)}.optimal_value = 0;
% 	network{parameters.goal(1),parameters.goal(2)}.optimal_policy = nan;
% 	%[filename,i,network,connection_network,connections, t, ids,previous_ids,maxconns] = weak_actuation_init();
% 	% for each level of connection in the connection network cycle through all
% 	% the nodes and evaluate the connection. if a connection exist and the
% 	% compare the value and store the policy and value of the lower value
% % 	len = length(connections);
% % 	iterations = 2;
% % 	net = cell(size(network));
% % 	[N,M] = size(network);
% 	n = sum(any(~cellfun('isempty',connections),2));
% 	% loop through each stage and evaluate the connection
% 	% for each stage in the connection network
% 	
% 	
% 	for i = 1:n
% 	% 	check to see if the stage has any connection
% 		if isempty(connections{i})
% 			break;
% 		end
% 		tic
% 	% 	determine the actual number of connections in the stage
% 		m = find(~cellfun('isempty',connections{i}))';
% 		nodes = cell(length(m),parameters.maxconns);
% 
% 	% 	for each connection in the stage check and see if it is a better
% 	% 	solution than the current
% 		for l = 1:length(m)
% 			j = m(l);
% 			len = size(connections{i}{j},1);
% 			
% 			% get the current node
% 			node = cell(1,parameters.maxconns);
% 			for k = 1:len
% 				% connections (the cell array) has connections to evaluate
% 				% stored in it.
% 				% pass the current node,
% 				node(k)  = evaluate_connection(...
% 					network,...
% 					network{connections{i}{j}(k,1),connections{i}{j}(k,2)},...
% 					[network{connections{i}{j}(k,1),connections{i}{j}(k,2)}.connections{connections{i}{j}(k,3)} connections{i}{j}(k,3)]);
% 			end
% 			nodes(l,:) = node;
% 		end
% 		nodes = reshape(nodes,[numel(nodes),1]);
% 		for j = 1:length(nodes)
% 			if ~isempty(nodes{j})
% 				network{nodes{j}(1),nodes{j}(2)}.optimal_policy = nodes{j}(3);
% 				network{nodes{j}(1),nodes{j}(2)}.optimal_value = nodes{j}(4);
% 			end
% 		end
% 		teval(i) = seconds(toc);
% 	end
% 	teval.Format = 'hh:mm:ss';
% 	save(output_filename,'network','teval');
% end
% 
% %% functions
% function conn = evaluate_connection(network,node, connection)
%     conn = {[]};
%     if isempty(network{connection(1), connection(2)}.optimal_value)
%         return
%     else
%         % since the destination node has been evaluated we can now
%         % determine whether the connection is desireable
%         % if the policy and value do not exit
%         % if  isempty(node.optimal_value) && isempty(node.optimal_policy)
%         value = connection(4) + network{connection(1), connection(2)}.optimal_value;
%         if  isempty(node.optimal_value) || isnan(node.optimal_value)
% %             optimal_policy = connection(5);
% %             optimal_value = value;
% %				return the nodeid the optimal next step and the optimal
% %				value
% %             conn = [node.ID optimal_policy optimal_value];
%             conn = {[node.ID connection(5) value]};
%         else
%             % compare the node and update if a better policy exist
%             % otherwise do nothing
%             if node.optimal_value > value
% %                 optimal_policy = connection(5);
% %                 optimal_value = value;
% %                 conn = [node.ID optimal_policy optimal_value];
%                 conn = {[node.ID connection(5) value]};
%             end
%         end
%     end
% end
% 
% function [filename,i,network,connection_network,connections, t, ids,previous_ids, maxconns] = standard_init()
%     maxconns = 50;
%     filename = '../lib/cost_network.mat';
%     load(filename);
%     % set the goal node 
%     network{51,101}.optimal_value = 0;
%     network{51,101}.optimal_policy = 9;
% end
% 
% function [filename,i,network,connection_network,connections, t, ids,previous_ids, maxconns] = underactuated_init()
%     maxconns = 50;
%     filename = '../lib/underactuated_cost_network.mat';
%     load(filename);
%     % set the goal node 
%     network{51,101}.optimal_value = 0;
%     network{51,101}.optimal_policy = 5;
% end
% 
% function [filename,i,network,connection_network,connections, t, ids,previous_ids, maxconns] = very_weak_actuation_init()
%     maxconns = 50;
%     filename = '../lib/very_weak_cost_network.mat';    
%     load(filename);
%     % set the goal node 
%     network{51,101}.optimal_value = 0;
%     network{51,101}.optimal_policy = 1;
% end
% 
% function [filename,i,network,connection_network,connections, t, ids,previous_ids, maxconns] = weak_actuation_init()
%     maxconns = 50;
%     filename = '../lib/weak_cost_network.mat';    
%     load(filename);
%     % set the goal node 
%     network{51,101}.optimal_value = 0;
%     network{51,101}.optimal_policy = 1;
% end
