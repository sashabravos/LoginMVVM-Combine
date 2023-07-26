//
//  User.swift
//  JustChat
//
//  Created by Александра Кострова on 21.06.2023.
//

import Foundation

struct User {
    let login: String?
    let password: String?
}

extension User {
    static var logins = [
    User(login: "User", password: "12345")]
}
