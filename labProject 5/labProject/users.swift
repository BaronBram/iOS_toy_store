//
//  users.swift
//  labProject
//
//  Created by prk on 05/12/23.
//

import Foundation

struct userdata{
    var userName: String?
    var userEmail: String?
    var password: String?
    var isAdmin: Bool?
}

class users{
    var userdb: [userdata] = []
}
