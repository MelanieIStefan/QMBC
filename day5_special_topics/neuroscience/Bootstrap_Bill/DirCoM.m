function [th,r] = DirCoM(TH,R)
% dirCoM.m: computes mean vector (Center of Mass) of a circular distribution
%
% computed by summing the vectors and then dividing by the sum
% of the absolute values of the vectors.
%
% [th,r] = DirCoM(TH,R)
%
% Inputs:
% - TH, vector of directions (in radians)
% - R, vector of magnitudes (e.g. spike rates)
% 
% Outputs:
% - th, direction of mean vector in radians (i.e. Preferred Direction)
% - r, normalized magnitude of mean vector; (1 - r) is the circular variance
%
% see Zar, pp.598-601
%
% RTB wrote it, 5/20/97

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
