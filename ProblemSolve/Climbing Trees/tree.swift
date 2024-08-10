//
//  tree.swift
//  Swift5
//
//  Created by 최윤진 on 2024-08-10.
//

import Foundation

let MAX_N = 3000

var str_map = [String:Int]()
var str_num = [String]()
var adj_table = Array(repeating: [Int](), count: MAX_N)
var visited = Array(repeating: 0, count: MAX_N)

class LCA{
    var n: Int
    var visited = Array(repeating: false, count: MAX_N)
    var level = Array(repeating: 0, count: MAX_N)
    var table = Array(repeating: Array(repeating: -1, count: MAX_N), count: MAX_N)
    
    init(_ n: Int){
        self.n = n
        makeTable()
        set_level()
    }
    
    private func dfs(_ u: Int){
        visited[u] = true
        for i in adj_table[u]{
            table[i][0] = u
            if !visited[i]{
                dfs(i)
            }
        }
    }
    
    private func makeTable(){
        visited = Array(repeating: false, count: MAX_N)
        
        for i in 0..<n{
            if (!visited[i]){
                dfs(i)
            }
        }
        for j in 1..<n{
            if Double(n) <= pow(2.0, Double(j)){
                break
            }
            for i in 0..<n{
                if table[i][j-1] != -1{
                    table[i][j] = table[table[i][j-1]][j-1]
                }
            }
        }
    }
    
    private func update_level(_ u: Int){
        visited[u] = true
        for v in adj_table[u]{
            level[v] = level[u] + 1
            update_level(v)
        }
    }
    
    private func set_level(){
        visited = Array(repeating: false, count: MAX_N)
        for i in 0..<n{
            if table[i][0] == -1{
                level[i] = 0
                update_level(i)
            }
        }
    }
    
    func get_lca(_ a: Int, _ b: Int) -> Int{
        var a = a, b = b
        if level[a] < level[b]{
            swap(&a, &b)
        }
        
        for i in stride(from: Int(log2((Double(n)))), through: 0, by: -1){
            if level[a] - Int(pow(2.0, Double(i))) >= level[b]{
                a = table[a][i]
            }
        }
        
        for i in stride(from: Int(log2((Double(n)))), through: 0, by: -1){
            if table[a][i] != -1 && table[a][i] != table[b][i]{
                a = table[a][i]
                b = table[b][i]
            }
        }
        if a == b{
            return a
        }
        
        return table[a][0]
    }
    
    func get_level(_ a: Int) -> Int{
        return level[a]
    }
}

func dfs(_ u: Int,_ mark: Int){
    visited[u] = mark
    for i in adj_table[u]{
        dfs(i, mark)
    }
}

@main
struct Main{
    static var n = 0
    static func add(_ name: String){
        if !str_map.keys.contains(name){
            str_map[name] = n
            n += 1
            str_num.append(name)
        }
    }
    
    static func main(){
        let fin = FileReader("tree.inp")!
        let fout = FileWriter("tree.out")
        
        var res = ""
        
        var str = [String]()
        
        while true{
            str = fin.readLine().split(separator: " ").map{String($0)}
            if str[0] == "no.child"{
                break
            }
            add(str[0])
            add(str[1])
            adj_table[str_map[str[1]]!].append(str_map[str[0]]!)
        }
                
        let total = str_num.count
        adj_table = Array(adj_table[..<total])
        let lca = LCA(total)
        
        var mark = 0
        for i in 0..<total{
            if visited[i] == 0{
                mark += 1
                dfs(i, mark)
            }
        }
        
        while !fin.isEOF{
            str = fin.readLine().split(separator: " ").map{String($0)}
            if !str_map.keys.contains(str[0]) || !str_map.keys.contains(str[1]){
                res += "no relation\n"
                continue
            }
            
            let a = str_map[str[0]]!, b = str_map[str[1]]!
            
            if visited[a] == visited[b]{
                let ancestor = lca.get_lca(a, b)
                
                let level_a = lca.get_level(a)
                let level_b = lca.get_level(b)
                
                if ancestor == a || ancestor == b{
                    var level_gap = abs(level_a - level_b)
                    
                    while level_gap > 2{
                        res += "great "
                        level_gap -= 1
                    }
                    
                    if level_gap > 1{
                        res += "grand "
                    }
                    
                    if level_a > level_b{
                        res += "child\n"
                    }
                    else{
                        res += "parent\n"
                    }
                }
                else{
                    let csn = min(level_a, level_b) - lca.get_level(ancestor) - 1
                    let rmv = abs(level_a - level_b)
                    
                    if csn == 0 && rmv == 0{
                        res += "sibling"
                    }
                    else{
                        res += "\(csn) cousin"
                        if rmv != 0{
                            res += " removed \(rmv)"
                        }
                    }
                    
                    res += "\n"
                }
            }
            else{
                res += "no relation\n"
            }
        }
        
        fout.write(res)
    }
}
