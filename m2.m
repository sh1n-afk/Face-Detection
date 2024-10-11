img_files = dir(fullfile(Directory,'BaboonRGP*.bmp'));

for l=1:length(img_files)

    img_file = img_files(l);

    if isempty(strfind(img_file.name, 'RGB')) 

        continue

    end

    img = imread(append(img_file.folder,'/',img_file.name));

    img = double(img);

    img_size = 128;

    img = imresize(img, [img_size nan]);

    

    h = 8;

    x = reshape(img, [img_size * img_size, 3]); 

    y = x;

    N = img_size * img_size;

    th = 0.1;

    K = 20;

    epane = false;

    

    for i=1:K

        for c=1:3

            figure;

            histogram(y(:,c));

            title(['h = ',num2str(h),' K = ', num2str(K), ' i = 0 ', ' c = ', num2str(c), ' ', img_file.name]);

            mxh = zeros(3,N);

            for k=1:N

                up = 0;

                down = 0;

                if epane

                    for n=1:N

                        if abs(y(k, c) - x(n, c)) <= h

                            C = (3/4) * (1 - (norm(y(k, c) - x(n, c)) / h)^2);

                            up = up + C * x(n, c);

                            down = down + C;

                        end

                    end

                else

                    for n=1:N

                        up = up + x(n, c) * exp(-(y(k, c) - x(n, c))^2 / h^2);

                        down = down + exp(-(y(k, c) - x(n, c))^2 / h^2) + eps;

                    end

                end

                myh = up / down - y(k, c);

                y(k, c) = myh + y(k, c);

                mxh(c,k) = myh;

            end

            if norm(mxh / h)^2  <= th^2

                disp(norm(mxh / h)^2);

                break;

            end

            if rem(i, 10) == 0 

                figure;

                histogram(y(:,c));

                title(['h = ',num2str(h),' K = ', num2str(K),' i = ', num2str(i), ' c = ', num2str(c), ' ', img_file.name]);

            end

        end

    end

    

    img = uint8(img);

    img = imresize(img, [512 nan]);

    figure;

    subplot(1,2,1);

    imshow(img);

    title('raw image'); 

    

    y = uint8(y);

    y = reshape(y,[img_size, img_size, 3]);

    y = imresize(y, [512 nan]);

    subplot(1,2,2);

    imshow(y);

    title('After Mean Shift');

    sgtitle(['h = ',num2str(h),' K = ', num2str(K)]);

    

end