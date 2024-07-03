//
//  crt.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-03.
//

import Foundation

func gcd(_ a: Int64,_ b: Int64) -> Int64{
    var a = a, b = b
    if a > b{
        swap(&a, &b)
    }
    if a == 0{
        return b
    }
    return gcd(b % a, a)
}

func lcm(_ a: Int64,_ b: Int64) -> Int64{
    return a / gcd(a, b) * b
}

func inv(_ a: Int64,_ b: Int64) -> Int64{
    var a = a, b = b
    var s:[Int64] = [1, 0], t: [Int64] = [0, 1]
    
    while b > 0{
        let q = a / b
        let r = a % b
        let sn = s[0] - q * s[1], tn = t[0] - q * t[1]
        a = b; b = r; s[0] = s[1]; s[1] = sn; t[0] = t[1]; t[1] = tn
    }
    
    return s[0]
}

struct Expr{
    var a: Int64, c: Int64
    init(_ a: Int64,_ c: Int64) {
        self.a = a
        self.c = c
    }
}

@main
struct Main{
    static func main(){
        let fin = FileReader("crt.inp")!
        let fout = FileWriter("crt.out")
        
        let T = Int(fin.readLine()!)!
        var res = ""
        for _ in 0..<T{
            let K = Int(fin.readLine()!)!
            
            var exprs:[Pair<Int64, Int64>] = []
            for _ in 0..<K{
                let inp = fin.readLine()!.split(separator: " ").map({Int64($0)!})
                exprs.append(Pair(inp[0], inp[1]))
            }
            
            var _lcm: Int64 = 1
            for i in exprs{
                _lcm = lcm(_lcm, i.second!)
            }
            
            var exp = Expr(1, 0)
            var flag = true
            
            for i in 0..<K{
                var nxt = exp
                var a = exprs[i].first!, m = exprs[i].second!
                
                if nxt.c != 0{
                    a -= nxt.c; a %= m; a += m; a %= m
                    nxt.c = 0
                }
                
                let g = gcd(nxt.a, gcd(a, m))
                nxt.a /= g; a /= g; m /= g
                nxt.a %= m
                
                if (nxt.a != 1){
                    if gcd(nxt.a, m) != 1{
                        flag = false
                        break
                    }
                    
                    var _inv = inv(nxt.a, m)
                    if _inv < 0{
                        _inv += m
                    }
                    nxt.a = 1
                    a = a * _inv % m
                }
                exp.c += exp.a * a; exp.c %= _lcm
                exp.a *= m; exp.a %= _lcm
            }
            res += (flag ? "\(exp.c)" : "-1") + "\n"
        }
        fout.write(res)
    }
}
