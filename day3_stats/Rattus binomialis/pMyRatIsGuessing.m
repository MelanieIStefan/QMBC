function [pGuessing] = pMyRatIsGuessing(nCorrect,nTrials,pNull,nSims)

% pMyRatIsGuessing:Probility of getting nCorrect or better out of nTrials if
% the probability of a correct guess is pNull.
%
% [pGuessing] = pMyRatIsGuessing(nCorrect,nTrials,pNull,nSims )
%
% Inputs:
% - nCorrect: the number of correct trials (default=31)
% - nTrials: the total number of trials (default=50)
% - pNull: probability of guessing correctly on any one trial (default=0.5)
% - nSims: the number of simulations to run (default=10,000)
%
% Outputs:
% - pGuessing: the probability the rat got the observed % correct by
% guessing
%
% e.g. pGuessing = pMyRatIsGuessing(31,50,0.5,10000);
%
% RTB wrote it. 18 August 2012

% Set some defaults. If nothing is passed to the function, we will supply
% some reasonable values.
if nargin < 4, nSims = 10000; end
if nargin < 3, pNull = 0.5; end
if nargin < 2, nTrials = 50; end
if nargin < 1, nCorrect = 31; end

% Initialize arrays to hold results of simulations
allTrials = zeros(nTrials,1);
allSims = zeros(nSims,1);

for iSim = 1:nSims
    
    % Repeat for all trials in one block
    for jTrial = 1:nTrials
        
        % Simulate one trial
        thisTrial = rand(1);
        
        % Test for correctness and store result
        if thisTrial < pNull
            allTrials(jTrial) = 1;  % got it right
        else
            allTrials(jTrial) = 0;  % got it wrong
        end
        
    end
    
    thisSimResult = sum(allTrials); % # of correct guesses on this simulation
    allSims(iSim) = thisSimResult;  % store it
    
end

% How many of the simulations equal or exceed our actual rat's performance?
nAsGoodOrBetter = sum(allSims >= nCorrect);

% The probability that he is guessing (under H0) is simply the number of
% times we got the rat's result (or better) divided by the total number of
% simulations we ran.
pGuessing = nAsGoodOrBetter / nSims;


