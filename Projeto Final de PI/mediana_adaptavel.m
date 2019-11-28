%% Filtro de mediana adaptável
    % Inspirado na literatura de Gonzalez & Woods.

    % img := imagem de entrada
    % m_max := dimensão máxima de janela
    
function f_img = mediana_adaptavel(img, m_max)
if size(img,3)==3
    img = rgb2gray(img);  % Certifica-se de que a imagem está em escala de cinza.
end

[m, n] = size(img);       % Dimensões da imagem de origem

%% Formando padding

p_img=zeros(m+2*m_max,n+2*m_max);    % Imagem preenchida   
p_img(m_max+1:m+m_max,m_max+1:n+m_max)=img; % Sobrepõe imagem original no meio da
                                       % imagem preenchida. 
p_img(1:m_max,m_max+1:n+m_max)=img(1:m_max,1:n);                 % Nova borda superior
p_img(1:m+m_max,n+m_max+1:n+2*m_max)=p_img(1:m+m_max,n+1:n+m_max);    % Nova borda direita
p_img(m+m_max+1:m+2*m_max,m_max+1:n+2*m_max)=p_img(m+1:m+m_max,m_max+1:n+2*m_max);    % Nova borda inferior
p_img(1:m+2*m_max,1:m_max)=p_img(1:m+2*m_max,m_max+1:2*m_max);       % Nova borda esquerda

f_img=p_img;        % f_img = imagem estendida

%% Filtro de mediana
for i=m_max+1:m+m_max
    for j=m_max+1:n+m_max
        r=1;                % Inicialmente expande 1 pixel, isto é, máscara 3x3
        while r~=m_max+1     % Enquanto ainda se pode expandir..
            W=p_img(i-r:i+r,j-r:j+r);
            W=sort(W(:));           % Ordenando valores de W
            Imin=min(W(:));         % Imin = menor intensidade
            Imax=max(W(:));         % Imax = maior valor de cinza
            Imed=W(ceil((2*r+1)^2/2));      % Imed = valor mediano de cinza
            if Imin<Imed && Imed<Imax       % Se o valor na janela atual não for ruído, então o usaremos.
               break;
            else
                r=r+1;              % Caso contrário, expandimos a nossa janela
            end          
        end
        
 %% Se o valor da janela atual for ruído, o substituiremos pelo valor obtido anteriormente
        if Imin<p_img(i,j) && p_img(i,j)<Imax         % Se não for ruído, mantemos o valor anterior
            f_img(i,j)=p_img(i,j);
        else                                        
            f_img(i,j)=Imed; % Se for, o substituiremos pelo valor obtido anteriormente
        end
    end
end

f_img = uint8(f_img(m_max+1:m+m_max,m_max+1:n+m_max));   % Retirando preenchimento