//
//  Request.swift
//  App
//
//  Created by Gabriel Leandro Mazzei on 19/9/18.
//

import Vapor
import Pagination

/// Checks if the request parameters include pagination options
extension Request {
    
    func hasPagination() -> Bool {
        do {
            return try query.get(Int?.self, at: Pagination.defaultPageKey) != nil
        } catch {
            print("Error: \(error)")
            return false
        }
    }
    
}
