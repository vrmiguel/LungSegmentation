%% Baseado em Digital Image Smoothing and the Sigma Filter por Jong-sen Lee.

function f_img = nagao(img)

if size(img,3)==3
    img = rgb2gray(img);  % Certifica-se de que a imagem está em escala de cinza.
end

[m,n] = size(img);    % Dimensões da imagem de entrada

% Para poder aplicar as máscaras nos pixels da borda, nós copiamos
% simétricamente as duas linhas e colunas de cada borda.

% A imagem com a qual de fato trabalharemos é img3.
img2 = zeros(m,n+4);
img2(:,[1 2]) = img(:,[2 1]);
img2(:,3:n+2) = img(:,1:n);
img2(:,[n+3 n+4]) = img(:,[n n-1]);

img3 = zeros(m+4,n+4);
img3([1 2],:) = img2([2 1],:);
img3(3:m+2,:) = img2(1:m,:);
img3([m+3 m+4],:) = img2([m m-1],:);
f_img = zeros(m,n);
%% Aplicando filtro
for k = 3:m+2
    for l = 3:n+2
        % Criam-se 9 janelas ao redor de cada pixel considerado.
        % Cada coluna da matrix M contém os pixels de uma dessas janelas.
        % A é a matriz 5x5 ao redor do pixel considerado em um determinado
        % momento.
        
		M = zeros(9,9);
		A = img3((k-2):(k+2),(l-2):(l+2));
		M(:,1) = [A(1:5,1); A(2:4,2); A(3,3)];
		M(:,2) = [A(1,1:5), A(2,2:4), A(3,3)]';
		M(:,3) = [A(1:5,5); A(2:4,4); A(3,3)];
		M(:,4) = [A(5,1:5), A(4,2:4), A(3,3)]';
		M(:,5) = [A(1:3,1); A(1:3,2); A(1:3,3)];
		M(:,6) = [A(1:3,3); A(1:3,4); A(1:3,5)];
		M(:,7) = [A(3:5,1); A(3:5,2); A(3:5,3)];
		M(:,8) = [A(3:5,3); A(3:5,4); A(3:5,5)];
		M(:,9) = [A(2:4,2); A(2:4,3); A(2:4,4)];
        
		sigma = std(M); % Sigma contém o desvio-padrão de cada coluna de M
		[mindesv, minindice] = min(sigma); % Salva a coluna cujo desvio-padrão é o menor
            
            % Substituímos cada de pixel de f_img pela média dos pixels da
            % coluna de M com o menor desvio-padrão.
		f_img(k-2,l-2) = mean(M(:,minindice));
    end
end

f_img = uint8(f_img);
end