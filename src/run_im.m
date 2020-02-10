function run_im(fname)

% read image
I = imread(fname);

% get file parts
[path, name, ext] = fileparts(fname);

% run Lloyd-Max
disp('- lloydmax thresholds:');
J = myLloydMax(I);
imwrite(J, strcat('./results/', name, '_lloydmax', ext));

% run Otsu
disp('- otsu thresholds:');
J = myOtsu(I);
imwrite(J, strcat('./results/', name, '_otsu', ext));

% run Pun
disp('- pun thresholds:');
J = myPun(I);
imwrite(J, strcat('./results/', name, '_pun', ext));

% run Abutaleb
disp('- abutaleb thresholds:');
J = myAbutaleb(I);
imwrite(J, strcat('./results/', name, '_abutaleb', ext));

% run Pal
disp('- pal thresholds:');
[LE, JE] = myPal(I);
imwrite(LE, strcat('./results/', name, '_le_pal', ext));
imwrite(JE, strcat('./results/', name, '_je_pal', ext));

% run Chang
disp('- chang thresholds:');
J = myChang(I);
imwrite(J, strcat('./results/', name, '_chang', ext));

end

