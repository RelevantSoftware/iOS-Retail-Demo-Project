//
//  APIOperation.swift
//

import MagicalRecord
import CoreData
import Alamofire

enum NetworkMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
    case local = "LOCAL"
}

private let queuePrefix = (Bundle.main.bundleIdentifier ?? "") + "queue.apioperation"
private let requestsQueue = DispatchQueue(label: queuePrefix + "request", attributes: [.concurrent])
private let savingQueue = DispatchQueue(label: queuePrefix + "saving")

class APIOperation<T:Initializable>: ConcurrentOperation {
    
    typealias Response = T
    
    var path: String
    var parameters: Parameters?
    var headerFields: [String: String]?
    private var requestOperation: RequestOperation?
    private let networkMethod: NetworkMethod
    private let completion: Completion?
    var deleteEntities = false
    private let fileData: FileData?
    var json: JSONCompletion?
    var errorCompletion: ErrorCompletion?
    
    typealias JSONCompletion = (Any) -> Void
    typealias Completion = (T?, Error?) -> Void
    typealias ErrorCompletion = (String) -> Void

    //We should use this workaround because of compiler limitations: http://stackoverflow.com/questions/24161563/swift-compile-error-when-subclassing-nsobject-and-using-generics
    private var results: [T] = []
    var result: T? {
        get {
            return results.first
        }
        set {
            if let value = newValue {
                results = [value]
            } else {
                results = []
            }
        }
    }
    private(set) var error: Error?
    
    init(networkMethod: NetworkMethod, path: String, headerFields: [String : String] = [:], parameters: Parameters? = nil, fileData: FileData? = nil, completion: Completion? = nil) {
        self.path = path
        self.headerFields = headerFields
        self.parameters = parameters
        self.completion = completion
        self.networkMethod = networkMethod
        self.fileData = fileData
        //MARK: hack to avoid wrong headers in other requests
        if (path.contains("products")) {
        	self.headerFields?["Authorization"] = "Token token=b22c7656cd0f509dc168849f2c0076ed"
        }
    }
    
    override func start() {
        if self.isCancelled || self.isExecuting || self.isFinished {
            return
        }
        self.setValue(true, forKey: executingKey)
        requestsQueue.async(execute: { () -> Void in
            
            let semaphore = DispatchSemaphore(value: 0)
            self.preExecute() { (error) -> Void in
                self.error = error
                semaphore.signal()
            }
            
            _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            var originalResponse: Any?
            if self.error == nil {
                self.requestOperation = RequestOperation(networkMethod: self.networkMethod,
                    path: self.path, headerFields: self.headerFields,
                    parameters: self.parameters, fileData: self.fileData)
                self.requestOperation?.start()
                self.requestOperation?.waitUntilFinished()
                
                originalResponse = self.requestOperation?.result
                self.json?(self.requestOperation?.json ?? [])
                let statusCode = self.requestOperation?.statusCode ?? 0
                if statusCode >= 400 {
                    if let json = self.requestOperation?.json as? [String : AnyObject] {
                        if let array = json["data"] as? [[String : AnyObject]],
                            let errorString = array.first?["message"] as? String {
                            self.errorCompletion?(errorString)
                            
                        } else if let data = json["data"] as? [String : AnyObject],
                            let errorString = data["message"] as? String {
                            self.errorCompletion?(errorString)
                        }
                    }
                    self.error = self.requestOperation?.error
                }
            }
            
            if self.error == nil {
                savingQueue.sync(execute: { () -> Void in
                    let processedResponse: Any? = self.willProcessResponse(response: originalResponse)
                    if let managedObjectClass = T.self as? NSManagedObject.Type {
                        var object: NSManagedObject?
                        MagicalRecord.save(blockAndWait: { (managedObjectContext) -> Void in
                            print(processedResponse ?? "")
                            object = managedObjectClass.mr_import(from: processedResponse, in: managedObjectContext)
                        })
                        let context = NSManagedObjectContext.mr_default()
                        var objectInMainMOC: NSManagedObject?
                        context.performAndWait({ () -> Void in
                            objectInMainMOC = object?.mr_(in: context)
                        })
                        self.result = objectInMainMOC as? T
                    }
                    else if let container = T() as? ContainerType,
                        let managedObjectClass = container.elementType() as? NSManagedObject.Type,
                        let array = processedResponse as? [AnyObject] {
                        var dbObjects: [NSManagedObject]?
                        MagicalRecord.save(blockAndWait: { (managedObjectContext) -> Void in
                            for object in array {
                                let managedObject = managedObjectClass.mr_import(from: object, in: managedObjectContext) as! NSManagedObject
                                dbObjects?.append(managedObject)

                            }
                            //dbObjects = managedObjectClass.mr_import(from: array, in: managedObjectContext).map{($0 as! NSManagedObject)}
//                            dbObjects = managedObjectClass.mr_import(from: array, in: managedObjectContext).map{($0 as! NSManagedObject)}
                            // TODO: only temporary decision, bad logic
                            if self.deleteEntities {
                                managedObjectClass.mr_deleteAll(matching: NSPredicate(format: "NOT (self IN %@)", argumentArray: [dbObjects ?? []]), in: managedObjectContext)
                            }
                        })
                        let objectIDs = (dbObjects ?? []).map { $0.objectID }
                        var dbObjectsInMainMOC = NSMutableArray()
                            
                        let context = NSManagedObjectContext.mr_default()
                        context.performAndWait({ () -> Void in
                            dbObjectsInMainMOC = objectIDs.reduce(NSMutableArray(), {
                                $0.0.add(context.object(with: $0.1) as Any)
                                return $0.0
                            })
                        })
                        self.result = dbObjectsInMainMOC as? T
                    }
                })
            }

            if self.error == nil {
                self.didProcessResponse(response: originalResponse)
            }
            else {
                print("ERROR: Response is not mapped")
            }
            
            if self.error == nil {
                self.postExecute() { (error) -> Void in
                    self.error = error
                    semaphore.signal()
                }
                _ = semaphore.wait(timeout: DispatchTime.distantFuture)
            }
            
            self.setValue(false, forKey: self.executingKey)
            self.setValue(true, forKey: self.finishedKey)
            DispatchQueue.main.async(execute: { () -> Void in
                self.completion?(self.result, self.error)
            })
        })
    }
    
    
    //Override these methods if you want to perform some task before loading starts or after it ends
    //Do not forget call completion block when your task finishes
    func preExecute(completion: (Error?) -> Void) {
        completion(nil)
    }
    
    func postExecute(completion: (Error?) -> Void) {
        completion(nil)
    }
    
    // will replace response by return value
    func willProcessResponse(response: Any?) -> Any? {
        return response
    }
    
    func didProcessResponse(response: Any?) {
        
    }
}
