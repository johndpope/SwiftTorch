import Foundation
import Python
import TensorFlow // No Such Module TensorFlow -> File > Project Settings> Build System -> Legacy



// WARNING - if you get a crash - check which python - it maybe under miniconda3 or miniconda3!
// N.B. - this branch is using miniconda3 not virtualenv see
// https://github.com/johndpope/SwiftReinforce readme
let  path = "/Users/\(NSUserName())/miniconda3/envs/gymai2/lib/python2.7/site-packages/"

// IMPORTANT - if you're using a different environment name
// Schema > Run > Pre-actions - source activate gymai2
let environmentName = "gymai2"

class PythonClass{
    typealias PO = PythonObject
    var math:PythonObject!
    var np:PythonObject!
    var numpy:PythonObject!
    
    var sympy:PythonObject!
    var lambdify:PythonObject!
    var latex:PythonObject!
    var latexTools:PythonObject!
    
    var sys:PythonObject!
    var random:PythonObject!
    var keras:PythonObject!
    var cPickle:PythonObject!
    var torch:PythonObject!
    
    // matplotlib
    var matplotlib:PythonObject!
    var plt:PythonObject!
    
    //custom layers
    var rotationMatrix:PythonObject!
    var layers:PythonObject!

    
    // test_lambda.py
    var testLambda:PythonObject!



    func importSysPath(){
        PythonLibrary.useVersion(2, 7)
        sys = Python.import("sys")
        print("INFO: macOS sysPath:", sys.path)        
        importPackages()
        importThisProjectFolder()
    }
    
    
    func importPackages(){

            importConda()

            math = Python.import("math")
            random = Python.import("random")
            cPickle = Python.import("cPickle")
            importPytorch()

    }
    

    func importMatplot(){
        // Import Python modules
        matplotlib = Python.import("matplotlib")
        np = Python.import("numpy")
        plt = Python.import("matplotlib.pyplot")
        // Turn off using display on server / linux
        matplotlib.use("Agg")
    }
    
    func importConda(){
        
        print("INFO: 🐍 conda environment:",environmentName)
        let  path2 = "/Users/\(NSUserName())/miniconda2/envs/\(environmentName)/lib/python2.7/site-packages/"
        sys?.path.insert(0,path2)
        let  path3 = "/Users/\(NSUserName())/miniconda3/envs/\(environmentName)/lib/python2.7/site-packages/"
        sys?.path.insert(0,path3)
        // N.B. use INSERT rather than append otherwise ran into problems where older numpy version is detected
        // see https://github.com/tensorflow/swift/issues/73 - numpy  1.8.0rc1
        print("INFO: sys path \n",path)
        
        
    }
    
    //TODO - test existence of this class - if not alert user to add hard coded path.
    // nb the executable is going to be executed in some temp folder it won't have relative access to this project folder
    func importThisProjectFolder(){
//        guard let srcRoot = ProcessInfo.processInfo.environment["SRCROOT"] else {
//            fatalError("SRCROOT should be non-nil")
//        }
//
        
        let  customClassPath = "/Users/admin/Documents/gitWorkspace/SwiftTorch/Sources"
        print("WARNING: adding hard coded path to allow access to python class")
        print("(you're  going to want to update projectFolder in Environment.swift):")
        print("path:",customClassPath)
        print("\n\n\n")
        sys?.path.append(customClassPath)
    }

}
