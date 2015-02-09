function p = ProbHist(R,N,K,nSims)

% Have N people pick a number from 1 to R, inclusive. What is the
% probability of K or more choices of any of the numbers?
%
% p = ProbHist(R,N,K,nSims);
%
% Inputs:
% - R, number of choices (default = 4)
% - N, number of people choosing (default = 75)
% - K, number that chose a certain value (default = 34)
% - nSims, number of simulations to run (default = 10,000)
%
% Outputs:
% - p, probability of this scenario
%
% RTB wrote it, June 2012

% R = 4; N = 60; K = 34; nSims = 10000;

% 16 August 2012 (75 respondents; pick a random # 1-4 inclusive)
% 1=7, 2=24, 3=34, 4=10
% nOne=7; nTwo=24; nThree=34; nFour=10;
% allPicks = [ones(1,nOne), ones(1,nTwo).*2, ones(1,nThree).*3, ones(1,nFour).*4];
% hist(allPicks,4);
% R = 4; N = 75;
% p = ProbHist(4,75,34,10000)

if nargin < 4, nSims = 10000; end
if nargin < 3, K = 34; end
if nargin < 2, N = 75; end
if nargin < 1, R = 4; end

% What does this result look like?
A = randi(R,N,nSims);
Ctrs = zeros(R,nSims);

for iSim = 1:nSims
    for m = 1:R
        Ctrs(m,iSim) = sum(A(:,iSim) == m);
    end
end

p = sum((sum(Ctrs >= K)) > 0) / nSims;
% n = hist(A,1:R);
% figure; bar(x,n(:,1:5));

% For MATLAB show-offs, this can be compressed into a single line of code:
% pp = sum(any(hist(randi(R,N,nSims),1:R) >= K)) / nSims;

