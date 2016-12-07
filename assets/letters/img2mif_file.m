function t = Mask_maker(image_name, text_name)
% Read a RGB image file and write to YCbCr text files
% for Y, Cb, and Cr channels
% ---------------------------
% The format of text file:
% W  ; Width size
% H  ; Height size
% N  ; number of frame
% XXXXXX ; YCbCr data in Hex
% XXXXXX
% .....
% ---------------------------
im = imread(image_name);
% im = im2uint8(rgb2ycbcr(im))
fid = fopen(text_name,'W');
imsize = size(im);
count = 0;
if (fid)
    %% Write the RGB data
    fprintf(fid,'WIDTH = 8;\n');
    fprintf(fid,'DEPTH = %d;\n',imsize(1)*imsize(2));
    fprintf(fid,'ADDRESS_RADIX = HEX;\n');
    fprintf(fid,'DATA_RADIX = HEX;\n');
    fprintf(fid,'CONTENT BEGIN\n\n');
    for i=1:imsize(1)
       for j=1:imsize(2)
          fprintf(fid,'%x  : ',count);
          count = count + 1;
          R = im(i,j,1);
          G = im(i,j,2);
          B = im(i,j,3);
          hex = sprintf('%s%s%s\n', dec2hex(B, 2), dec2hex(G, 2), dec2hex(R, 2));
          fprintf(fid, hex);
       end
    end
    fprintf(fid,'END;\n');
    fclose(fid);
    t = 0; % successful

else
    t = 1; % error
end
