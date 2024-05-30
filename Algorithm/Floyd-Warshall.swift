func AllPairsShortest(inp:[[Int]]) -> [[Int]]{
    let n = max(inp.max(by:{$0[0] < $1[0]})![0], inp.max(by: {$0[1] < $1[1]})![1])//점 갯수
    var D = Array(repeating: Array(repeating: Int.max, count: n), count: n)
    for i in inp{
        D[i[0]-1][i[1]-1] = i[2]
    }
    for i in 0..<n{
        D[i][i] = 0
    }
    for k in 0..<n{
        for i in 0..<n{
            if i == k {continue}
            for j in 0..<n{
                if j == i{continue}
                if D[i][k] != Int.max && D[k][j] != Int.max{
                    D[i][j] = min(D[i][k] + D[k][j], D[i][j])
                }
            }
        }
    }
    return D
}

let inp = [[1,2,4],[1,3,2],[1,4,5],[2,3,1],[2,5,4],[3,1,1],[3,2,3],[3,4,1],[3,5,2],[4,1,-2],[4,5,2],[5,2,-3],[5,3,3],[5,4,1]]

let result = AllPairsShortest(inp: inp)
for i in result{
    print(i)
}
