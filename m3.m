Path = 'Fast Prototyping/Segmentation_Data/*.bmp';  
A = dir(fullfile(Directory, 'Baboon.bmp'));
File = fullfile(Directory, A.name);
ImageTest = imread(File);
ImageTest = imresize(ImageTest, [64,64]);
imgTest = double(ImageTest);

figure('Name', 'Original image');
imshow(imgTest, [])
result = meanshift_filter(imgTest, 0.5, 15 , 10);
figure('Name', 'Result');
imshow(result, []);


function weight = gaussian_kernel(x, xn, h)
     weight = exp(- norm((x(:) - xn(:)) / h));
end


function J = meanshift_filter(I, TH, K, h)
    dim = size(I);
    J = zeros(dim);
    for y = 1:dim(2)
        for x = 1:dim(1)
            yMle = I(y, x);                    
            shift = TH + 1;
            k = 1;
            while sum(shift) > TH && k <= K
                numerator = 0;
                denominator = 0;
                for j = 1:dim(2) 
                    for i = 1:dim(1)
                        weight = gaussian_kernel(yMle, I(j,i), h);
                        if weight < h
                            numerator = numerator + (I(j, i) * weight);
                            denominator = denominator + weight;
                        end
                    end
                end
                yMle1 = numerator / denominator;
                shift = norm(yMle1 - yMle);
                yMle = yMle1;
                k = k + 1;
            end
            J(y, x) = yMle;
        end
    end
end
