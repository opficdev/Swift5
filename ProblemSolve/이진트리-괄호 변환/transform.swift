import Foundation

func findFirstBracket(_ str: String, _ left: Int, _ right: Int) -> Int{
    var res = 1
    
    for i in left + 1...right{
        if str[str.index(str.startIndex, offsetBy: i)] == "("{
            res += 1
        }
        else{
            res -= 1
        }
        if res == 0 {return i}
    }
    
    return res;
}

func bracketToOrder(_ str: String, _ no: inout Int, _ left: Int, _ right: Int) -> [Int]{
    if left > right{
        return []
    }
    
    no += 1
    let cur = no
    let f_idx = findFirstBracket(str, left, right)
    var left_inorder = bracketToOrder(str, &no, left + 1, f_idx - 1)
    let right_inorder = bracketToOrder(str, &no, f_idx + 1, right)
    
    return left_inorder + [cur] + right_inorder
}

func orderToBracket(_ arr: [Int], _ no: inout Int, _ left: Int, _ right: Int) -> String{
    if left > right{
        return ""
    }
    no += 1
    let f_idx = Array(arr[left...right]).firstIndex(of: no)! + left
    
    let left_string = "(" + orderToBracket(arr, &no, left, f_idx - 1) + ")"
    let right_string = orderToBracket(arr, &no, f_idx + 1, right)
    
    return left_string + right_string
 }

@main
struct Main{
    static func main(){
        let fin = FileReader("transform.inp")!
        let fout = FileWriter("transform.out")
        
        var res = ""
        let T = Int(fin.readLine()!)!
        for _ in 0..<T{
            let nk = fin.readLine()!.split(separator: " ").map{Int($0)!}
            let n = nk[0], k = nk[1]
            res += "\(n) "
            if (k == 1){
                let str = fin.readLine()!;
                var no = 0
                let tmp = bracketToOrder(str, &no, 0, 2 * n - 1)
                for i in 0..<tmp.count{
                    res += "\(tmp[i])"
                    if i < tmp.count - 1{
                        res += " "
                    }
                }
                res += "\n"
            }
            else{
                let arr = fin.readLine()!.split(separator: " ").map{Int($0)!}
                var no = 0
                res += orderToBracket(arr, &no, 0, n - 1) + "\n"
            }
        }
        fout.write(res)
    }
}
