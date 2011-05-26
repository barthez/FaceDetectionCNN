CNN Class, ver 0.8.

This project provides matlab class for implementation of convolutional neural networks. This networks was created by Yann LeCun and have sucessfully used in many practical applications, such as handwriten digits recognition, face detection, robot navigation and others (see references for more info). Because of some architectural features of convolutional networks, such as weight sharing it is imposible to implement it using Matlab Neural Network Toolbox without it's source modifications. That's why this class wokrs almost independently from NN toolbox (coming soon full independence). 

The significant improovement in this version is a presence of cudacnn mex-file, which speeds up the training up to 44 times using NVidia's CUDA technology.You'll need a CUDA-capable graphic card and CUDA SDK (especially cudart.dll and cublas.dll). The source of cudacnn.mex is not included by now, but I plan to do It in future. Currently only stochastic gradient is supported by CUDA-training, but Hessian approximation is going to be soon also.

This release includes sample of handwriten digits recognition using CNN. If you just want to try it run cnet_tool. You'll see a simple GUI. It loads pretrained convolutional neural net from cnet.mat and recognizes image of gigit either pained in painitg area or downloaded from MNIST database. 

If you interested in training you should open train_cnn.m, set all parameters following to comments and start learning by runing it.

The action sequence for creation of arbitrary convolutional neural network is following:
1. Create cnn object.
2. Set archtecture (number of layers, weights, training parameters, etc).
3. Call init method.
4. Define connection matrices for layers if necessary.
5. Load training data.
6. Preprocess training data.
7. Start training.
8. Test neural net.

There're several limitations in current version:
1. Network can have only one input for image (e.g. no stereo images simulateously).
2. You have to set connection matrix after the initialization.
3. MNIST database of handwriten digits not included in this distribution, you can download it from http://yann.lecun.com/exdb/mnist/index.html


Next version expectations:
1. Ability to work with several images simulateously.
2. Image Aquision toolbox integration.
3. Face detection sample.

References:
1. Y. LeCun, L. Bottou, G. Orr and K. Muller: Efficient BackProp, in Orr, G.
and Muller K. (Eds), Neural Networks: Tricks of the trade, Springer, 1998
URL:http://yann.lecun.com/exdb/publis/index.html
2. Y. LeCun, L. Bottou, Y. Bengio and P. Haffner: Gradient-Based Learning
Applied to Document Recognition, Proceedings of the IEEE, 86(11):2278-2324, November 1998
URL:http://yann.lecun.com/exdb/publis/index.html
3. Patrice Y. Simard, Dave Steinkraus, John C. Platt: Best Practices for
Convolutional Neural Networks Applied to Visual Document Analysis
URL:http://research.microsoft.com/apps/pubs/?id=68920
4. Thanks to Mike O'Neill for his great article, wich is summarize and
generalize all the information in 1-3 for better understandig for
programming:
URL: http://www.codeproject.com/KB/library/NeuralNetRecognition.aspx
5. Also thanks to Jake Bouvrie for his "Notes on Convolutional Neural
Networks", particulary for the idea to debug the neural network using
finite differences
URL: http://web.mit.edu/jvb/www/cv.html

==========
(c) Mikhail Sitotenko. This software distributing under BSD licence.