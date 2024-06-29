import Foundation

func getSum(_ v: [Int64], _ i: Int) -> Int64{
    var sum: Int64 = 0
    var i = i
    while i > 0{
        sum += v[i]
        i -= (i & -i)
    }
    return sum
}

func update(_ v: inout [Int64], _ i: Int, _ diff: Int64){
    var i = i
    while i < v.count{
        v[i] += diff
        i += (i & -i)
    }
}

@main
struct Main{
    static func main(){
        let fin = FileReader("rangeSum.inp")!
        let fout = FileWriter("rangeSum.out")
        
        let N: Int = Int(fin.readLine()!)! + 1
        var bitree: [Int64] = Array(repeating: 0, count: N)
        var vec: [Int64] = Array(repeating: 0, count: N)
        
        
        for (idx, value) in zip(1..., fin.readLine()!.split(separator: " ").map({Int64($0)!})){ //이거 길이 Int 범위 but 값은 Int64
            vec[idx] = value
            update(&bitree, idx, vec[idx])
        }
        
        var res = ""
        while true{
            let inp = fin.readLine()!.split(separator: " ")
            let cmd = String(inp[0])
            let n1 = Int(inp[1])!
            let n2 = Int64(inp[2])!
            
            if cmd == "c"{
                update(&bitree, n1, n2 - vec[n1])
                vec[n1] = n2
            }
            else if cmd == "s"{
                res += String(getSum(bitree, Int(n2)) - getSum(bitree, n1 - 1)) + "\n"
            }
            else{
                break
            }
        }
        fout.write(res)
    }
}
