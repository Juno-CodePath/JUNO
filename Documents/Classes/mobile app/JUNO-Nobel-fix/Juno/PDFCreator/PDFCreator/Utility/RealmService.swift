//
//  RealmService.swift
//  PDFCreator
//
//  Created by Lahiru Chathuranga on 2/19/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init() {}
    
    static let shared = RealmService()
    
    var realm = try! Realm()
    
    // Create
    func crete<T: Object>(object: T) {
        
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            post(error)
        }
    }
    
    func replace<T: Object>(object: T) {
        
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            post(error)
        }
    }
    
    func read<T: Object>(object: T.Type) -> Results<T>! {
        
        let realm = RealmService.shared.realm
        let results = realm.objects(T.self)
        return results
    }
    
    func update<T: Object>(object: T, with dictionary: [String:Any?]) {
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            post(error)
        }
    }
    
    func delete<T: Object>(_ object: T) {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            post(error)
        }
    }
    
    func remove<T: Object>(objectsOfInstanceType instanceType: T.Type) {
        let realm = try! Realm()
        let objects = realm.objects(instanceType)
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            post(error)
        }
    }
    
    // Error Handling
    enum ErrorNotification {
        static let realmError = Notification.Name("RealmError")
    }
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: ErrorNotification.realmError, object: error)
    }
    
    func observeRealmError(in vc: UIViewController, completion: @escaping (Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: ErrorNotification.realmError,
                                               object: nil,
                                               queue: nil) { (notification) in
                                                completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc, name: ErrorNotification.realmError, object: nil)
    }
}
