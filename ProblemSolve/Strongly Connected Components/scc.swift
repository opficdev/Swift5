//
//  scc.swift
//  Swift5
//
//  Created by 최윤진 on 2024-08-10.
//

import Foundation

class Graph{
    //internal
    func dfs(_ curr:Int, _ des:Int, _ adj: inout [[Int]], _ vis: inout [Int]) -> Bool{
        if curr == des{
            return true
        }
        vis[curr] = 1
        for x in adj[curr]{
            if (vis[x] == 0){
                if (dfs(x, des, &adj, &vis)){
                    return true
                }
            }
        }
        
        return false;
    }
    
    func isPath(_ src: Int, _ des: Int, _ adj: inout [[Int]]) -> Bool{
        var vis:[Int] = Array(repeating: 0, count: adj.count)
        return dfs(src, des, &adj, &vis)
    }
    
    func findSCC(_ n:Int, _ a: inout [[Int]]) -> String{
        var ans = 0
        var is_scc: [Int] = Array(repeating: 0, count: n)
        var adj: [[Int]] = Array(repeating: Array(), count: n)
        
        for i in 0..<a.count{
            adj[a[i][0]].append(a[i][1])
        }
        
        for i in 0..<n{
            if is_scc[i] == 0{
                var scc:[Int] = []
                for j in i..<n{
                    if is_scc[j] == 0 && isPath(i, j, &adj) && isPath(j, i, &adj){
                        is_scc[j] = 1
                        scc.append(j)
                    }
                }
                ans += 1
            }
        }
        return "\(ans)"
    }
}


@main
struct Main{
    static func main(){
        let fin = FileReader("scc.inp")!
        let fout = FileWriter("scc.out")
    
        let g = Graph()
        let nm = fin.readLine().split(separator: " ").map{Int($0)!}; var n = nm[0], m = nm[1]
        var edges:[[Int]] = []
        for _ in 0..<m{
            let ij = fin.readLine().split(separator: " ").map{Int($0)!}
            edges.append(ij)
        }
        let res = g.findSCC(n, &edges)
        fout.write(res + "\n")
    }
}
