//DPCoinChange

func DPCoinChange(_ n:Int, _ d:[Int]) -> [Int]{
    var C = [Int](repeating: Int.max - 1, count: n+1)
    let d = d.sorted(by: >)
    C[0] = 0
    for i in 1...n{
        for j in d{
            if (i >= j && C[i-j] + 1 < C[i]){
                C[i] = C[i-j] + 1
            }
        }
    }
    return C
}

print(DPCoinChange(20,[16,10,5,1]))
