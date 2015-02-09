function kOnTheSameDayPerc=birthday_homework(N,K)

%% Same birthday as me

numberTrials=10000;

%% sameDayList=zeros(100,1);

firstGreaterFifty=0;

%% loop through number of students in the group
% for students=1:100;

%% or set number of students to N
students=N;

studentsTrials=randi(365,students,numberTrials);

%% someone has the same birthday as me
sameAsMe=sum(studentsTrials==1);
sameAsMePerc=sum(sameAsMe>=1)/numberTrials*100;


%% any 2 with the same birthday
kOnTheSameDay=0;

for i=studentsTrials;
    %% using unique
    %         if length(unique(i))<length(i)
    %             twoOnTheSameDay=twoOnTheSameDay+1;
    %         end
    %% using hist
    moreThanK=sum(hist(i,[1:365])>=K);
    if moreThanK>0
        kOnTheSameDay=kOnTheSameDay+1;
    end
    
end

kOnTheSameDayPerc=kOnTheSameDay/numberTrials*100;
% if twoOnTheSameDayPerc>50 && firstGreaterFifty==0
%     firstGreaterFifty=students;
% end


%% sameDayList(students)=twoOnTheSameDayPerc;
% end

%%figure, plot(sameDayList)
%% firstGreaterFifty