function J = myAbutaleb(I)

% compute the average of all the neighborhoods in the image
F = fspecial('average', 3);
AvgI = uint8(conv2(double(I), F, 'same'));

% compute 2 dimensional histogram
hist2d = zeros(256,256);
for i = 1:numel(I)
  hist2d(I(i)+1, AvgI(i)+1) = hist2d(I(i)+1, AvgI(i)+1) + 1;
end
p = hist2d ./ numel(I);

% compute the entropy of the entire histogram
H_mm = 0;
for i = 1:256
  for j = 1:256
    if p(i,j) > 0
      H_mm = H_mm - p(i,j) * log2(p(i,j));
    end
  end
end

% compute total probabilities of all the thresholds
P = zeros(256);
H = zeros(256);

% base cases
P(1,1) = p(1,1);
if (p(1,1) > 0)
  H(1,1) = -p(1,1) * log2(p(1,1));
end

% base row
for i = 2:256
  P(i,1) = P(i-1,1) + p(i,1);
  if p(i,1) > 0
    H(i,1) = H(i-1,1) - p(i,1) * log2(p(i,1));
  else
    H(i,1) = H(i-1,1);
  end
end

% base column
for i = 2:256
  P(1,i) = P(1,i-1) + p(1,i);
  if p(1,i) > 0
    H(1,i) = H(1,i-1) - p(1,i) * log2(p(1,i));
  else
    H(1,i) = H(1,i-1);
  end
end

% compute totals and entropies
for s = 2:256
  for t = 2:256
    P(s,t) = P(s,t-1) + P(s-1,t) - P(s-1,t-1) + p(s,t);
    if p(s,t) > 0
      H(s,t) = H(s,t-1) + H(s-1,t) - H(s-1,t-1) - p(s,t) * log2(p(s,t));
    else
      H(s,t) = H(s,t-1) + H(s-1,t) - H(s-1,t-1);
    end
  end
end

% loop over the thresholds
max_psi = 0;
s_thresh = 0;
t_thresh = 0;
for s = 1:256
  for t = 1:256
      % compute entropy for this (s,t) pair
      P_st = P(s,t);
      H_st = H(s,t);
      if P_st > 0 && P_st < 1
        psi = log2(P_st*(1-P_st)) + H_st/P_st + (H_mm - H_st)/(1 - P_st);
      else
        psi = H_st/P_st + (H_mm - H_st)/(1 - P_st);
      end
      
      % check to see if this entropy is the max
      if psi > max_psi
        max_psi = psi;
        s_thresh = s-1;
        t_thresh = t-1;
      end
  end
end

% print out thresholds used
disp(strcat('max_psi:', num2str(max_psi)));
disp(strcat('s_thresh:', num2str(s_thresh)));
disp(strcat('t_thresh:', num2str(t_thresh)));

% apply threshold to image
J = bitand(im2bw(I,s_thresh/255.0), im2bw(AvgI,t_thresh/255.0));
end
