% LE is the local entropy thresholded image
% JE is the joint entropy thresholded image
function [LE, JE] = myPal(I)

% define co-occurence matrix
T = zeros(256);

% compute co-occurence matrix
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

% compute normalized entropies of regions A,B,C,D for all thresholds 0:255
H_A = zeros(256,1);
H_B = zeros(256,1);
H_C = zeros(256,1);
H_D = zeros(256,1);
for t = 1:256
  % FF and BB regions
  if P_A(t) > 0
    p_ij_A = p_ij(1:t,1:t) ./ P_A(t);
    p_ij_A(p_ij_A==0) = [];
    H_A(t) = -sum(sum(p_ij_A .* log2(p_ij_A)));
  end

  if P_C(t) > 0
    p_ij_C = p_ij(t:256,t:256) ./ P_C(t);
    p_ij_C(p_ij_C==0) = [];
    H_C(t) = -sum(sum(p_ij_C .* log2(p_ij_C)));
  end
  
  % FB and BF regions
  if P_B(t) > 0
    p_ij_B = p_ij(1:t,t:256) ./ P_B(t);
    p_ij_B(p_ij_B==0) = [];
    H_B(t) = -sum(sum(p_ij_B .* log2(p_ij_B)));
  end
  
  if P_D(t) > 0
    p_ij_D = p_ij(t:256,1:t) ./ P_D(t);
    p_ij_D(p_ij_D==0) = [];
    H_D(t) = -sum(sum(p_ij_D .* log2(p_ij_D)));
  end
end

% find the max JE and LE thresholds
[H_le_t, H_le] = max((H_A + H_C) ./ 2);
[H_je_t, H_je] = max((H_B + H_D) ./ 2);

% print
disp(strcat('found LE threshold:', num2str(H_le-1)));
disp(strcat('found JE threshold:', num2str(H_je-1)));

% create thresholded images
LE = im2bw(I, H_le/256.0);
JE = im2bw(I, H_je/256.0);

end % end function
