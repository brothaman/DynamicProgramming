function [val, n] = nearest2(val,arr) 
	%NEAREST2 get the value and index in the array given nearest to the
	%given value 
	%	val should be a scalar value 
	%	arr should be a one dimensional array
	vec = abs(arr - val);
	[val,n] = min(vec);
	val = arr(val == vec);
end