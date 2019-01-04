//
//  Conda.swift
//  SwiftReinforce
//
//  Created by Pope, John on 9/21/18.
//  Copyright © 2018 Sascha Schramm. All rights reserved.
//

import Foundation
import Python


// Port of this code
//https://pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html
extension PythonClass{
    
   
  
    // conda install pytorch torchvision -c pytorch
    func importPytorch(){
        print("🔥 import torch")
        torch = Python.import("torch")
    }
    
    func testPytorch(){
        print("INFO:⛳️ Testing CIFAR PyTorch....")
        // IMPORTANT - hack required to get  torchvision   to load
        // in your Users/YOURUSERNAMEHERE/miniconda3/envs/gymai/lib/python2.7/site-packages/
        // rename torchvision-0.2.1-py2.7.egg file to .zip - extract out torchvision folder to site-packages root folder
        let torchvision = Python.import("torchvision")
        let transforms = torchvision.transforms
        let transform = transforms.Compose(
            [transforms.ToTensor(),
             transforms.Normalize([0.5, 0.5, 0.5], [0.5, 0.5, 0.5])])
        let trainset = torchvision.datasets.CIFAR10(root:"./data", train:true,
                                                download:true, transform:transform)
        let trainloader = torch.utils.data.DataLoader(trainset, batch_size:4,
                                                  shuffle:true, num_workers:2)
        let testset = torchvision.datasets.CIFAR10(root:"./data", train:false,
                                               download:true, transform:transform)
        let testloader = torch.utils.data.DataLoader(testset, batch_size:4,
                                                 shuffle:false, num_workers:2)
        let classes = ("plane", "car", "bird", "cat","deer", "dog", "frog", "horse", "ship", "truck")
        
        let nn = Python.import("torch.nn")
        let F = Python.import("torch.nn.functional")
        let neuralNet = Python.import("NeuralNet").NeuralNet() // hack - load local NeuralNet.py
        
        //  CUDA
        //Assume that we are on a CUDA machine, then this should print a CUDA device:
        let cuda = Python.import("torch.cuda")
        if (cuda.is_available() == true){
            let device = torch.device("cuda:0")
            neuralNet.to(device)
            print(device)
        }else{
            print( "using cpu")
        }
        
        let optim = Python.import("torch.optim")
        let criterion = nn.CrossEntropyLoss()
        let optimizer = optim.SGD(neuralNet.parameters(), lr:0.001, momentum:0.9)
        
        var  runningLoss = 0.0
        
        for epoch in 0...2{
            runningLoss = 0.0
            

            // TODO - fix this wart - trainloader.enumerated() / Python.enumerate(trainloader)
            let dataIter:PythonObject = Python.iter(trainloader)
            
            //idx: 12499
            for idx in trainloader.indices{
                let data = dataIter.next()

                //// get the inputs
                let inputs = data[0]
                let labels = data[1]
                //  zero the parameter gradients
                optimizer.zero_grad()

                //  forward + backward + optimize
                let outputs = neuralNet(inputs)
                let loss = criterion(outputs, labels)
                loss.backward()
                optimizer.step()

                // print statistics
                runningLoss += Double(loss.item())!
                //print every 2000 mini-batches
                if (Int(idx)! % 2000 == 1999){
                    print("[epoch:\(epoch), \(idx + 1)] loss: \(runningLoss / 2000)")
                }
            }

            runningLoss = 0.0
            
            print("Finished Training")
        }
        
        // Test network
        let testiter = Python.iter(testloader)
        let data = testiter.next()
        let images = data[0]
        let labels = data[1]
        
        let outputs = neuralNet(images)
        
        
   
//        let (_, predicted) = torch.max(outputs) Bug here on using max as it is a predefined swift helper
//        print("predicted:",predicted)
        print("test images:",images)
        print("test labels:",labels)
        print("nn outputs:",outputs)
    }
    
    func showImages(){
        /*import matplotlib.pyplot as plt
         import numpy as np
         
         # functions to show an image
         
         
         def imshow(img):
         img = img / 2 + 0.5     # unnormalize
         npimg = img.numpy()
         plt.imshow(np.transpose(npimg, (1, 2, 0)))
         
         
         # get some random training images
         dataiter = iter(trainloader)
         images, labels = dataiter.next()
         
         # show images
         imshow(torchvision.utils.make_grid(images))
         # print labels
         print(' '.join('%5s' % classes[labels[j]] for j in range(4)))*/
    }
}
