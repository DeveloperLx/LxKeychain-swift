# LxKeychain-swift
  Manage your username and password for iOS and OS X platform. Highly encryption and won't be lose even you uninstall your app.
Installation
------------
  You only need drag LxKeychain.swift to your project.
Support
------------
  Minimum support iOS version: iOS 6.0
Usage
--------------

    println("savedUsernameArray = \(LxKeychain.savedUsernameArray())")
        
    LxKeychain.insertOrUpdatePairsOfUsername("username1", password: "password1")
    LxKeychain.insertOrUpdatePairsOfUsername("username2", password: "password2")
    LxKeychain.insertOrUpdatePairsOfUsername("username3", password: "password3")
    LxKeychain.insertOrUpdatePairsOfUsername("username1", password: "password4")
    LxKeychain.cleanPasswordForUsername("username2")
    LxKeychain.deletePairsByUsername("username3")
    
    println("savedUsernameArray = \(LxKeychain.savedUsernameArray())")
    
    let username1 = "username1"
    println("username1 password: \(LxKeychain.passwordForUsername(username1))")
    
    let password1 = "password1"
    var judgement = LxKeychain.password(password1, isCorrectToUsername: username1) ? "is" : "is not"
    println("username1's password \(judgement) password1")
    let password4 = "password4"
    judgement = LxKeychain.password(password4, isCorrectToUsername: username1) ? "is" : "is not"
    println("username1's password \(judgement) password4")
    
    println("lastestUpdatedUsername = \(LxKeychain.lastestUpdatedUsername())")
    
    let YourSaveKey = "YourSaveKey"
    println("Your saved string: \(LxKeychain.fetchDataOfService(YourSaveKey))")
    LxKeychain.saveData("Here is What you want to save forever!", forService: YourSaveKey)
    
    println("Your LxKeychain device unique identifer is \(LxKeychain.deviceUniqueIdentifer())")
License
-----------
  LxKeychain is available under the Apache License 2.0. See the LICENSE file for more info.