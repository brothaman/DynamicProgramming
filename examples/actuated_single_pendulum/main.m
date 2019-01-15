%% Dynamic programming of an Actuated Single Pendulum
% this is the optimiztion of a single tone actuated pendulum to perfrom a
% upswing from {0,0} to {pi,0}. this was initially used as a test to
% visualize the cost network produced by dynamic programming.


% first we set the test value to zero. this variable is used to for unit
% testing and produces responses to get a look at the values of
% intermediate variables.
testValue = 0;

% second: define the grid of states using a cell of 1D arrays which define 
% whose indices define increments of that state variable. This "states" 
% variable should look like { [s1_1:s1_n] ... [sN_1:sN_m]}.
parameters.states = {(1:100)'/100*pi-pi/2 (-6:.1:6)'};
% Though this can be N dimensions, keep
% in mind that as N increases the required computation time increases with
% N in a power law fashion

% third: define the actions 
parameters.actions = 1:10;

% forth: define the goal states
parameters.goal = [1 1];

% Finally: build the cost network
net = NETWORK(parameters,@transitionFunction,testValue);