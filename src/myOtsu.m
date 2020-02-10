function J = myOtsu(I)
  level = graythresh(I);
  J = im2bw(I, level);
  disp(strcat('found threshold at:', num2str(level* 255)));
