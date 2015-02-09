function corrmap=CorPixMap(dummyimage,numcorrmap)
% try making correlated pixel maps for a calcium imaging  movie by calculating the 
% average correlation of the time series of every pixel with its eight
% neighbouring pixels

%numcorrmap- number of correlation maps one desires. If the number is more
%than 1, then the movie gets split into that many smaller movies and the
%corr pix map is calculated for each of the smaller movies

[m,n,l]=size(dummyimage);
%create a new movie with zeros padded along the border
dummyimage1=zeros(m+2,n+2,l);   
dummyimage1(2:end-1,2:end-1,:)=dummyimage;

bounds=round(linspace(1,l,numcorrmap+1));

corrmap=zeros(m,n,numcorrmap);  %initialise the corrmap variable


for indx=1:numcorrmap
    indx
    bound1=bounds(indx);
    bound2=bounds(indx+1);
    for i=1:(size(dummyimage1,1)-2)
        
        for j=1:(size(dummyimage1,2)-2)
            bah=corrcoef(squeeze(dummyimage1(i,j,bound1:bound2)),squeeze(dummyimage1(i+1,j+1,bound1:bound2)))+corrcoef(squeeze(dummyimage1(i,j+1,bound1:bound2)),squeeze(dummyimage1(i+1,j+1,bound1:bound2)))+corrcoef(squeeze(dummyimage1(i+1,j,bound1:bound2)),squeeze(dummyimage1(i+1,j+1,bound1:bound2)))+corrcoef(squeeze(dummyimage1(i+2,j,bound1:bound2)),squeeze(dummyimage1(i+1,j+1,bound1:bound2)))+corrcoef(squeeze(dummyimage1(i+1,j+2,bound1:bound2)),squeeze(dummyimage1(i+1,j+1,bound1:bound2)))+corrcoef(squeeze(dummyimage1(i+2,j+2,bound1:bound2)),squeeze(dummyimage1(i+1,j+1,bound1:bound2)))+corrcoef(squeeze(dummyimage1(i+2,j+1,bound1:bound2)),squeeze(dummyimage1(i+1,j+1,bound1:bound2)))+corrcoef(dummyimage1(i,j+2,bound1:bound2),squeeze(dummyimage1(i+1,j+1,bound1:bound2)));
            corrmap(i,j,indx)=bah(1,2)/8;
        end
    end
end
clear dummyimage2;

