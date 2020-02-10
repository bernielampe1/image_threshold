function Q = myLloydMax(I)
  % quantize the image pixels
  [table, codes] = lloyds(double(I(:)), 2);
  J = codes(quantiz(I(:), table, codes)+1);
  Q = uint8(reshape(J, size(I)));
  
  levels = unique(Q)
  disp(strcat('found quantization levels at:', num2str(levels(1)), ',', num2str(levels(2))))
