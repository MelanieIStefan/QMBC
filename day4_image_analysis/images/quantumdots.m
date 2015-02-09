im = imread('quantumdots.tif');
im = im(:,:,1);
imshow(im,[])
im = mat2gray(im);
t = graythresh(im);
bw = im2bw(im,t);
figure; imshow(bw,[]);
bw2 = bwdist(imcomplement(bw));
figure; imshow(bw2,[]);
bw3 = -bw2;
L = watershed(bw3);
bw(L==0) = 0;
figure; imshow(bw,[]);