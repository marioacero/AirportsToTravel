//
//  RealmManager.swift
//  worldAirports
//
//  Created by Mario Acero on 9/9/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation
import RealmSwift


typealias AirportsDictionary = Results<AirportsRealm>

class RealmManager {
    
    private var realm: Realm!
    private static var instance: RealmManager?
    static var shared: RealmManager {
        if instance == nil {
            instance = RealmManager()
        }
        return instance!
    }
    
    private func getRealmInstance() -> Realm? {
        do {
            let realmInstance = try Realm()
            return realmInstance
        } catch let error as NSError {
            assertionFailure("Somethig went wrong with Realm, error = \(error.description)")
        }
        return nil
    }
    
    
    private init() {
        realm = getRealmInstance()!
    }
    
    func getAll <T: Object> (Class: T.Type) -> Results<T> {
        var list: Results<T>? = nil
        list = realm.objects(Class)
        return list!
    }
    
    func getAllWithPredicate <T: Object> (Class: T.Type, equalParam: NSPredicate) -> Results<T> {
        var list: Results<T>? = nil
        list = realm.objects(Class).filter(equalParam)
        return list!
    }
    
    func addObject(object: Object, update: Bool = false) {
        if realm.isInWriteTransaction {
            realm.add(object, update: update)
            return
        }
        
        do {
            try realm.write {
                realm.add(object, update: update)
            }
        } catch let error as NSError {
            assertionFailure("Somethig went wrong with Realm (Write), error = \(error.description)")
        }
    }
    
    func deleteAllObject <T: Object> (Class: T.Type) -> Void {
        realm.beginWrite()
        let realmResults = realm.objects(Class)
        if(!realmResults.isEmpty) {
            for object in realmResults {
                realm.delete(object)
            }
        }
        try! realm.commitWrite()
    }
}
