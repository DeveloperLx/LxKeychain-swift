//
//  LxKeychain.swift
//  LxKeychainDemo
//

import UIKit

let LxKeychainEncryptionBlock = {(string: String) -> String in

    //  You can custom here
    
    return string
}

let LX_USERNAME_ARRAY_SERVICE = "LX_USERNAME_ARRAY_SERVICE";
let LX_USERNAME_KEY = "LX_USERNAME_KEY";
let LX_PASSWORD_KEY = "LX_PASSWORD_KEY";
let LX_DEVICE_UNIQUE_IDENTIFIER = "LX_DEVICE_UNIQUE_IDENTIFIER";

class LxKeychain {
    
    private class func generateServiceByUsername(username: String) -> String {
        return LxKeychainEncryptionBlock(username)
    }

    class func insertOrUpdatePairsOfUsername(username: String, password: String) -> OSStatus {
    
        let service = generateServiceByUsername(username)
        var status = noErr
        status = deleteService(service)
        status = saveData(password, forService: service)
        
        let usernameArrayService = LxKeychainEncryptionBlock(LX_USERNAME_ARRAY_SERVICE)
        
        var usernameArray = savedUsernameArray()
        
        if contains(usernameArray, username) {
            let index = find(usernameArray, username)
            usernameArray.removeAtIndex(index!)
        }
        
        usernameArray.append(username)
        status = deleteService(usernameArrayService)
        status = saveData(usernameArray, forService: usernameArrayService)
        
        return status
    }
    
    class func cleanPasswordForUsername(username: String) -> OSStatus {
    
        let service = generateServiceByUsername(username)
        var status = noErr
        status = deleteService(service)
        status = saveData(nil, forService: service)
        return status
    }
    
    class func deletePairsByUsername(username: String) -> OSStatus {
    
        let service = generateServiceByUsername(username)
        var status = noErr
        status = deleteService(service)
        
        let usernameArrayService = LxKeychainEncryptionBlock(LX_USERNAME_ARRAY_SERVICE)
        var usernameArray = savedUsernameArray()
        if contains(usernameArray, username) {
            let index = find(usernameArray, username)
            usernameArray.removeAtIndex(index!)
        }
        
        status = deleteService(usernameArrayService)
        status = saveData(usernameArray, forService: usernameArrayService)
        
        return status
    }
    
    class func passwordForUsername(username: String) -> String? {
    
        let service = generateServiceByUsername(username)
        return fetchDataOfService(service) as? String
    }
    
    class func password(password: String, isCorrectToUsername username: String) -> Bool {
        
        return password == passwordForUsername(username)
    }
    
    class func savedUsernameArray() -> [String] {
    
        let usernameArrayService = LxKeychainEncryptionBlock(LX_USERNAME_ARRAY_SERVICE)
        var usernameArray = fetchDataOfService(usernameArrayService) as? [String]
        if usernameArray == nil {
            
            usernameArray = [String]()
        }
        return usernameArray!
    }

    class func lastestUpdatedUsername() -> String? {
    
        return savedUsernameArray().last
    }
    
//  MARK:- fundation
    class func generateQueryMutableDictionaryOfService(service: String) -> NSMutableDictionary {
        
        let queryDictionary = NSMutableDictionary()
        queryDictionary.setValue(kSecClassGenericPassword as String, forKey: kSecClass as String)
        queryDictionary.setValue(kSecAttrAccessibleAfterFirstUnlock as String, forKey: kSecAttrAccessible as String)
        queryDictionary.setValue(service, forKey: kSecAttrService as String)
        queryDictionary.setValue(service, forKey: kSecAttrAccount as String)
        
        return queryDictionary
    }
    
    class func saveData(data: NSCoding?, forService service: String) -> OSStatus {
        
        var keychainQuery = generateQueryMutableDictionaryOfService(service)
        
        var status = noErr
        status = SecItemDelete(keychainQuery)
        
        if let d = data {
        
            keychainQuery[kSecValueData as String] = NSKeyedArchiver.archivedDataWithRootObject(d)
        }
        else {
            keychainQuery[kSecValueData as String] = NSKeyedArchiver.archivedDataWithRootObject(NSData())
        }
        
        var result: Unmanaged<AnyObject>? = nil
        status = SecItemAdd(keychainQuery, &result)
        
        return status
    }
    
    class func fetchDataOfService(service: String) -> NSCoding? {
    
        var keychainQuery = generateQueryMutableDictionaryOfService(service)
        keychainQuery[kSecReturnData as String] = kCFBooleanTrue
        keychainQuery[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var status = noErr
        
        var matchResult: Unmanaged<AnyObject>?
        status = SecItemCopyMatching(keychainQuery, &matchResult)
        
        if status == noErr {
            
            let opaque = matchResult?.toOpaque()
            var archivedData = Unmanaged<NSData>.fromOpaque(opaque!).takeUnretainedValue()
        
            let data: AnyObject? = NSKeyedUnarchiver.unarchiveObjectWithData(archivedData)
            return data as? NSCoding
        }
        return nil
    }

    class func deleteService(service: String) -> OSStatus {
    
        var keychainQuery = generateQueryMutableDictionaryOfService(service)
        return SecItemDelete(keychainQuery)
    }
    
    class func deviceUniqueIdentifer() -> String {
    
        var deviceUniqueIdentifer = fetchDataOfService(LX_DEVICE_UNIQUE_IDENTIFIER) as? String
        
        if let d = deviceUniqueIdentifer {
        
            deviceUniqueIdentifer = UIDevice.currentDevice().identifierForVendor.UUIDString
            saveData(deviceUniqueIdentifer, forService: LX_DEVICE_UNIQUE_IDENTIFIER)
        }
        
        return deviceUniqueIdentifer!
    }
}








