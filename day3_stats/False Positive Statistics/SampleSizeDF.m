function [pVals, nSamples] = SampleSizeDF(nInit, nAddObs, nMax, pFlag)

% SampleSizeDF: simulation of false positive effect for flexibility in
% deciding when to stop collecting data (based on Simmons et al. 2011)
%
% Inputs:
% - nInit, # of initial observations prior to first t-test (default, 10)
% - nAddObs, # of additional observations added before next t-test
% - nMax, maximum # of observations to make (default, 50)
% - pFlag, = 1 to plot the result (default = 0)
% 
% Outputs:
% - pVals, p-Value after each t-test
% - nSamples, cumulative # of observations in each sample
%
% RTB wrote it, winter rain storm, 21 Dec 2012; Gill, MA

% Reference:
% Simmons JP, Nelson LD, Simonsohn U. False-positive psychology:
% undisclosed flexibility in data collection and analysis allows presenting
% anything as significant. Psychol Sci. 2011 Nov;22(11):1359-66.

if nargin < 4, pFlag = 0; end
if nargin < 3, nMax = 50; end
if nargin < 2, nAddObs = 1; end
if nargin < 1, nInit = 10; end

% Take two samples from the same normal distribution. Do mu and sigma
% matter? They shouldn't, because of the nature of a p-value.
myMu = 100; mySigma = 10;
A = normrnd(myMu, mySigma, [nInit, 1]);
B = normrnd(myMu, mySigma, [nInit, 1]);

nSamples = nInit:nAddObs:nMax;
%% pValues = ones(size(nSamples)) .* NaN;

for iSample = 1:length(nSamples)
    [~, pVals(iSample)] = ttest2(A,B);
    
    A = [A; normrnd(myMu, mySigma, [nAddObs 1])];
    B = [B; normrnd(myMu, mySigma, [nAddObs 1])];

end

if pFlag
    plot(nSamples,pVals,'b-'); hold on;
    xlabel('Sample Size');
    ylabel('p Value');
    hl = line([min(nSamples), max(nSamples)], [0.05, 0.05]);
    set(hl,'Color','r','LineStyle','--');
end

