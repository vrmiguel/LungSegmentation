function f_img = tomita(img, n)
    % Baseado na literatura de Gonzalez & Woods.
    % Baseado em Tomita & Tsuji, IEEE Transactions on Systems, Man, and Cybernetics de fevereiro de 1977

[l1,l2] = size(img);
imt1 = img;

%% Criando preenchimendo de imagem (padding) a fim de evitar erro de wraparound

for m = 1:(2*n)
    imt1 = [img(:,m),imt1,img(:,l2-m+1)];
end
imt = imt1;

for m = 1:(2*n)
    imt = [imt1(m,:); imt ;imt1(l1-m+1,:)];
end

moy = zeros((l1+4*n),(l2+4*n));
nc1 = ceil(n/2);
nc2 = floor(n/2);

for i = 1:(l1+3*n)
    for j = 1:(l2+3*n)
        moy(i+nc2,j+nc2) = mean(mean(imt(i:(i+n),j:(j+n))));
    end
end

p = zeros(1,5); q = zeros(1,5);

for i = 1:l1
    for j = 1:l2
        p(1) = i+2*n;
        q(1) = j+2*n;
        hom = grad(moy(p(1)+nc2,q(1)+nc2),moy(p(1)-nc1,q(1)+nc2),moy(p(1)+nc2,q(1)-nc1),moy(p(1)-nc1,q(1)-nc1));
        p(2) = p(1)-n; q(2) = q(1)-n;
        hom = [hom grad(moy(p(2)+nc2,q(2)+nc2),moy(p(2)-nc1,q(2)+nc2),moy(p(2)+nc2,q(2)-nc1),moy(p(2)-nc1,q(2)-nc1))];
        p(3) = p(2)+2*n; q(3) = q(2);
        hom = [hom grad(moy(p(3)+nc2,q(3)+nc2),moy(p(3)-nc1,q(3)+nc2),moy(p(3)+nc2,q(3)-nc1),moy(p(3)-nc1,q(3)-nc1))];
        p(4) = p(3); q(4) = q(3)+2*n;
        hom = [hom grad(moy(p(4)+nc2,q(4)+nc2),moy(p(4)-nc1,q(4)+nc2),moy(p(4)+nc2,q(4)-nc1),moy(p(4)-nc1,q(4)-nc1))];
        p(5) = p(4)-2*n; q(5) = q(4);
        hom = [hom grad(moy(p(5)+nc2,q(5)+nc2),moy(p(5)-nc1,q(5)+nc2),moy(p(5)+nc2,q(5)-nc1),moy(p(5)-nc1,q(5)-nc1))];
        [x,k] = min(hom);
        imr(i,j) = mean(mean(imt((p(k)-n):(p(k)+n),(q(k)-n):(q(k)+n))));
    end
end

f_img = uint8(ceil(imr));

%% Função de cálculo de gradiente
function a = grad(a1,a2,a3,a4) 
a = abs(a1+a2-a3-a4)+abs(a1-a2+a3-a4);