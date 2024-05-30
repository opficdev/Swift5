var S = Array("strong") //바뀔 대상
let T = Array("stone") //비교할 대상

let m = S.count, n = T.count

var E = Array(repeating: Array(repeating: 0, count: n + 1), count: m + 1)

E[0] = Array(0...n)
for i in 0...m{
    E[i][0] = i
}

for i in 1...m{
    for j in 1...n{
        var a:Int
        S[i - 1] == T[j - 1] ? (a = 0) : (a = 1)
        E[i][j] = min(E[i][j-1] + 1, E[i-1][j]+1, E[i-1][j-1]+a)
    }
}

for i in E{
    print(i)
}
