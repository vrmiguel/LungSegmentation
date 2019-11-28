function h_img = eqhist(img)
    %% Verificando se a imagem é colorida
    if size(img, 3) ~= 1
        disp('Apenas imagens em escala de cinza são permitidas!');
        img = rgb2gray(img);
    end
    
    %% Calculando mapeamento de novas cores
    histc = histcum(img);   % Histograma cumulativo da imagem dada
    
    nmap = zeros(1,256);    % Conversão para novos níveis de cinza
    for i = 1:256
        nmap(i) = floor(255 * histc(i)+0.5);
    end
    
    %% 
    
    h_img = img;
    [l, c] = size(img);
    
    for i = 1:l
        for j = 1:c
            h_img(i,j) = nmap(h_img(i,j) + 1);
        end
    end
end