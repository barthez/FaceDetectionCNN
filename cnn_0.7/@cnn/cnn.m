function cnet = cnn(numLayers,numFLayers,numInputs,InputWidth,InputHeight,numOutputs)
%CNN convolutional neural network class constructor  
%
%  Syntax
%  
%    cnet =
%    cnn(numLayers,numFLayers,numInputs,InputWidth,InputHeight,numOutputs)
%    
%  Description
%   Input:
%    numLayers - total number of layers
%    numFLayers - number of fully connected layers
%    numInputs - number of input images (currently only 1 supported)
%    InputWidth - input image width
%    InputHeight - input image heigth
%    numOutputs - number of outputs
%   Output:
%    cnet - convolutional neural network class object
%
%   Semantic is quite simple: subsampling and convolutional layers are
%   follows in pairs and called SLayers and CLayers. Thus all S-layers are
%   odd and all C-layers are even. After last CLayer follows FLayer wich is
%   fully connected layer. The same way named weights and biases.
%   Example of accessing weights: 
%   cnn.CLayer{2}.WC
%   cnn.SLayer{3}.BS
%   If it necessary to create network with first CLayer make the SLayer{1}
%   linear
%(c) Sirotenko Mikhail, 2009

%Create empty network
%----User defined parameters 
    
if(nargin<6) %If no parameters are defined set it to defaults
    if((nargin==1)&&(isstruct(numLayers)))
        cnet = class(numLayers,'cnn');
    else

        cnet.numLayers = 3; %Total layers number
        cnet.numSLayers = 1; %Number of S-layers
        cnet.numCLayers = 1; %Number of C-layers
        cnet.numFLayers = 1; %Number of F-lauers
        cnet.numInputs = 1; %Number of input images
        cnet.InputWidth = 30; %Input weight
        cnet.InputHeight = 30; %Inout height
        cnet.numOutputs = 1; %Outputs number 
    end
else 
    cnet.numLayers = numLayers;
    cnet.numSLayers = ceil((numLayers-numFLayers)/2); 
    cnet.numCLayers = numLayers-numFLayers-cnet.numSLayers; 
    cnet.numFLayers = numFLayers; 
    cnet.numInputs = numInputs; 
    cnet.InputWidth = InputWidth; 
    cnet.InputHeight = InputHeight; 
    cnet.numOutputs = numOutputs; 
end
%Default parameters wich typically redefined later
cnet.Perf = 'mse'; %Performance function
cnet.mu = 0.01; %Mu coefficient for stochastic Levenberg-Marqwardt
cnet.mu_dec = 0.1; %Коэффициент декремента mu
cnet.mu_inc = 10;   %Коэффициент инкремента mu
cnet.mu_max = 1.0000e+010;  %Максимальное значение mu
cnet.epochs = 50;   %Количество эпох для случая пакетного обучения
cnet.goal = 0.00001;    %Значение ошибки при котором обучение прекращается
cnet.teta = 0.2;
cnet.teta_dec = 0.3; %Значение уменьшения тета
%Структура SLayer содержит информацию о субдискретизирующих слоях
%Везде ниже задаем дефолтовые значения для слоев, которые затем могут быть
%реконфигурированы пользователем
%после этого требуется вызов метода Init, для перестройки архитектуры сети
%на основе новых параметров
for k=1:cnet.numSLayers
    
    m=2*k-1; %Т.к. у нас слои идут через один, используем m в качестве итератора
    %----Параметры задаваемые пользователем
    cnet.SLayer{m}.teta = 0.2; %Коэффициент обучения для слоя
    cnet.SLayer{m}.SRate = 2; %Степень субдискретизации (во сколько раз сжимать)
    cnet.SLayer{m}.TransfFunc = 'tansig_mod'; %Тип функции активации
%    cnet.SLayer{m}.TransfFunc = 'tansig'; %Тип функции активации
    %----Параметры вычисляемые в процессе работы сети (карты признаков)
    cnet.SLayer{m}.YS{1} = 0; %Значения взвешенных входов (до функции активации)
    cnet.SLayer{m}.XS{1} = 0; %Значения входов слоя (после функции активации)
    cnet.SLayer{m}.SS{1} = 0; %Карта признаков субдискретизированная до умножения на веса
    %----Параметры инициализируемые конструктором
    cnet.SLayer{m}.WS{1} = 0; %Массив матриц весовых коэффициентов
    cnet.SLayer{m}.BS{1} = 0; %Массив матриц смещений
    cnet.SLayer{m}.numFMaps = 1; %Количество карт признаков на выходе слоя
    cnet.SLayer{m}.FMapWidth = 10;   %Размерность карты признаков
    cnet.SLayer{m}.FMapHeight = 10;
    cnet.SLayer{m}.ln = m; %Порядковый номер слоя
    %----Параметры вычисляемые при обучении
    cnet.SLayer{m}.dEdW{1} = 0; %Частная производная ошибки по весам
    cnet.SLayer{m}.dEdB{1} = 0; %Частная производная ошибки по смещениям
    cnet.SLayer{m}.dEdX{1} = 0; %Частная производная ошибки по выходам
    cnet.SLayer{m}.dXdY{1} = 0; %Частная производная выходов по взвешенным суммам
    cnet.SLayer{m}.dYdW{1} = 0; %Частная производная взвешенных сумм по весам    
    cnet.SLayer{m}.dYdB{1} = 0; %Частная производная взвешенных сумм по смещениям 
    cnet.SLayer{m}.H{1} = 0;    %Аппроксимация Гессиана
    cnet.SLayer{m}.mu = 0;      %Регуляризационный фактор. Используется для адаптивной аппроксимации Гессиана на разных этапах обучения.
    cnet.SLayer{m}.dEdX_last{1} = 0; %Предыдущее значение ошибки, приведенной к выходу слоя. 
                                     %Используется для вычисления
                                     %регуляризационного фактора
