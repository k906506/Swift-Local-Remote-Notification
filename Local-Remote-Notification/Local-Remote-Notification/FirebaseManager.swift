//
//  FirebaseManager.swift
//  Local-Remote-Notification
//
//  Created by 고도현 on 2023/04/03.
//

import Foundation
import FirebaseFirestore

final class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let db = Firestore.firestore()
    
    private init() { }
    
    func sendDeviceToken(deviceToken: String) {
        db.collection("User").addDocument(data: ["deviceToken": deviceToken])
    }
}
