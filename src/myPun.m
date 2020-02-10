function J = myPun(I)
  % calculate histogram counts
  p = hist(double(I(:)), 256);

  % normalize p so that sum(p) is one.
  p = p ./ numel(I);
  
  % compute entropy
  E = 0;
  for i = 1:256
    if p(i) > 0
      E = E + p(i) * log2(p(i));
    end
  end

  % compute na index where sum(p(0:na_ind) < 0.5)
  na_sum = 0;
  na_ind = 1;
  while na_sum < 0.5
    na_sum = na_sum + p(na_ind);
    na_ind = na_ind + 1;
  end

  % compute the anisotropy coefficient A
  NA = 0;
  for i = 1:na_ind
    if p(i) > 0
      NA = NA + p(i) * log2(p(i));
    end
  end
  A = NA / E;
 
  % compute the threshold
  A = 0.5 + abs(0.5 - A);
  s = 1; % threshold index
  s_sum = 0;
  while s_sum < A
    s_sum = s_sum + p(s);
    s = s + 1;
  end

  % apply threshold
  J = im2bw(I, (s-1) / 256.0);

  disp(strcat('found threshold at: ', num2str(s-1)));