end
%CLayer - аналогично для сверточного слоя
for k=1:cnet.numCLayers
    m=k*2;
    %----Параметры задаваемые пользователем
    cnet.CLayer{m}.teta = 0.2; %Коэффициент обучения для слоя
    cnet.CLayer{m}.numKernels = 1; %Количество ядер свертки (то же, что lenght(WC))
    cnet.CLayer{m}.KernWidth = 3; %Размерность ядра свертки
    cnet.CLayer{m}.KernHeight = 3 ;
    %----Параметры вычисляемые в процессе работы сети
    cnet.CLayer{m}.YC = cell(1); %Значения взвешенных входов 
    cnet.CLayer{m}.XC = cell(1); %Значения входов слоя равны взвешенным входам, т.к. в сверточных слоях линейная функция активации
    %----Параметры инициализируемые конструктором
    cnet.CLayer{m}.WC{1} = 0; %Массив матриц весовых коэффициентов (ядер свертки)
    cnet.CLayer{m}.BC{1} = 0; %Массив матриц смещений
    cnet.CLayer{m}.numFMaps = 1; %Количество карт признаков на выходе слоя
    cnet.CLayer{m}.FMapWidth = 10;   %Размерность карты признаков
    cnet.CLayer{m}.FMapHeight = 10;
    cnet.CLayer{m}.ln = m; %Порядковый номер слоя    
    %----Параметры вычисляемые при обучении
    cnet.CLayer{m}.dEdW{1} = 0; %Частная производная ошибки по весам
    cnet.CLayer{m}.dEdB{1} = 0; %Частная производная ошибки по смещениям
    cnet.CLayer{m}.dEdX{1} = 0; %Частная производная ошибки по выходам
    cnet.CLayer{m}.dXdY{1} = 0; %Частная производная выходов по взвешенным суммам
    cnet.CLayer{m}.dYdW{1} = 0; %Частная производная взвешенных сумм по весам    
    cnet.CLayer{m}.dYdB{1} = 0; %Частная производная взвешенных сумм по смещениям 
    cnet.CLayer{m}.H{1} = 0;    %Аппроксимация Гессиана
    cnet.CLayer{m}.mu = 0;      %Регуляризационный фактор. Используется для адаптивной аппроксимации Гессиана на разных этапах обучения.
    cnet.CLayer{m}.dEdX_last{1} = 0; %Предыдущее значение ошибки, приведенной к выходу слоя. 
                                     %Используется для вычисления
                                     %регуляризационного фактора    
    %Карта связей - номер строки соответствует ядру свертки, номер столбца
    %- карте признаков на выходе предыдущего слоя. Нужна для реализации
    %ассиметричности сети
    cnet.CLayer{m}.ConMap = 0;
end

%FLayer - обычный слой
for k=cnet.numCLayers+cnet.numSLayers+1:cnet.numLayers
    %----Параметры инициализируемые конструктором
    cnet.FLayer{m}.teta = 0.2; %Коэффициент обучения для слоя
    if k==cnet.numLayers
       cnet.FLayer{k}.numNeurons = cnet.numOutputs; %Если слой выходной
    else
       cnet.FLayer{k}.numNeurons = 10; %Количество нейронов в слое        
    end
    cnet.FLayer{k}.W = 0; %Массив матриц весовых коэффициентов
    cnet.FLayer{k}.B = 0; %Массив матриц смещений
    %----Параметры вычисляемые в процессе работы сети
    cnet.FLayer{k}.Y = 0; %Значения взвешенных входов 
    cnet.FLayer{k}.X = 0; %Значения выходов слоя
    cnet.FLayer{k}.ln = k; %Порядковый номер слоя    
    cnet.FLayer{k}.TransfFunc = 'tansig_mod'; %Тип функции активации    
%    cnet.FLayer{k}.TransfFunc = 'tansig'; %Тип функции активации        
    %----Параметры вычисляемые при обучении
    cnet.FLayer{m}.dEdW{1} = 0; %Частная производная ошибки по весам
    cnet.FLayer{m}.dEdB{1} = 0; %Частная производная ошибки по смещениям
    cnet.FLayer{m}.dEdX{1} = 0; %Частная производная ошибки по выходам
    cnet.FLayer{m}.dXdY{1} = 0; %Частная производная выходов по взвешенным суммам
    cnet.FLayer{m}.dYdW{1} = 0; %Частная производная взвешенных сумм по весам    
    cnet.FLayer{m}.dYdB{1} = 0; %Частная производная взвешенных сумм по смещениям     
    cnet.FLayer{m}.H{1} = 0;    %Аппроксимация Гессиана
    cnet.FLayer{m}.mu = 0;      %Регуляризационный фактор. Используется для адаптивной аппроксимации Гессиана на разных этапах обучения.
    cnet.FLayer{m}.dEdX_last{1} = 0; %Предыдущее значение ошибки, приведенной к выходу слоя. 
                                     %Используется для вычисления
                                     %регуляризационного фактора 
end
%Везде выше X - это карты признаков

% if((nargin==1)&&(isstruct(numLayers)))
%     cnet = class(numLayers,'cnn');
% else
    
    cnet = class(cnet,'cnn');
% end

