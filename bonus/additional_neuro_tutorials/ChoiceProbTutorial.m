% Choice Probability Tutorial
% Concepts covered:
% - simulating variable neuronal and behavioral data
% - signal detection theory analysis to determine separability of
% distributions
%
% written by Alex Smolyanskaya on 7 Aug 2011 for Harvard Quantitative
% Methods Boot Camp


format compact

%% Relating neuronal activity to behavior
% It turns out there is a measurable relationship between the activity of
% single neurons and animals' decisions on specific tasks. This has been
% shown for several tasks and brain areas in monkey cortex (e.g. see
% Britten et al 1996 one of the first reports). In a way, this makes a lot
% of sense, what are neurons doing if not informing behavior? On the other
% hand, we have billions of neurons, and at least hundreds of thousands
% that fire even during the most specific of tasks. So maybe it's no
% surprise that the relationship between a single neuron and an animal's
% choice tends to be pretty small (but significant).
%
% In this tutorial we'll explore 1) how this relationship may arise by
% simulating some neuronal data that informs behavior and 2) how we can
% measure small differences between noisy distributions of firing rates.


%% The experiment
% We're going to simulate an experiment where we ask a monkey to tell us if
% a random dot stimulus is moving left or right. Our simulated monkey will
% make this decision based on the firing rate of a pair of simulated MT
% neurons, which are very selective for direction of motion and are
% therefore prime sources of information for this task (and have been shown
% to actually do this by Britten et al 1996).
% 
% This is what a tuing curve looks like, so when we say this neuron
% "prefers" right, we mean it fires a lot more to stimuli moving rightward
% than leftward. It's preferred direction is to the right and it's null
% direction is to the left. in MT, the null direction is typically the one
% opposite to the preferred and also the one that elicits the smallest
% firing rate.
Dirs = [0:45:315 0];
fRate = [285 251 53 4 3 6 25 173 285];
polar(deg2rad(Dirs), fRate)
title('MT neuron direction tuning curve')
ylabel('firing fate (Hz)')

% Our monkey will be deciding left vs right, so let's say he's
% comparing the activity of 2 neurons: one that prefers left and one that
% prefers right. If the stimulus was very clearly moving right, this would
% be trivial because the right-preferring neuron would fire much more than
% the left-preferring neuron every single time simply due to the visual
% stimulus. The right neuron will completely predict the animal's decision
% on this task, but this might not be because it's actually involved in the
% decision, but simply because it responds to right motion much more than
% it does to left motion. So, we make the task more difficult by
% introducing noise. This way, the subject will make mistakes and we can
% compare neuronal responses *to the same visual stimulus* when the monkey
% gets it right or wrong. If there is a difference in responses, we can
% argue that this neuron contributes to behavior in some way. We'll see how
% this works soon.
% 
%% The stimulus
% In the noisy stimulus some proportion of the dots move randomly and some
% move in the specified direction (left or right). So if 50% move right and
% 50% move in random directions, we say this stimulus has a coherence of
% 50%. If 25% move right, it has a cohrence of 25%. If a stimulus has a
% coherence of 5%, it is very hard to tell which way it is moving and the
% subject will often get it wrong. If it has a coherence of 0%
% there is no true direction. Same for left-moving stimuli. So at 0% right
% and left stimuli are the same and contain no true direction. MT neurons
% also respond less to less-coherent stimuli. First, let's see what this
% coherence-dependent response looks like:

% We'll need a neurons response to 0% stimuli and how the neuronal response
% changes with coherence:
fRateAt0 = 20;
fRatePerPrefCoh = 30; 
fRatePerNullCoh = -10; % MT neurons are supressed by motion in the direction opposite to their preferred, called the 'null' direction

% Coherences
Cohs = [0 .01 .02 .04 .08 .16 .32 .64]'; 
% Expected firing rate for one neuron to stimuli at different coherencesis
% well approximated by a linear function:
ExpectedSpikesRight = fRateAt0 + fRatePerPrefCoh*Cohs % preferred direction stimuli
ExpectedSpikesLeft = fRateAt0 + fRatePerNullCoh*Cohs % null direction stimuli

%Plot:
figure
plot(Cohs, ExpectedSpikesRight, 'o-r')
hold on;
plot(Cohs, ExpectedSpikesLeft, 'o-b')
xlabel('Coherence')
ylabel('Firing Rate (Hz)')
legend('Preferred Direction (Right) Response', 'Null Direction (Left) Response',...
    'Location', 'NorthWest')

