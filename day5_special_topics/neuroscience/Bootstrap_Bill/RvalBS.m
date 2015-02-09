function [r] = RvalBS(R)

% bsRval.m: version of dirCoM for use with bootstrap
%
% Inputs:
% - R, vector of magnitudes (e.g. spike rates)
% 
% Outputs:
% - r, normalized magnitude of mean vector; (1 - r) is the circular variance
%
% see Zar, pp.598-601
%
% RTB kluged it, 23 May 2011
% AS renamed bsRval -> RvalBS to follow QMBC convention

% NOTE WELL: assumes that direction sampled at even intervals around
% circle:
ndirs = size(R,2);
TH = deg2rad([0:360/ndirs:360-(360/ndirs)]);

if ~isvector(R), R = nanmean(R); end
[x y] = pol2cart(TH,R);
norm = sum(R);

if norm == 0
   th = NaN;
   r = 0;
else
   [th, r] = cart2pol((sum(x)./ norm), (sum(y) ./ norm));
end

% fix conversion errors for cart2pol
if r < 0.00001
    r = 0;
    th = NaN;
end
