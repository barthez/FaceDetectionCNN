 function out = subsample(in, ratio) %Сжатие изображений простым усреднением
        %in - входная матрица, ratio - во сколько раз сжать, out - выходная
        %матрица, ws - матрица весов для субдискретизации, должна быть
        %размером равным размеру карты после субдискретизации, bs - матрица
        %смещений, по размерности такая же как ws
        switch ratio
            case 4
                out = 0;
                for k=1:4
                    for l=1:4
                        out = out+in(1+(k-1):4:size(in,1),1+(l-1):4:size(in,2));
                    end
                end

                out = out/16;
            case 2
                out = (in(1:2:size(in,1),1:2:size(in,2)) + in(1:2:size(in,1),2:2:size(in,2))...
                    +in(2:2:size(in,1),1:2:size(in,2)) + in(2:2:size(in,1),2:2:size(in,2)))./4;
                
            case 1
                out = in; %Пустышка - нужно, если начинаем со сверточного слоя
            otherwise disp('Unsupported ratio');
        end
%Убрал, т.к. при обратном распространении нам требуется карта признаков еще
%не умноженная на веса        
%    out = out.*ws + bs;        
    end