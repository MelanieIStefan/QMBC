
function [pVal]=IsMyRatGuessing(nCorrect,nTrials,pNull,nSims)

% IsMyRatGuessing.m: A Monte Carlo simulation approach to the binomial
% problem
%
% pVal = IsMyRatGuessing(nCorrect,nTrials,pNull,nSims)
%
% Inputs:
% - nCorrect: # of trials rat got right
%
% Outputs:
% - pVal: probability of guesing correctly

% simulate entire experiment thousands of times
for iSim = 1:nSims
    % simulate 1 experiment (= 50 trials)
    for iTrial = 1:nTrials
        % simulate one trial
        allTrials(iTrial) = rand(1) < pNull;
    end
    % count up how many our pseudo rat got right
    totCorrect = sum(allTrials);
    allSims(iSim) = totCorrect;
end
 % calculate a distribution of # correct out of 50
 %hist(allSims,50);
 nBetterByChance = sum(allSims >= nCorrect);
 pVal = nBetterByChance ./ nSims;
 
 % compare our exp. value (31) with above distribution
 
 % What is the probability of 31 or more correct
 % out of 50 trials if the prob. of correct on each
 % trial is 0.5?