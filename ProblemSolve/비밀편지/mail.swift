//
//  mail.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-28.
//

import Foundation

let Code = [
    "000000": "A",
    "001111": "B",
    "010011": "C",
    "011100": "D",
    "100110": "E",
    "101001": "F",
    "110101": "G",
    "111010": "H"
]


let fin = FileReader("mail.inp")!
let fout = FileWriter("mail.out")
var res = ""


func check(_ s: String){
    if let cs = Code[s]{
        res += cs
        return
    }
    for c in Code{
        let bin = String(Int(s, radix: 2)! ^ Int(c.key, radix: 2)!, radix: 2)
        if bin.split(separator: "1", omittingEmptySubsequences: false).count - 1 < 2{   //  bin.components(separatedBy: "1") 로도 가능
            res += c.value
            return
        }
    }
    res += "X"
}

@main
struct Main{
    static func main(){
        for _ in 0..<Int(fin.readLine()!)!{
            let _ = Int(fin.readLine()!)!
            let str = fin.readLine()!
            var index = str.startIndex
            while let lastIndex = str.index(index, offsetBy: 6, limitedBy: str.endIndex){
                check(String(str[index..<lastIndex]))
                index = str.index(index, offsetBy: 6)
            }
            res += "\n"
        }
        fout.write(res)
    }
}
