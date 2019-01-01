function [connectionNetwork] = generateConnectionNetwork(costNetwork,parameters)
	%GENERATECONNECTIONNETWORK Summary of this function goes here
	%   Detailed explanation goes here
	allConnections = getConnectionsfromCostNetwork(costNetwork);
	idToSearch = [1 1];
	connectionNetwork = [2 2 1 1];
	connectionNetwork = build_connection_network(costNetwork, parameters, allConnections);
% 	connection_network = convert_network(network);
% 	steps = 1000;
% 	ids = connection_network(~any(parameters.goal - connection_network(:,[1 2]),2),[1 2 4 5]);
% 	connections = cell(steps,1);
% 	parameters.maxconns = 0;
% 	for i = 1:steps
% 		tic
% 		if i > 1
% 			[connections{i},maxcon] = parnetwork_search3(connection_network, ids, previous_ids);
% 			if maxcon > parameters.maxconns
% 				parameters.maxconns = maxcon;
% 			end
% 			ids = cell2mat(connections{i});
% 			previous_ids = [previous_ids; ids(:,[1 2 4 5])];
% 			previous_ids = unique(previous_ids,'rows');
% 		else
% 			connections{i} = network_search3(connection_network, ids(1,1:2));
% 			previous_ids = ids;
% 		end
% 
% 		t(i) = seconds(toc);
% 		save(parameters.filename,'parameters','i','connection_network','connections', 't', 'ids','previous_ids','-append')
% 		ids = cell2mat(connections{i});
% 		ids = ids(:,[1 2]);
% 		ids = unique(ids,'rows');
% 		if isempty(ids)
% 			break;
% 		end
% 	end
end
%% Functions
function connectionNetwork = build_connection_network(network, parameters, all_connections)
	storedConnections = [];
	for i = 1:size(parameters.goal,1)
		connections{i} = network_search(all_connections, parameters.goal(i,:), []);
	end
	
	newConnections = cell2mat(connections);
	connectionNetwork{1} = newConnections;
	storedConnections = [storedConnections; newConnections];
	
	L = (size(newConnections,2))/2;
	for i = 1:size(newConnections,1)
		connections{i} = network_search(all_connections, newConnections(i,1:L), storedConnections);
	end
	newConnections = cell2mat(connections);
	connectionNetwork{2} = newConnections;
	storedConnections = [storedConnections; newConnections];
end

function connections = network_search(all_connections, idToSearch, storedConnections)
	L = (length(all_connections(1,:))-2)/2;
	connections = all_connections(~any(all_connections(:,L+1:end-2) - idToSearch,2),:);
	connections = connections(:,1:end-2);
	
	for i = 1:size(connections,1)
		% check to see if the connections are already in the connection
		% network
		if checkIfConnectionisinConnectionNetwork(connections(i,:), storedConnections)
			connections(i,:) = [];
		end
	end
% 	for i = 1:numel(network)
% 		for j = 1:numel(network{i}.connections)
% 			newstateid = network{i}.connections{j}(1:end-2);
% 			if sum(abs(idToSearch - newstateid)) == 0
% 				% if the ID of the new state and the ID in which we're
% 				% interested match then this state "i" has a connection
% 				% that exist. also since there is only unique connections
% 				% between states we can assume that this is the only
% 				% connection to the new state in this current state
% 				if checkIfConnectionisinConnectionNetwork(idToSearch, connectionNetwork)
% 					break
% 				end
% 				connection = [network{i}.ID network{i}.connections{j}(end-1) idToSearch];
% 				connections{end+1} = connection;
% 				break
% 				
% 			end
% 		end
% 	end
end

function isit = checkIfConnectionisinConnectionNetwork(connection, storedConnections)
	isit = false;
	if isempty(storedConnections)
		return
	end
	
	if sum(~any(storedConnections - connection,2))
		isit = true;
		return
	end
% 	L = (length(connecionNetwork{1}{1})-1)/2;
% 	for i = 1:length(storedConnections)
% 		for j = 1:length(storedConnections{i})
% 			if sum(abs(connection - connecitonNetowrk{i}{j}(L+1:end))) == 0
% 				isit = true;
% 				return
% 			end
% 		end
% 	end
end

function [all_connections] = getConnectionsfromCostNetwork(network)
	all_connections = [];
	for i = 1:numel(network)
		for j = numel(network{i}.connections)
% 			try
				all_connections(end+1,:) = [network{i}.ID network{i}.connections{j}];
% 			catch
% 				disp('initializing all connections')
% 				all_connections = network{i}.connections{j};
% 			end
		end
	end
end

function [connections,maxconns] = parnetwork_search3(network, ids, previous_ids)
    len = size(ids,1);
    connections = cell(len,1);
    maxconns = 0;
    parfor i = 1:len
        % if previous id's [4,5] is equal to current id's [1,2] and current
        % id's [4,5] is equal to previous id's [1,2] then eliminate current
        % id's connection that correlate with [4,5]. delete current id's
        % [4,5]
        connections{i} = network(~any(ids(i,[1,2]) - network(:,[4,5]),2),:);
        
        % this will eliminate any connections back to the previous
        for j = 1:size(previous_ids,1)
            connections(i) = {connections{i}(any(previous_ids(j,:) - connections{i}(:,[1 2 4 5]),2),:)};
            if isempty(connections{i})
                break;
            end
        end
    end
    for i = 1:length(connections)
        if ~isempty(connections{i})
            if size(connections{i},1) > maxconns
                maxconns = size(connections{i},1);
            end
        end
    end
end

function [connections] = network_search3(network, ids)
    len = size(ids,1);
    connections = cell(len,1);
    for i = 1:len
        connections{i} = network(~any(ids(i,[1,2]) - network(:,[4,5]),2),:);
    end
end

function new_network = convert_network(network)
    [n,m] = size(network);
    max_cons = 21;
    new_network = zeros(n*m*max_cons,2+1+2);
    for i = 1:n
        for j = 1:m
            len = length(network{i,j}.connections);
            for k = 1:max_cons
                if k > len
                    break;
                end
                new_network((i-1)*max_cons*m + (j-1)*max_cons + k,:) = ...
                    [ i j k network{i,j}.connections{k}(1:2)];
            end
        end
    end
    new_network = new_network(any(new_network,2),:);
end

