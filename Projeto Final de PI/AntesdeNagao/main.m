    %% Leitura de imagem de entrada

[arq, caminho] = uigetfile('*.dcm', 'Selecione uma imagem');
img = dicomread(fullfile(caminho, arq));
clear arq, 


    %% Melhora de contraste
figure(1); imshow(img);         title('Imagem original');  

figure(2); imshow(histeq(img)); title('Após eq. de hist.');
    %% Segmentação

s_img = otsu(uint8(img));
figure(3); imshow(s_img); title('Após seg. de Otsu');
    %% Dilatação
  
% se90 = strel('line',3,90);
% se0 = strel('line',3,0);
% 
% BWsdil = imdilate(BWs,[se90 se0]);
% figure(4); imshow(BWsdil); title('Dilated Gradient Mask')