% Ok, so we can see that this neuron's firing rate increases with coherence
% for preferred direction stimuli. This makes sense, there's more
% right-ward moving dots in higher coherence stimuli. Note, this
% neuron's response decreases the more coherent the null direction stimuli
% are.

%% Model neurons leading to a decision
% Ok, now let's see how a monkey can compare the activity of two such
% neurons to make a decision about the stimulus moving left or right. Again
% we don't want to use the trivial case when the the stimulus actually has
% dots moving either left or right, because our right-preferring neuron
% will always fire more for right and left-preferring neuron will fire more
% for left. Let's take the impossible condition of 0% coherence where there
% is no true direction. The monkey is trained to respond no matter what so
% he might as well go with his best guess given the two neurons he's got
% (we hope). Neurons are noisy se let's see how this small amount of noise
% might cause the animal to choose one direction over another.

thisCoh = 0; 
nTrials = 1000; % number of trials we'll simulate our neuronal response 
Time = 1; %(second)

% In the 0% coherence stimulus, there's no real direction in this stimulus
% so both neurons fire the same amount on average:
ExpectedSpikesRight = Time .* (fRateAt0 + fRatePerPrefCoh*thisCoh)
ExpectedSpikesLeft = Time .* (fRateAt0 + fRatePerNullCoh*thisCoh)

% However, neurons are noisy, so on any given trial they might fire a
% little less or a little more. Let's assume 1) this noise is normally
% distributed 2) the variance is equal to the mean (so we'll take the
% square root to get the standard deviation; remember: SD = sqrt(variance))
SpikesRight = normrnd(ExpectedSpikesRight, sqrt(ExpectedSpikesRight), nTrials, 1);
SpikesLeft = normrnd(ExpectedSpikesLeft, sqrt(ExpectedSpikesLeft), nTrials, 1);

% Again, these distributions should still look approximately the same:
figure
maxResponse = max([SpikesRight(:); SpikesLeft(:)]);
subplot 211
hist(SpikesRight)
xlim([0 maxResponse])
title('Preferred Responses')
subplot 212
hist(SpikesLeft)
xlim([0 maxResponse])
title('Null Responses')
xlabel('Number of Spikes')

% OK, now let's make our monkey base his decision on these two neurons.
% Whenever the Right-preferring neuron fires more, the monkey will choose
% right, when the Left-preferring neuron fires more, he'll choose left.
% ChoseRight is the index of trials on which the monkey chose right based
% on the comparison of firing rates between the Left and Right neuron.
% ChoseLeft is the index of trials when he chose left (i.e. the trials when
% he did not choose right)
ChoseRight = SpikesRight > SpikesLeft; % Decision: compare the two neurons' responses
ChoseLeft = ~ChoseRight;

% Now let's look only at the Right-preferring neuron's responses, sorted by
% the monkey's decision. That is, looks at the firing rates of the
% right-preferring neuron just like we did before but separated by what our
% fake monkey chose in the previous 2 lines.
figure('Name', 'Right-preferring neurons''s response, sorted by decision')
subplot 211
hist(SpikesRight(ChoseRight))
xlim([0 maxResponse])
title('Monkey Chose Right (Pref for this neuron)')
subplot 212
hist(SpikesRight(ChoseLeft))
xlim([0 maxResponse])
title('Monkey Chose Left (Null for this neuron)')
% Notice, they're slightly different. Remember, the stimulus was the same
% on every trial. And here we're looking at the response of only one neuron
% and we can see a difference in the response distributions between when
% the animal chose left vs right. This neuron fired a little more than it's
% average on the trials when the monkey chose right. That's nice, that
% means we don't have to record from two neurons at once to measure this!
% This also makes sense because the Left neurons' responses are equally
% variable around the same mean response so when the Right neuron fires a
% little more than it's average, it's likely to be firing more than the
% Left neuron as well.

% We can also look at the Left neuron's responses:
figure('Name', 'Left-preferring neurons''s response, sorted by decision')
subplot 211
hist(SpikesLeft(ChoseRight))
xlim([0 maxResponse])
title('Monkey Chose Right (Null for this neuron)')
subplot 212
hist(SpikesLeft(ChoseLeft))
xlim([0 maxResponse])
title('Monkey Chose Left (Pref for this neuron)')
% Note, this neuron fires more when the monkey chose left, which is this
% neuron's preferred direction!

