function d_img = dilatacao(img, ee)
    [l, c] = size(img); le = size(ee, 1);
    d_img = zeros(l, c);
    for I = 1:l
        for J = 1:c
            if( img(I,J) > 0 )
                for k = 1:le
                    ind_x = I + ee(k, 1) + 1;
                    ind_y = J + ee(k, 2) + 1;
                    if ((ind_x >  0 && ind_x <= l) && (ind_y > 0 && ind_y <= c))
                        d_img(ind_x, ind_y) = 1;
                    end
                end
            end
        end
    end
end