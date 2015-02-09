function [pRandom] = pTheClassIsRandom(maxPick,nPeople,choiceThreshold,nSims)

% pTheClassIsRandom.m: Have a each person in a group of people pick a
% number from 1 to a predefined value, inclusive. What is the probability
% that the people choose one value equal or more times than a given
% threshold?
%
% [pRandom] = pTheClassIsRandom(maxPick,nPeople,choiceThreshold,nSims)
%
% Inputs: 
% - maxPick: the highest value people were aloud to pick (default=4)
% - nPeople: the number of people picking a value (default=75)
% - choiceThreshold: the minimum number of choices for any value (default=34)
% - nSims:  the number of simulations to run (default=10000)
% 
% Output:
% - pRandom:The probability that the distribution is random
%
% On August 16, 2012, we got the following respons for 75 respondents; pick
% a random # 1-4 inclusive 1=7, 2=24, 3=34, 4=10
%
% e.g. pRandom = pTheClassIsRandom(4,75,34,10000)
%
% RTB wrote it as ProbHist.m in June 2012
% updated for coding style by TSH 18-Aug-2012

% Set some defaults. If nothing is passed to the function, we will supply
% some reasonable values.
% if nargin < 4, nSims = 10000; end
% if nargin < 3, choiceThreshold = 34; end
% if nargin < 2, nPeople = 75; end
% if nargin < 1, maxPick = 4; end

if nargin < 4
    error(['You only passed ',num2str(nargin),' arguments. You must pass 4 arguments to this function.']);
end

% Initialize random responses for all people and simulations
randomPicks = randi(maxPick,nPeople,nSims);
% Initialize arrays to hold results of simulations
nPicksChoosenByRandom = zeros(maxPick,nSims);

for iSim = 1:nSims % each loop iteration is a simulation of the questions asked 
    
    for jPick = 1:maxPick % loops through each possible value to see how often it was picked
        %thisPick has ones for every value of jPick
        thisPick = randomPicks(:,iSim) == jPick;
        % number times the value jPick came up in the iSim simulatiom
        nPicksChoosenByRandom(jPick,iSim) = sum(thisPick);
    
    end
    
end

% How often were the values in the simulation 'choosen' compared with
% the real world?
timesAboveMinChoice = sum(nPicksChoosenByRandom >= choiceThreshold);
pRandom = sum(timesAboveMinChoice > 0) / nSims;

% Here some commented code to visualize the random choices:
% nRandomPicsPerValue = hist(randomPicks,1:maxPick);
% figure; bar(nRandomPicsPerValue(:,1:5)); %plot only the first 5 simulations

% For MATLAB show-offs, this can be compressed into a single line of code:
% pRandom = sum(any(hist(randi(maxPick,nPeople,nSims),1:maxPick) >= choiceThreshold)) / nSims;

