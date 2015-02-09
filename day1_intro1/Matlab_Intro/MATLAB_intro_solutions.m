%% Solutions to exercises from MATLAB intro
% DAR and AS edited on 8/8/2011
% Last updated 8/17/2011 by JW

% *SPOILER ALERT* This file provides solutions to the exercises from the
% MATLAB intro packet. The best way to remember what you learned is to
% spend time thinking about and doing the exercises on your own. Refer to
% this only after you've tried the exercises and gotten stuck!

% HOW TO USE THIS SOLUTION: This solution file doubles as a step-by-step
% tutorial reference. Each separate task in the problem is in its own cell
% (delimited by a %% at the beginning of the line). You should start by
% reading the comments and looking at the code without running it. Try to
% predict what each line of code does. Then, to see the code in action,
% press CTRL-ENTER to run your current cell. The cells should be run in
% order so that necessary variables are declared at the right times.


%% 
% Exercise 1: Putting it together
%

%% 1. Load sophie2.jpg. 
% You can do this by dragging the image into MATLAB.

% NOTE: Dragging the image into MATLAB to load it is equivalent to running
% the command IF sophie2 is located in the current directory.

uiopen('sophie2.jpg');

% which asks you for more information about the data, and then loads it.
% Although drag-and-drop is convenient, in practice we often want to load
% data without user intervention. This requires functions that already know
% how to deal with specific types of data. For example, we could have also
% loaded sophie2.jpg by calling.  This will only work IF sophie2 is located in the current directory

img = imread('sophie2.jpg');

% Here we loaded the image and stored it to a variable 'img'. You do a
% quick check that this loads the same kind of data as the 'uiopen' method
% above, by typing

whos sophie2 img

% How would you check that these two variables contain exactly the same
% data? You can read the documentation for uiopen and imread by typing

doc uiopen
doc imread

%% a. Display the image.
figure, imshow(sophie2);

%% b. Calculate the minimum value of the image.
minpx = min(sophie2(:))

%% c. Calculate the maximum value of the image.
maxpx = max(sophie2(:))

%% Create a new version of sophie2 where:
% d. The 20 columns on the left and right edge of the image are equal to
% the minimum of the image
sophie2a = sophie2;
sophie2a(:,1:20) = minpx;
sophie2a(:,end-20:end) = minpx;

% imshow(sophie2a); % see the result

%% e. The 20 rows on the top and bottom of the image are equal to the 
%  maximum of the image
sophie2a(1:20],:) = maxpx;
sophie2a(end-20:end,:) = maxpx;

% imshow(sophie2a); % see the result

%% f. Can you do d and e in one line of code each!?!
sophie2([1:20 end-20:end],:) = max(sophie2(:);
sophie2(:,[1:20 end-20:end]) = min(sophie2(:);

%% 2.	Store Sophie’s face in a new array. In one line of code, 
% create a new array containing:
% a. Two copies of Sophie's face side by side
newsophie = [sophie2 sophie2];

% b. Two copies of Sophie's face one on top of the other
newsophie2 = [sophie2; sophie2];

%% 3a.	Copy Sophie's face (rows 100 to 150 and columns 175 to 270) to the 
% same row and column positions but in the 3th plane of the 3rd dimension
% of Sophie.  What is the minimum value of the 3th plane of the 3rd
% dimension?
sophie2(100:150,175:270,3) = sophie2(100:150,175:270,1);
min(min(sophie2(:,:,3)))    % need two mins because the 3rd plane is 2d

%% b.	What is the value in every position in the 2nd plane of the 3rd
% dimension?
sophie2(:,:,2) ;      % all 0's

%% c.	Make Sophie's face in the 1st plane of the 3rd dimension equal to
% zero.  Look at the image with imshow.  What happened?
sophie2(100:150,175:270,1) = 0;
imshow(sophie2);    % Sophie is now red with a blue face

%% d.	How do you think you could make Sophie's face green?
% The planes in the 3rd dimension correspond to the red, green, and blue
% color channels in an RGB image. MATLAB automatically shows an image in
% grayscale if it has only 1 plane of info, and in color if it has 3. What
% you did in parts a-c was copy Sophie's face from the red/grayscale
% channel (1st plane) into the blue channel (3rd plane) and delete the data
% in the red channel. Now can you understand how the following code makes
% Sophie's face green?
sophie2(100:150,175:270,2) = sophie2(100:150,175:270,3);
sophie2(100:150,175:270,3) = 0;
imshow(sophie2);

4
%%
% Exercise 3
%
% NOTE: These solutions are functions and should be in their own files.
% To run the code below, uncomment it and move it to its own file.

%% 1.	Write a function that takes a 4-number row vector and returns it 
% as a 2 by 2 array. (To run, uncomment the following and copy into a
% separate file.)

% function square = Rowvec2Square(rowvec)
% square = [rowvec(1:2); rowvec(3:4)];

%%
% 2.	Make a function that takes two 4-number row vectors converts them
% into 2 by 2 arrays (sounds like question 1 doesn't it?) and then performs
% matrix multiplication on the resulting arrays. (To run, uncomment the
% following and copy into a separate file.)

% function prod = ConvertAndMultiply(vec1, vec2)
%     prod = Rowvec2Square(vec1)*Rowvec2Square(vec2);

%%
% Exercise 4 
%

%% 1.  Make a program that randomly picks a number between 1 and
% 100. If the value is between 1-10 have the program output the number. If
% the value is between 20-30 have the program output the number plus 100.
% Otherwise output the value minus 100.

r = 99*rand+1;
if r>1 & r<10
	r
elseif r>20 & r<30
    r+100
else
    r-100
end

%% 2.  Make a program that randomly picks a number between 1 and 100. Use a
% while loop to find the closest integer less than the random number. Break
% out of the loop and print the value (should be equivalent to rounding
% down).

r = 99*rand+1;
i = 0;
while i<r
	i = i+1;
end
i

%% 3.  In MATLAB, loops are sometimes necessary, but if possible, code runs
% faster when loops are replaced by vector operations.  Can you re-write
% the loops in this section in vector form?

% loops.m:
a=  [0 52 25 231];
a

% loops2.m:
(1:10).^2

% loops3.m:
a=(1:10).^2;
a=a

% loops4.m:
a=(1:10).^2

% loops1b.m:
a = [0 1; 52 2; 25 1; 231 3];
a(:,1)
a(:,2)

% loops5.m:
a=1:100;
b = a(mod(a,10)==3)

% loops6.m:
a=1:100; 
c= a(a>=91 | a<9)

% loops7.m:
a=1:100; 
d= a(mod(a,10)~=1 & mod(a,10)<2)

% loops8.m:
c=1:100;
a=c(mod(c,10)==1);
a= [a c(mod(c,10)==2)+100]
b=sum(c(mod(c,10)~=1 & mod(c,10)~=2)) 

% loops9.m:
exponent = ceiling(log(100)/log(1.3));
x = 1.3^exponent

% loops10.m: this can’t be done straightforwardly without loops




