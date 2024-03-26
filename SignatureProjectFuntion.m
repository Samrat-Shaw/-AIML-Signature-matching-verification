function [val, im_pro] = SignatureProjectFuntion(I)
% Preprocessing
I2 = imresize(I, [512, 512]);
I3 = rgb2gray(I2);
I3 = im2double(I3);
I3 = imbinarize(I3); % Updated from im2bw
I3 = bwmorph(~I3, 'thin', inf);
I3 = ~I3;
im1 = I3;

% Extracting the black pixels
k = 1;
for i = 1:512
    for j = 1:512
        if (I3(i, j) == 0)
            u(k) = i;
            v(k) = j;
            k = k + 1;
            I3(i, j) = 1;
        end
    end
end

C = [u; v];
N = k - 1; % Number of pixels in the signature

% Find centroid
oub = sum(C(1, :)) / N;
ovb = sum(C(2, :)) / N;

% Rotation
for i = 1:N
    u(i) = u(i) - oub + 1;
    v(i) = v(i) - ovb + 1;
end

C = [u; v];
ub = sum(C(1, :)) / N;
vb = sum(C(2, :)) / N;
ubSq = sum((C(1, :) - ub).^2) / N;
vbSq = sum((C(2, :) - vb).^2) / N;

for i = 1:N
    uv(i) = u(i) * v(i);
end
uvb = sum(uv) / N;
M = [ubSq, uvb; uvb, vbSq];

minIgen = min(abs(eig(M)));

MI = [ubSq - minIgen, uvb; uvb, vbSq - minIgen];
theta = (atan((-MI(1)) / MI(2)) * 180) / pi;
thetaRad = (theta * pi) / 180;

% Rotate the signature
for i = 1:N
    v(i) = (C(2, i) * cos(thetaRad)) - (C(1, i) * sin(thetaRad));
    u(i) = (C(2, i) * sin(thetaRad)) + (C(1, i) * cos(thetaRad));
end
C = [u; v];

for i = 1:N
    u(i) = round(u(i) + oub - 1);
    v(i) = round(v(i) + ovb - 1);
end

% Boundary 128x128 and move signature curve
mx = 0;
my = 0;
if (min(u) < 0)
    mx = -min(u);
    for i = 1:N
        u(i) = u(i) + mx + 1;
    end
end
if (min(v) < 0)
    my = -min(v);
    for i = 1:N
        v(i) = v(i) + my + 1;
    end
end
C = [u; v];
for i = 1:N
    I3(u(i), v(i)) = 0;
end

% Removing white space
xstart = 512;
xend = 1;
ystart = 512;
yend = 1;
for r = 1:512
    for c = 1:512
        if (I3(r, c) == 0)
            if (r < ystart)
                ystart = r;
            end
            if (r > yend)
                yend = r;
            end
            if (c < xstart)
                xstart = c;
            end
            if (c > xend)
                xend = c;
            end
        end
    end
end

% Crop the image
im_pro = I3(ystart:yend, xstart:xend);

% Calculate features
PixelB = sum(im_pro(:) == 0);
PixelA = numel(im_pro);
NSA = PixelB / PixelA;

height_sign = yend - ystart;
length_sign = xend - xstart;
aspect_ratio = length_sign / height_sign;

max1 = max(sum(im_pro == 0, 1));
max2 = max(sum(im_pro == 0, 2));
Hor_Proj = max1 / length_sign;
Ver_Proj = max2 / height_sign;

% Other calculations (crosspoints, centroid, slope) - Please provide code if needed

% Pack the results into 'val'
val = [NSA, aspect_ratio, Hor_Proj, Ver_Proj];

end
