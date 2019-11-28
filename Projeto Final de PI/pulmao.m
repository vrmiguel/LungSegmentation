    %% Leitura de imagem de entrada
clear all  % Bons: 032, dezessete, 008
close all

    %% IDEIA: Erosão antes da primeira dilatação (ou outra maneira de destacar bordas)
        % Trocar imresize pela função que eu implementei
        % Usar a equalização de histograma que eu fiz
        % Testar watershed
        % Reduzir imagem para agilitar cálculos
        % Calcular Dice e etc.
        % Dividir a imagem em dois e processá-las 
        % Verificar se existe como deixar apenas as duas maiores bwareas
        % n1 = image(:, 1 : end/2);
        % n2 = image(:, end/2+1 : end );
        % imshow(imclearborder(otsu(imbilatfilt(z(:, end/2 + 1 : end), 27))));
        
    
[arq, caminho] = uigetfile('*.png', 'Selecione uma imagem (cancele para usar imagem padrão)', '../Lung Segmentation/CXR_png');

if isequal(caminho,0)
   img = imread('CHNCXR_0032_0.png');
else
    img = imread(fullfile(caminho, arq));
    [~, nome, ext] = fileparts(arq);
    if strcmp(ext, 'dicom')
        img = dicomread(fullfile(caminho, arq));
    end
end

figure(1);
subplot(2, 2, 1); imshow(img);    title(strcat('Imagem original:  ', arq));  

    %% Melhora de contraste

n_img = histeq(img);
subplot(2, 2, 2);  imshow(n_img);    title('Após eq. de hist.');

%% Aplicação do filtro bilateral

% n_img = uint8(imresize(img, 0.3));
n_img = imbilatfilt(n_img, 27);
n_img = imgaussfilt(n_img, 5);

subplot(2, 2, 3);  
imshow(n_img);    title('Após bilateral');

    %% Segmentação

mascara = otsu(n_img);
%mascara = logical(imresize(mascara, size(img)));

subplot(2, 2, 4); imshow(mascara); title('Após seg. de Otsu')
%% Dilatação (verificar erosão)

ee = [[-1 0]; [0 -1]; [0 0]; [0 1]; [1 0]];  % Elemento estruturante

mascara = logical(dilatacao(mascara, ee)); 

figure(2); 
subplot(1, 3, 1); imshow(mascara); title('Após dilatação');

    %% Remoção de bordas
%% TODO agora:
    % Conectar pulmão
    % Retirar bordas
    % imfill
    % Mostrar máscara na imagem original
    
mascara = imclearborder(mascara, 4);
subplot(1, 3, 2); imshow(mascara); title('Removendo áreas inúteis');

    %% Remoção de pequenas áreas conexas
   
mascara = bwareaopen(mascara, 20000);
subplot(1, 3, 3); imshow(mascara); title('Pequenas áreas removidas');

    %% Preenchimento da área interna da máscara
    
mascara = dilatacao(imfill(mascara, 'holes'), ee);
figure(3); 
subplot(1, 2, 1); imshow(mascara); title('Dilatação e preenchimento');

    %% Visualização de máscara
    
subplot(1, 2, 2); imshow(labeloverlay(img, mascara)); title('Máscara sobre im. original');

    %% Exibir diagnóstico do paciente para verificar acurácia

if ~(isequal(caminho,0))
    cd('../Lung Segmentation/ClinicalReadings')
    diag = importdata(strcat(nome, '.txt'));
    disp(diag);
    cd('../../Projeto Final de PI/');
end