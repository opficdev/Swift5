//
//  pair.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-03.
//

import Foundation

struct Pair<T1: Comparable, T2: Comparable>: Comparable {
    var first: T1?
    var second: T2?
    init(_ first: T1? = nil, _ second: T2? = nil) {
        self.first = first
        self.second = second
    }
    
    static func < (lhs: Pair<T1, T2>, rhs: Pair<T1, T2>) -> Bool{
            guard let lhsFirst = lhs.first, let lhsSecond = lhs.second,
                  let rhsFirst = rhs.first, let rhsSecond = rhs.second else {
                return false // 하나라도 nil이면 false 반환
            }
            return lhsFirst < rhsFirst || (lhsFirst == rhsFirst && lhsSecond < rhsSecond)
        }
    
    static func == (lhs: Pair<T1, T2>, rhs: Pair<T1, T2>) -> Bool where T1: Comparable, T2: Comparable {
        return lhs.first == rhs.first && lhs.second == rhs.second
    }
}

