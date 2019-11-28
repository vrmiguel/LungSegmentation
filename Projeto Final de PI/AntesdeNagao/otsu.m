%% Limiarização global através do método de Otsu

function [f_img, limiar, maior_var] = otsu(img)    
    % Entrada:
        % img := imagem de entrada
    % Retornos:
        % f_img     := imagem binarizada
        % limiar    := limiar calculado
        % maior_var := maior variância intra-classe calculadas
    
    format long     % Para a melhor exibição de floats/doubles.    
%% Lendo arquivo e verificando limite
    
    [dim_x, dim_y] = size(img);
    N = dim_x*dim_y;    % Quantidade de pixels na imagem
    
    if(isa(img, 'uint8'))
        max_val = 256; 
    elseif (isa(img, 'uint16'))
            max_val = 65535; 
    else        % Delimitaremos a inteiros positivos de até 16 bits pois inteiros de 32 bits causariam um número absurdo de iterações.
        error('A imagem deve estar em um tipo integral e representado em no máximo 16 bits');
    end
%% Calculando histograma e probabilidades
    histograma = zeros(1, max_val);
    for i = 1 : dim_x
        for j = 1 : dim_y
            val = img(i,j)+1;
            histograma(val) = histograma(val) + 1;
        end
    end
    probabilidades = histograma/double(N);   % As probabilidades de cada
                                                % .. valor de intensidade
%% Calculando limiares

    maior_var = 0; T=0;
    sigmas = zeros(1, max_val);         % Array que guardará todos os limiares calculados

    for t = 1 : max_val          % Testaremos todos os limiares de 1:intensidade-máxima

        omega_0 = 0.0; mu_0 = 0.0; omega_1 = 0.0; mu_1 = 0.0;

        % omega
        omega_0 = sum(probabilidades(1:t-1));
        omega_1 = 1.0 - omega_0;
        
        % mu
        for i = 1 : t-1
            if (omega_0 == 0.0)
                mu_0 = mu_0 + probabilidades(i)*(i-1);
            else
                mu_0 = mu_0 + probabilidades(i)*(i-1)/omega_0;
            end
        end
        
        for i = t : max_val
            if (omega_1 == 0.0)
                mu_1 = mu_1 + probabilidades(i)*(i-1);
            else
                mu_1 = mu_1 + probabilidades(i)*(i-1)/omega_1;
            end
        end
        
        
        sigma_atual = omega_0*omega_1*((mu_1-mu_0)^2); % Calculando variância
        
        sigmas(t) = sigma_atual;
        
        if (maior_var < sigma_atual)
            maior_var = sigma_atual;
            T = t;
        end
    end

%% Decidindo melhor limiar

sigmas_ordenados = sort(sigmas);

sigma_candidato_1 = sigmas_ordenados(end);     % Atual maior variância intra-classe
sigma_candidato_2 = sigmas_ordenados(end-1);   % Atual segunda maior var. intra-classe

if (round(sigma_candidato_1, 7) == round(sigma_candidato_2, 7))  % Arredondamos as variâncias 
    disp('Duas variâncias intra-classes iguais (ou muitíssimo similiares) encontradas');
    disp('O limiar será dado pela média dos limiares destas duas variâncias');
    
    % Encontrando índices de cada limiar
    limiar_1 = find(sigmas == sigma_candidato_1);      
    limiar_2 = find(sigmas == sigma_candidato_2);  
    fprintf('Limiar candidato 1: %d, com var. intra-classe: %f', limiar_1, sigma_candidato_1); 
    fprintf('Limiar candidato 2: %d, com var. intra-classe: %f', limiar_2, sigma_candidato_2);
    
    limiar = (limiar_1 + limiar_2)/2; 
    fprintf('Limiar encontrado: %d\n', limiar);
else
    limiar = T;
    fprintf('Limiar encontrado: %d\n', limiar);
    fprintf('Maior variância intra-classe encontrada: %f\n', sigma_candidato_1);
end
    
%% Aplicando limiar
    f_img = img;
    for i = 1 : size(f_img, 1)
        for j = 1 : size(f_img, 2)
            if (img(i,j) >= limiar)
                f_img(i,j) = max_val - 1;
            else
                f_img(i,j) = 0;
            end
        end
    end
end