import Foundation

let inp = read("grid.inp")

class Grid{
    var R: Int, C: Int, A: Int, B: Int, K: Int
    var board:[[Int]], cnt:[[[Int64]]]
    
    
    init(_ input: [[Int]]){
        R = input[0][0]; C = input[0][1]; A = input[0][2]; B = input[0][3]; K = input[0][4]
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
            let r = input[1][2*i] + 1, c = input[1][2*i+1] + 1
            board[r][c] = 1
        }
        //0 : 지나갈 수 없는 곳
        for i in 0..<B{
            let r = input[2][2*i] + 1, c = input[2][2*i+1] + 1
            board[r][c] = 0
        }
        
        cnt[1][1][0] = 1
    }
    
    func getRes() -> String{
        return String(cnt[R][C][K])
    }
}

func read(_ title: String) -> [[String]]{
    let fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(title)
    var lines: [[String]] = []
    do {
        let fileHandle = try FileHandle(forReadingFrom: fileURL)
        
        var fileContent = ""

        let data = fileHandle.readDataToEndOfFile()
        if let content = String(data: data, encoding: .utf8) {
            fileContent = content
        }
        fileHandle.closeFile()
        
        let filter = fileContent.contains("\r\n") ? "\r\n" : "\n"
        
        lines = fileContent.split(separator: filter).map{$0.split(separator: " ").map{String($0)}}
        

    } catch {
        print(error)
    }
    return lines
}

func write(_ title: String, _ data: String){
    let currentFileURL = URL(fileURLWithPath: #file)
    let directoryURL = currentFileURL.deletingLastPathComponent()
    let fileURL = directoryURL.appendingPathComponent(title)

    do {
        try data.write(to: fileURL, atomically: true, encoding: .utf8)
    } catch {
        print(error)
    }
}

let MOD:Int64 = 1000000007

@main
struct Main{
    static func main(){
        let TC = Int(inp[0][0])!
        var res = ""
        for t in 0..<TC{
            let data = Array(inp[3*t+1...3*t+3].map{$0.map{Int($0)!}})
            let g = Grid(data)
            
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
        write("grid.out", res)
    }
}
