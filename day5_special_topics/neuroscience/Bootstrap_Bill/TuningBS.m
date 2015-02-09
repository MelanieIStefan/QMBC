function R = TuningBS(P)
% R = bsTuning(P)
% RTB? 
% AS renamed bsTuning -> TuningBS to follow QMBC convention

% given ordered pairs (direction, spike count) calculate the length of the
% mean vector of the tuning curve

Dirs = unique(P(:,1))';
Rates = zeros(1,length(Dirs));

for k = 1:length(Dirs)
    t = find(P(:,1) == Dirs(k));
    Rates(k) = mean(P(t,2));
end

[TH,R] = DirCoM(Dirs,Rates);