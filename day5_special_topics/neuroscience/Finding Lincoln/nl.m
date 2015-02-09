function[y] = nl(x)
% y = nl(x)
% normalizes a set of values over range MAX-MIN
MAX = max(x(:));
MIN = min(x(:));
y = (x - MIN) ./ (MAX - MIN);