% Conclusion: even though these two neurons fire the same amount, on
% average, to the 0% coherence stimulus, small fluctuations in their
% response can influence behavior *if the monkey is "listening" to these
% neurons*

% Would this work for stimuli with some signal, such as 2% or 8% coherence?
% What do the monkey's decisions look like in the 100% coh case?
% Try!

%% How well can we tell what the monkey will do from the neuron's response?
% In our model monkey we know that these neurons are contributing to the
% decision, because we made it that way. We can also see the subtle
% difference between the distributions. But when we're doing an experiment
% to test this, we don't know whether the neuron we're recording from
% contributes to the decision, that's the point of the experiment. In
% either case, even if we can see the subtle differences in the
% distributions, how can we tell how good the neuron is at predicting the
% monkey's response? How can we put a number on it? Another way to think of
% it is, how well can an ideal observer (you) tell what the monkey is going
% to choose by looking at the firing rate of a neuron? If we can't tell at
% all, then we would say that this neuron is probably not involved in the
% decision. In our model above, we made it so that the neurons were
% responsible for the decision, so in this case we should be able to
% predict the monkeys response from the neuron's response with some
% probability. That probability is equal to the area under the ROC
% ("Receiver Operating Characteristic", fancy, huh?) curve.

% The ROC curve is just a concept borrowed from signal detection theory
% that let's us put a number on the "separability" of two distributions. In
% our case, we want to ask, if I choose a firing rate randomly from all of
% the responses of our Right neuron, how well could I predict what the
% monkey will do? 

% If you've changed the above model, re-run it under the 0% coherence case
% before you plot this:
figure('Name', 'Right-preferring neurons''s response, sorted by decision')
subplot 211
hist(SpikesRight(ChoseRight));
hold on
xlim([0 maxResponse])
yVals = get(gca, 'yLim');
plot([30 30], yVals, 'k', 'LineWidth', 2)
plot([20 20], yVals, 'g', 'LineWidth', 2)
plot([10 10], yVals, 'r', 'LineWidth', 2)
title('Monkey Chose Right (Pref for this neuron)')
subplot 212
hist(SpikesRight(ChoseLeft))
hold on
xlim([0 maxResponse])
plot([30 30], yVals, 'k', 'LineWidth', 2)
plot([20 20], yVals, 'g', 'LineWidth', 2)
plot([10 10], yVals, 'r', 'LineWidth', 2)
title('Monkey Chose Left (Null for this neuron)')
xlabel('Spikes')
% So, if I ask you, what did the monkey choose if the firing rate was 30
% spikes (black line), you'd be pretty certain he chose right, your
% probability of being correct would be 1. Same for 10 spikes: you'd say he
% chose left. However, for 20 spikes, you have no idea, he chose both right
% and left on those trials, you'd be at about chance (50% correct). The
% ROC will tell us the probability with which you'd be right overall.

% The ROC analysis will basically step through the ditributions like we did
% with our spike lines in the previous figure, but more finely. It will
% also ask a slightly different question. Each step will represent a
% criterion value for the ideal observer to use to make a decision about
% whether the subject reported that the stimulus was moving right or not.
% (Note the observer here is the experimenter looking at the data, not the
% subject doing the task.) At each criterion, we'll plot the number of
% trials on which there were more spikes than the criterion in the 1) chose
% right distribution and 2) chose left distribution. These will be plotted
% on the ROC plot on the y and x axes, respectively. The number of trials
% where the ideal observer would have chosen right based on the "chose
% right" distribution would be the number of correct trials (Hits) and the
% number of trials where the ideal observer would have chosen right but
% from the distribution of "chose left" responses would be the number of
% wrong trials (False Alarms). So, if the observer's criterion is very low
% (e.g. 1 spike) he would have chosen right on all trials based on both
% distributions because all trials are > 1 spike. This point would end up
% in the upper right corner of the ROC diagram. With a high criterion of 30
% spikes,the observer will have chosen right on a small proportion of
% trials so the point will be in the lower left corner of the ROC plot. The
% intermediate criteria values will fill out a connected line between these
% points. If the distributions of firing rates when the subject chose right
% and  when the subject chose left are identical, the line will be a
% straight line of unity. The area under this curve is the probability with
% which the ideal observer can tell what the subject will choose based on
% the firing rates. In the case of identical distributions and the
% straigh-line ROC, the area under the curve is 0.5, which is chance.

