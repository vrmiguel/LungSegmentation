    %% histnorm retorna o histograma normalizado e o histograma de uma imagem.
        % Entrada:
            % img: matriz de uint8 (obrigatóriamente)
        % Saída:
            % histn: vetor de histograma normalizado
            % hist: vetor de histograma (saída opcional)

function [histn, hist] = histnorm(img)
    %% Obtendo histograma da imagem dada
    
    [l, c] = size(img);
    
    hist = zeros(1, 256);
    for i = 1:l
        for j = 1:c
            hist(img(i,j) + 1) = hist(img(i,j) + 1) + 1;    % Contabiliza ocorrências de cada nível de cinza
        end
    end
    %% Obtendo histograma normalizado da imagem dada
    
    T = l*c;    % Quantidade total de pixels na imagem
    
    histn = hist/T;
end