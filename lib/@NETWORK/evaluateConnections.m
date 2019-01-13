function evaluatedCostNetwork = evaluateConnections(parameters, costNetwork, connectionNetwork)
	% for each stage in the connection network
	%	for each stage in the connection
	%		check to see if the has a better value than the one stored in
	%		the cost network. if there is no connection stored in the cost
	%		network i.e. the optimal policy and optimal value are not set
	%		then this connection should take the place
	for i = 1:length(connectionNetwork)
		for j = 1:size(connectionNetwork{i},1) 
			% for each row in the stage of the connection network. a row
			% stores a connection in the form [state_i, state_i+1, action]
			node = evaluateConnection(costNetwork, connectionNetwork{i}(j,:));
			if ~isempty(node)
				nodes(j) = node;
			end
		end
		
		% if there are no nodes then we should continue because there are
		% no updates that need be made to the cost network
		if ~exist('nodes','var')
			continue
		end
		
		% update the cost network with the improvements found
		for j = 1:length(nodes)
			index = arrsub2ind(size(costNetwork),nodes(j).ID);
			costNetwork{index} = nodes(j);
		end
		
		% end of loop clean up
		clear nodes
	end
	evaluatedCostNetwork = costNetwork;
end

%% Functions
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
		newCost =...
			costNetwork{connxtidx}.optimal_value +...
			costNetwork{concuridx}.connections{connection(end)}(end);
		node = build_node(costNetwork{concuridx}, connection(end), newCost);
		return
	end
	% current matlab is incapable of performing "or"  operation with array
	% and array
	if isempty(currentCost)
		newCost =...
			costNetwork{connxtidx}.optimal_value +...
			costNetwork{concuridx}.connections{connection(end)}(end);
		node = build_node(costNetwork{concuridx}, connection(end), newCost);
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
		node = build_node(costNetwork{concuridx}, connection(end), newCost);
	else
		% return and do nothing
		return
	end
	
end

function node = build_node(node, optimal_policy, optimal_value)
	node.optimal_value = optimal_value;
	node.optimal_policy = optimal_policy;
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

