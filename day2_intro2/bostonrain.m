%% load data
load('bostonRain.mat')

%% find new weather stations and remove from two latest datasets

%% list all stations in bigger dataset (rain12)
x=rain12(:,1);

%% list all stations in smaller dataset
y = cell2mat(rain3(:,1)');

%% make list of rows that will need to be removed from rain11 and rain12
removeList=[];

%% go through every station in the bigger dataset
for xi=1:8
    %% find stations that are not in the smaller dataset 
    result=strfind(y,x{xi});
    if isempty(result)
        %% for stations not in the smaller dataset, display station name
        display(x{xi})
        removeList(end+1)=xi;
    end
end

%% remove unwanted lines from arrays rain12 and rain11
rain12=removerows(rain12,removeList);
rain11=removerows(rain11,removeList);


%% new empty array that will store combined data from all weather stations
combinedData=[];

%% loop through years 2003 to 2012 to get weather data
for i=3:12
    %% mycommand is a string that will change with each iteration
    mycommand=['combinedData=[combinedData rain' num2str(i) '(:,2)];'];
    %% eval actually evaluates the command specified in the mycommand string
    eval(mycommand)
end

%% make a list of all years
years=2003:2012;

%% make a list of all weather stations
weatherStations=rain3(:,1);

%% loop through all the columns of the combined dataset
for i=1:10    
    %% compute total rainfall that year by taking the sum of the column
    rainYear=cell2mat(combinedData(1:6,i));
    totalRain=sum(rainYear);
    %% check if total rainfall is more than 300
    if totalRain>300    
            %% if rainfall is mroe than 300, display the year
            display(['year: ',num2str(years(i))])
            %% find the index of the station with the maximal rainfall
            k=find(rainYear==max(rainYear));
            %% display station name
            display(['station: ',weatherStations(k)]);
            break
    end
end


