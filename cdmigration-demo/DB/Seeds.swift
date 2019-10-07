//
//  Seeds.swift
//  cdmigration-demo
//
//  Created by Jin He on 10/4/19.
//  Copyright © 2019 Jin He. All rights reserved.
//

import Foundation
import Fakery

struct Seeds {
    static func make(userCount: Int, postCountPerUser: Int) throws {
        let faker = Faker(locale: "nb-NO")
        
        for _ in 0 ..< userCount {
            CoreDataManager.shared.persistentContainer.performBackgroundTask { (moc) in
                let u = User(context: moc)
                u.save(moc, block: {
                    u.email = faker.internet.email()
                    u.id = faker.internet.password()
                    u.name = faker.internet.username()
                    for _ in 0 ..< postCountPerUser {
                        let p = Post(context: moc)
                        p.createdAt = Date()
                        p.title = faker.lorem.word()
                        p.updatedAt = Date()
                    }
                }) { (result) in
                    switch result {
                    case .failure(let err):
                        print(err.localizedDescription)
                    case .success:
                        print("success")
                    }
                }
            }
        }
    }
}
