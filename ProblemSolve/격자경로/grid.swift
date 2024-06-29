import Foundation

let fin = fstream("grid.inp")!

class Grid{
    var R: Int, C: Int, A: Int, B: Int, K: Int
    var board:[[Int]], cnt:[[[Int64]]]
    
    
    init(_ RCABK: [Int],_ O: [Int],_ X: [Int]){
        R = RCABK[0]; C = RCABK[1]; A = RCABK[2]; B = RCABK[3]; K = RCABK[4]
        R+=1;C+=1
        
        board = Array(repeating: Array(repeating: -1, count: C + 1), count: R + 1)
        for i in 0...C{
            board[0][i] = 0
        }
        for i in 0...R{
            board[i][0] = 0
        }
        
        cnt = Array(repeating: Array(repeating: Array(repeating: 0, count: K+1), count: C + 1), count: R + 1)
        
        //1 : 원 표시된 곳
        for i in 0..<A{
            let r = O[2*i] + 1, c = O[2*i+1] + 1
            board[r][c] = 1
        }
        //0 : 지나갈 수 없는 곳
        for i in 0..<B{
            let r = X[2*i] + 1, c = X[2*i+1] + 1
            board[r][c] = 0
        }
        
        cnt[1][1][0] = 1
    }
    
    func getRes() -> String{
        return String(cnt[R][C][K])
    }
}

let MOD:Int64 = 1000000007

@main
struct Main{
    static func main(){
        let fout = fstream("grid.out")!
        
        let TC = Int(fin.readLine()!)!
        var res = ""
        for _ in 0..<TC{
            let RCABK = fin.readLine()!.split(separator: " ").map{Int($0)!}
            let O = fin.readLine()!.split(separator: " ").map{Int($0)!}
            let X = fin.readLine()!.split(separator: " ").map{Int($0)!}
            let g = Grid(RCABK, O, X)
            
            for i in 1...g.R{
                for j in 1...g.C{
                    if g.board[i][j] == 0{
                        continue
                    }
                    
                    if g.board[i][j] == 1{
                        g.cnt[i][j][g.K] += g.cnt[i-1][j][g.K] + g.cnt[i][j-1][g.K]
                        g.cnt[i][j][g.K] %= MOD

                        for k in 0..<g.K{
                            g.cnt[i][j][k+1] += g.cnt[i-1][j][k] + g.cnt[i][j-1][k]
                            g.cnt[i][j][k+1] %= MOD
                        }
                    }
                    else{
                        for k in 0...g.K{
                            g.cnt[i][j][k] += g.cnt[i-1][j][k] + g.cnt[i][j-1][k]
                            g.cnt[i][j][k] %= MOD
                        }
                    }
                }
            }
            res += g.getRes() + "\n"
        }
        fout.write(res)
    }
}
