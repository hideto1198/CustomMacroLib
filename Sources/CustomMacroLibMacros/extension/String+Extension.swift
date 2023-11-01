//
//  String+Extension.swift
//
//
//  Created by 東　秀斗 on 2023/11/01.
//

import Foundation

extension String {
    var camelCased: Self {
        let initial = self.prefix(1).lowercased()
        return initial + self.dropFirst()
    }
}
