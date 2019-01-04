
**Programatically Generating Xcode Projects with default settings / flags**    
There's a bunch of flags / settings needed to get up tensorflow up and and running with new xcode executable project. 
For new projects you can run
```shell
 brew install XcodeGen
 XcodeGen 
 ```
 to spit out new xcode projects. Just update the Sources.  
https://github.com/johndpope/swift-models/tree/stable/Inference     


<img src="Images/project2.png" width="800">

Unfortunately - there's still a manual step to fix build system.
1. In the menu bar, select `File > Project Settings...`.
2. Then, select `Legacy Build System` for Build Settings and click `Done`.
 
