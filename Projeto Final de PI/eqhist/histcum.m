%% Calcula o histograma cumulativo da imagem dada

function histc = histcum(img)
    
    histc = zeros(1,256);
    histn = histnorm(img); % Obtém-se o histograma normalizado

    %% Calculando histograma cumulativo
    histc(1) = histn(1);
    
    for i = 2:256
        histc(i) = histc(i-1) + histn(i);
    end
end