% Setup:
% Remember, we're only looking at the right-preferring neuron and sorting
% its responses to the *same stimulus* by the subject's decision.
ChoseRightSpikes = SpikesRight(ChoseRight); % store values for easier access
ChoseLeftSpikes = SpikesRight(ChoseLeft); % store values for easier access

% Define criteria list 
N = 100; % number of steps to take through the firing rates (number of criteria) 
CritLo = min([min(ChoseRightSpikes(:)) min(ChoseLeftSpikes(:))]); % lower bound on criterion
CritHi = max([max(ChoseRightSpikes(:)) max(ChoseLeftSpikes(:))]); % upper bound on criterion
Crit = linspace(CritLo,CritHi,N); % Get all criteria

%Init empty vectors for Hits and False Alarms
FalseAlarm = NaN(1,N); %initialize vector
Hit = NaN(1,N);


% Here we'll draw an animated figure that updates with every criterion the
% ROC process evaluates against. Make sure you can see the figure while
% it's being plotted

% Choice histogram values for plotting 
maxRate = max([ChoseRightSpikes(:); ChoseLeftSpikes(:)]);
bins = [0:maxRate/50:maxRate];
nRight = histc(ChoseRightSpikes, bins);
nLeft = histc(ChoseLeftSpikes, bins);
maxCount = max([nRight(:); nLeft(:)]);

figure % "animated" figure
for ThisStep = 1:N,
    FalseAlarm(N-ThisStep+1) = sum(ChoseLeftSpikes > Crit(ThisStep));
    Hit(N-ThisStep+1) = sum(ChoseRightSpikes > Crit(ThisStep));
    
    % Plot as it goes! 
    % comment this out if you want it to go faster.
    subplot 221
    bar(bins,nRight, 'b');
    hold on;
    bar(bins, -nLeft, 'c');
    xlim([0 maxRate]); ylim([-maxCount maxCount])
%     legend('Chose Right', 'Chose Left', 'Location', 'NorthWest');
    plot([Crit(ThisStep) Crit(ThisStep)], [-maxCount maxCount],...
        'k', 'LineWidth', 2);
    xlabel('Spike Count'); ylabel('counts'); title('Spike counts sorted by choice')
    hold off
    subplot 222
    plot([0 nTrials/2], [0 nTrials/2], 'k')
    hold on
    plot(FalseAlarm,Hit);
    axis square; xlabel('False Alarm'); ylabel('Hit'); title('ROC curve (not yet normalized)')
    xlim([0 nTrials/2]); ylim([0 nTrials/2]);
    pause(0.2) 
end

% The area under our live-drawn curve will be some large number that's not
% in the range 0-1 because we were counting trials. So now we just normalize
% it:
NumY = length(ChoseLeftSpikes);
FalseAlarm = FalseAlarm/NumY; % Normalize to 1 so that area is in the range 0-1 (for probability)
NumX = length(ChoseRightSpikes);
Hit = Hit/NumX; % Normalize to 1 so that area is in the range 0-1 (for probability)

FalseAlarm(1) = 0;
Hit(1) = 0;
FalseAlarm(N) = 1;
Hit(N) = 1;
areaROC = trapz(FalseAlarm,Hit); % get the area under the curve

% Plot final ROC curve (normalized). The area under the curve = choice
% probability (CP)
subplot 223
plot(FalseAlarm,Hit),axis('square'),xlabel('FA'),ylabel('Hit');
title(sprintf('ROC area/CP = %.3f', areaROC));

% What would the CP be if this neuron fired more when the monkey chose the
% neuron's null direction (left)? 

% Can you simulate a monkey that does not use his MT neurons to make the
% decisions about direction? What does the choice probability look like in
% this case?

%% References:
% Britten, Newsome, Shadlen, Celebrini, and Movshon 1996. "A relationship
% between behavioral choice and the visual responses of neurons in macaque
% MT". Visual Neuroscience. 13, 87-100.
% Parker and Newsome 1998, "Sense and the Single Neuron: Probing the
% Physiology of Perception". Annu. Rev. Neurosci. 21, 227-77.