//
//  ViewController.swift
//  JavaScriptSample
//
//  Created by CSS on 31/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import JavaScriptCore

class ViewController: UIViewController {

    var jsContext : JSContext!
    
    let handler : @convention(block) (String) ->Void = { value in
       
        NotificationCenter.default.post(name: NSNotification.Name("didReceiveRandomNumbers"), object: value)

        print("Recieved  ",value)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialLoads()
    }
    
    
    //MARK:- Initilizing Java Script Context
    
    private func initialLoads(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleDidReceiveLuckyNumbersNotification(notification:)), name: NSNotification.Name("didReceiveRandomNumbers"), object: nil)

        
        self.jsContext = JSContext()
        
        self.jsContext.exceptionHandler = { context, exep in   // Handling Exceptions on Js Execution 
            
            if exep != nil {
                
                print("Exception occured on Handling Js  ",exep!)
            }
            
        }
        
        
        loadJS()
        
        retrieveData()
    }
    
    //MARK:- JS File
    
    private func loadJS(){
        
        
        if let jsFile = Bundle.main.path(forResource: "sample", ofType: "js") {
            
            do {
                
                let jsString = try String(contentsOfFile: jsFile)
                
                self.jsContext.evaluateScript(jsString)
                
                
            } catch let err {
                
                print("Faced an error while loading ",err.localizedDescription)
                
            }
            
        }
        
        
    }
    
    
    //MARK:- Retrieve Data from  JSContext
    
    private func retrieveData(){
        
        
        if let variable = jsContext.objectForKeyedSubscript("helloWorld") {
            
            print(variable)
            
        }
        
        if let variable = jsContext.objectForKeyedSubscript("greet") {
            
            print(variable.call(withArguments: ["Jayan"]))
            
        }
        
        
        handler("Bro")
        
        loadMethod()
        
        
    }
    
    

    //MARK:- Call Method
    
    private func loadMethod(){
        
        let object = unsafeBitCast(handler, to: AnyObject.self)
        
        jsContext.setObject(object, forKeyedSubscript: "greet" as NSCopying & NSObjectProtocol)
        
//        if let variable = jsContext.objectForKeyedSubscript("helloWorld") {
//
//            print(variable)
//
//        }
        
        jsContext.evaluateScript("greet")
        
    }
  


    private func handleDidReceiveLuckyNumbersNotification(notification: NSNotification){
        
        print(notification.userInfo, notification.object)
        
    }
    
    
    
}

