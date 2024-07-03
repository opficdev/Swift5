//
//  jolly.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-03.
//

import Foundation

func isJolly(_ arr: [Int]) -> Bool{
    let n = arr.count
    var diffSet = Array(repeating: false, count: n)
    
    for i in 0..<n - 1{
        let d = abs(arr[i] - arr[i + 1])
        if d == 0 || d > n - 1 || diffSet[d] == true{
            return false
        }
        diffSet[d] = true
    }
    return true
}

@main
struct Main{
    static func main(){
        let fin = FileReader("jolly.inp")!
        let fout = FileWriter("jolly.out")
        var res = ""
        while !fin.isEOF{
            let arr = Array(fin.readLine()!.split(separator: " ").map(({Int($0)!}))[1...])
            res += (isJolly(arr)) ? "Jolly\n" : "Not Jolly\n";
        }
        fout.write(res)       
    }
}
