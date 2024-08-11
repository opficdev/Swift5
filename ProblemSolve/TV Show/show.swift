import Foundation

//Global Variables
var k = 0, N = 0, num = 0, scc = 0
var low: [Int] = [], dfn: [Int] = [], inDegree: [Int] = []
var vec: [[Int]] = []
var visited: [Bool] = []
var s: [Int] = [] //Stack

func getX(_ x: Int) -> Int{
    return x > k ? x - k : x + k
}

func dfs(_ x: Int){
    num += 1
    low[x] = num; dfn[x] = num
    s.append(x)
    
    for v in vec[x]{
        if dfn[v] == 0{
            dfs(v)
            low[x] = min(low[x], low[v])
        }
        else if !visited[v]{
            low[x] = min(low[x], dfn[v])
        }
    }
    
    if low[x] == dfn[x]{
        scc += 1
        while (true){
            let p = s.popLast()!
            visited[p] = true
            inDegree[p] = scc
            if x == p{
                break;
            }
        }
    }
}

func Init(){
    low = Array(repeating: 0, count: 10001)
    dfn = Array(repeating: 0, count: 10001)
    inDegree = Array(repeating: 0, count: 10001)
    visited = Array(repeating: false, count: 10001)
    vec = Array(repeating: [Int](), count: 10001)
    s.removeAll()
    num = 0; scc = 0
}



//Xcode 특성 상 main.swift를 main으로 설정
//해당 사항 방지하기 위해 @main을 쓰고 구조체를 만든 후 정적함수로 main 함수 작성
//구조체, 함수명은 굳이 main이 아니어도 됨
@main
struct Main{
    static func main(){
        let fin = FileReader("show.inp")!
        let fout = FileWriter("show.out")
        
        let T = Int(fin.readLine()!)!
        var res = ""
        for _ in 0..<T{
            let kN = fin.readLine()!.split(separator: " ").map{Int($0)!}
            k = kN[0]; N = kN[1]
            Init()
            var flag = false
            for _ in 0..<N{
                let NC = fin.readLine()!.split(separator: " ").map{String($0)}
                var n0 = Int(NC[0])!, n1 = Int(NC[2])!, n2 = Int(NC[4])!;
                let c0 = NC[1], c1 = NC[3], c2 = NC[5];
                
                n0 = (c0 == "R" ? n0 : getX(n0))
                n1 = (c1 == "R" ? n1 : getX(n1))
                n2 = (c2 == "R" ? n2 : getX(n2))
                
                vec[getX(n0)].append(n1);
                vec[getX(n1)].append(n0);
                
                vec[getX(n1)].append(n2);
                vec[getX(n2)].append(n1);
                
                vec[getX(n2)].append(n0);
                vec[getX(n0)].append(n2);
            }
            
            for i in 1...2 * k{
                if dfn[i] == 0 {dfs(i)}
            }
            for i in 1...k{
                if inDegree[i] == inDegree[getX(i)]{
                    flag = true;
                    break;
                }
            }
            
            if flag {
                res += "-1\n"
            }
            else {
                res += "1\n"
            }
        }
        fout.write(res)
    }
}
