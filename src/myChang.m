function J = myChang(I)

% compute co-occurrence matrix of original image
p_ij = computeOccurrenceMatrix(I);

% compute the sums of probabilities over all thresholds
[P_A, P_B, P_C, P_D] = computeProbSums(p_ij);

% loop over thresholds
t_max = 0;
e_max = -999999;
for t = 1:256
  % compute relative entropy at threshold t
  e = 0;
  q_a = P_A(t) / (t * t);
  if q_a > 0
    e = e + P_A(t) * log2(q_a);
  end
  
  if t ~= 256
    q_b = P_B(t) / (t * (256 - t));
    if q_b > 0
        e = e + P_B(t) * log2(q_b);
    end
  end
  
  if t ~= 256
    q_c = P_C(t) / ((256 - t) * (256 - t));
    if q_c > 0
      e = e + P_C(t) * log2(q_c);
    end
  end
  
  if t ~= 256
    q_d = P_D(t) / ((256 - t) * t);
    if q_d > 0
      e = e + P_D(t) * log2(q_d);
    end
  end

  if e > e_max
    e_max = e;
    t_max = t;
  end
end

J = im2bw(I, t_max/256);
disp(strcat('found threshold at:', num2str(t_max)));

end % end function

function p_ij = computeOccurrenceMatrix(I)
  % define co-occurence matrix for original image
  T = zeros(256);

  % compute co-occurence matrix for original image
  dim = size(I);
  for x = 1:(dim(1)-1)
    for y = 1:(dim(2)-1)
      % first co-occurence with right pixel
      i = I(x,y)+1;
      j = I(x+1,y)+1;
      T(i,j) = T(i,j) + 1; % add count
    
      % if both are the same value only count co-occurence once
      if I(x+1,y) ~= I(x,y+1)
        j = I(x,y+1)+1;
        T(i,j) = T(i,j) + 1; % add count
      end
    end
  end

  % normalize the co-occurence matrix
  p_ij = T ./ sum(sum(T));
end

function [P_A, P_B, P_C, P_D] = computeProbSums(p_ij)
  % compute probability totals of regions A,B,C,D for all thresholds 0:255
  P_A = zeros(256,1);
  P_B = zeros(256,1);
  P_C = zeros(256,1);
  P_D = zeros(256,1);
  for t = 1:256
    % FF and BB regions
    P_A(t) = sum(sum(p_ij(1:t,1:t)));
    P_C(t) = sum(sum(p_ij(t:256,t:256)));
  
    % FB and BF regions
    P_B(t) = sum(sum(p_ij(1:t,t:256)));
    P_D(t) = sum(sum(p_ij(t:256,1:t)));
  end
end
