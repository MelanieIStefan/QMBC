function [p] = pRatGuessing(nCorrect,nTrials,nSims)
% pRatGuessing: binomial simulation to calculate probability of n correct

for iSim = 1:nSims
    for jTrial = 1:nTrials
        thisTrial = round(rand(1)); % flip a coin
        oneBlock(jTrial) = thisTrial;
    end
    
    allBlocks(iSim) = sum(oneBlock);
end

nWeirdResults = sum(allBlocks >= nCorrect);
p = nWeirdResults / nSims;

