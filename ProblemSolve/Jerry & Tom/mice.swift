//
//  mice.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-31.
//

import Foundation


struct Point: Comparable{
    var x: Int64, y: Int64
    init(_ x: Int64,_ y: Int64) {
        self.x = x
        self.y = y
    }
    init(_ xy:[Int64]){
        self.x = xy[0]
        self.y = xy[1]
    }
    static func < (p0: Point, p1: Point) -> Bool{
        return p0.x < p1.x || (p0.x == p1.x && p0.y < p1.y)
    }
    static func == (p0: Point, p1: Point) -> Bool{
        return p0.x == p1.x && p0.y == p1.y
    }
}

var dots = [Point](), holes = [Point](), mice = [Point]()
var adj = [[Int]](), c = [[Int]](), f = [[Int]]()
var n = 0, k = 0, h = 0, m = 0
var res = ""

func CCW(_ p1: Point,_ p2: Point,_ p3: Point) -> Int{
    var S = p1.x * p2.y + p2.x * p3.y + p3.x * p1.y
    S -= p1.y * p2.x + p2.y * p3.x + p3.y * p1.x
    return S == 0 ? 0 : S > 0 ? 1 : -1
}

func isOneLine(_ p1: Point,_ p2: Point,_ p3: Point,_ p4: Point) -> Bool{
    var a:Int64 = 0, b:Int64 = 0, c:Int64 = 0, d:Int64 = 0
    if (p1.x == p2.x){
        a = min(p1.y, p2.y)
        b = max(p1.y, p2.y)
        c = min(p3.y, p4.y)
        d = max(p3.y, p4.y)
    }
    else{
        a = min(p1.x, p2.x)
        b = max(p1.x, p2.x)
        c = min(p3.x, p4.x)
        d = max(p3.x, p4.x)
    }
    return a <= d && c <= b
}

func isCrossed(_ p1: Point,_ p2: Point) -> Bool{
    var count = 0
    for i in 0..<n{
        let d1 = dots[i], d2 = dots[i+1]
        if p2 == d1{
            continue
        }
        let s1 = CCW(p1, p2, d1) * CCW(p1, p2, d2), s2 = CCW(d1, d2, p1) * CCW(d1, d2, p2)
        
        if (s1 <= 0 && s2 < 0) || (s1 < 0 && s2 <= 0){
            count += 1
        }
        else if s1 == 0 && s2 == 0 && isOneLine(d1, d2, p1, p2){
            count += 1
        }
        if count > 1{
            return true
        }
    }
    return false
}

func addEdges(){
    for i in 0..<m{
        for j in 0..<h{
            if (!isCrossed(mice[i], holes[j])){
                adj[i].append(j+m)
                adj[j+m].append(i)
                c[i][j+m] = 1
            }
        }
    }
}

func maxFlow(){
    var r = 0
    while true{
        var minFlow = 15000
        var prev = Array(repeating: -1, count: m+h+2)
        var q = Queue([m+h])
        prev[m+h] = -2
        
        while (!q.isEmpty){
            let cur = q.pop()!
            for next in adj[cur]{
                if c[cur][next] - f[cur][next] > 0 && prev[next] == -1{
                    q.append(next)
                    prev[next] = cur
                }
            }
        }
        if prev[m+h+1] == -1{
            break
        }
        
        var i = m+h+1
        while i != m+h{
            minFlow = min(minFlow, c[prev[i]][i] - f[prev[i]][i]);
            i = prev[i]
        }
        
        i = m+h+1
        while i != m+h{
            f[prev[i]][i] += minFlow; f[i][prev[i]] -= minFlow
            i = prev[i]
        }
        r += minFlow
    }
    
    if r == m{
        res += "Possible\n"
    }
    else{
        res += "Impossible\n"
    }
}

@main
struct Main{
    static func main(){
        guard let fin = FileReader("mice.inp") else{
            return
        }
        let fout = FileWriter("mice.out")
        
        for _ in 0..<Int(fin.readLine())!{
            let nkhm = fin.readLine().split(separator: " ").map{Int($0)!}
            n = nkhm[0]; k = nkhm[1]; h = nkhm[2]; m = nkhm[3]
            dots = Array(repeating: Point(0,0), count: n+1)
            holes = Array(repeating: Point(0,0), count: h)
            mice = Array(repeating: Point(0,0), count: m)
            c = Array(repeating: Array(repeating: 0, count: m+h+2), count: m+h+2)
            f = c
            adj.removeAll()
            
            for j in 0..<n{
                dots[j] = Point(fin.readLine().split(separator: " ").map({Int64($0)!}))
            }
            dots[n] = dots[0]
        
            for j in 0..<h{
                holes[j] = Point(fin.readLine().split(separator: " ").map({Int64($0)!}))
            }
            
            for j in 0..<m{
                mice[j] = Point(fin.readLine().split(separator: " ").map({Int64($0)!}))
            }
            adj = Array(repeating: [Int](), count: m+h+2)
            
            for j in 0..<m{
                adj[m+h].append(j)
                adj[j].append(m+h)
                c[m+h][j] = 1
            }
            

            for j in 0..<h{
                adj[j+m].append(m+h+1)
                adj[m+h+1].append(j+m)
                c[j+m][m+h+1] = k
            }

            addEdges()
            maxFlow()
        }
        fout.write(res)
    }
}
