//
//  UserDefaultsUtils.swift
//  HNMobileTest
//
//  Created by Diego Sepúlveda on 5/29/19.
//  Copyright © 2019 reigndesign. All rights reserved.
//
import Foundation

class UserDefaultsUtils {

    class func saveHits(_ hits: [Hit]){

        var loadedHits = loadHits()
        let deletedHits = loadDeletedHits()

        hits.forEach { (hit) in
            if !deletedHits.contains(where: {$0.objectId == hit.objectId})
                && !loadedHits.contains(where: {$0.objectId == hit.objectId}) {
                loadedHits.insert(hit, at: 0)
            }
        }

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(loadedHits) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "hits")
        }
    }

    class func loadHits() -> [Hit] {
        let defaults = UserDefaults.standard
        if let hits = defaults.object(forKey: "hits") as? Data {
            let decoder = JSONDecoder()
            if let loadedHits = try? decoder.decode([Hit].self, from: hits) {
                return loadedHits.sorted(by: { $0.createdAtI! > $1.createdAtI! })
            }
        }

        return []
    }

    class func deleteHit(_ hit: Hit!){
        var loadedHits = loadHits()
        loadedHits.removeAll(where: {$0.objectId! == hit.objectId!})

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(loadedHits) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "hits")
        }

        var deletedHits = loadDeletedHits()
        deletedHits.append(hit)
        saveDeletedHits(deletedHits)


    }

    class func saveDeletedHits(_ hits: [Hit]){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(hits) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "deletedHits")
        }
    }

    class func loadDeletedHits() -> [Hit] {
        let defaults = UserDefaults.standard
        if let hits = defaults.object(forKey: "deletedHits") as? Data {
            let decoder = JSONDecoder()
            if let loadedHits = try? decoder.decode([Hit].self, from: hits) {
                return loadedHits
            }
        }

        return []
    }

}
