    %% Leitura de imagem de entrada
clear all  % Testar com 032
close all

    %% IDEIA: Erosão antes da primeira dilatação (ou outra maneira de destacar bordas)

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

    %% Melhora de contraste
figure(1);
subplot(1, 3, 1); imshow(img);    title(strcat('Imagem original:  ', arq));  
img = histeq(img);
subplot(1, 3, 2);  imshow(img);    title('Após eq. de hist.');
    %% Segmentação

m_img = uint8(imresize(img, 0.3));
mascara = otsu(m_img);
mascara = logical(imresize(mascara, size(img)));

subplot(1, 3, 3); imshow(mascara); title('Após seg. de Otsu')

%% Dilatação

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
subplot(1, 3, 2); imshow(mascara); title('Fechamento');

    %% Remoção de pequenas áreas conexas
   
mascara = bwareaopen(mascara, 7200);
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