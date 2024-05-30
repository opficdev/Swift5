import Foundation

struct Edge{
    var v:Int, flow: Int64, C: Int, rev: Int
    init(_ v:Int = 0, _ flow:Int64 = 0, _ C:Int = 0, _ rev:Int = 0){
        self.v = v
        self.flow = flow
        self.C = C
        self.rev = rev
    }
}

class Node<T>{
    var prev: Node?, next: Node?
    var data: T?
    init(_ t: T){
        self.data = t
        self.prev = nil
        self.next = nil
    }
}

class List<T>{
    private var head: Node<T>?, tail: Node<T>?
    init(){self.head = nil; self.tail = nil}
    func isEmpty() -> Bool{
        return head == nil && tail == nil
    }
    func append(_ t: T){
        let n = Node(t)
        if isEmpty(){
            head = n
            tail = n
        }
        else{
            tail!.next = n
            n.prev = tail
            tail = n
        }
    }
    func popleft() ->T?{
        let tmp = head
        head = head?.next
        head?.prev = nil
        if head == nil {tail = nil}
        return tmp?.data
    }
}

class Graph{
    var V:Int, level:[Int], adj:[[Edge]]
    init(_ V:Int){
        self.V = V
        self.level = Array(repeating: 0, count: V)
        self.adj = Array(repeating:Array(), count: V)
    }
    
    func addEdge(_ u: Int, _ v: Int, _ C: Int){
//        print("\(u) \(v)")
        let a = Edge(v, 0, C, adj[v].count)
        let b = Edge(u, 0, 0, adj[u].count)
        
        adj[u].append(a)
        adj[v].append(b)
    }
    
    func BFS(_ s: Int, _ t: Int) -> Bool{
        for i in 0..<V{
            level[i] = -1
        }
        level[s] = 0
        
        let q:List<Int> = List()
        q.append(s)
        
        while(!q.isEmpty()){
            let u = q.popleft()!
            for i in adj[u]{
                if level[i.v] < 0 && i.flow < i.C{
                    level[i.v] = level[u] + 1
                    q.append(i.v)
                }
            }
        }
        
        return level[t] < 0 ? false : true
    }
    
    func sendFlow(_ u: Int, _ flow: Int64, _ t: Int, _ start: inout [Int]) -> Int64{
        if u == t{
            return flow
        }
        while start[u] < adj[u].count{
            let e = adj[u][start[u]]
            if level[e.v] == level[u] + 1 && e.flow < e.C{
                let curr_flow = min(flow, Int64(e.C) - e.flow)
                let temp_flow = sendFlow(e.v, curr_flow, t, &start)
                if temp_flow > 0{
                    adj[u][start[u]].flow += temp_flow
                    adj[e.v][e.rev].flow -= temp_flow
                    return temp_flow
                }
            }
            start[u] += 1
        }
        return 0
    }
    
    func DinicMaxFlow(_ s: Int, _ t: Int) -> Int64{
        if s == t{
            return -1
        }
        var total:Int64 = 0
        
        while (BFS(s, t)){
            var start = Array(repeating: 0, count: V + 1)
            while (true){
                let flow = sendFlow(s, INT64_MAX, t, &start)
                if flow == 0 {break}
                total += flow
            }
        }
        return total
    }
}
func sum(_ v: [Int], _ index: Int) -> Int{
    var s = 0
    for i in 0..<index{
        s += v[i]
    }
    return s
}

var T = Int(readLine()!)!
for _ in 0..<T{
    let npm = readLine()!.split(separator: " ").map{Int($0)!}
    let n = npm[0], p = npm[1], m = npm[2]
    let L = readLine()!.split(separator: " ").map{Int($0)!}
    let l = sum(L, p)

    let g = Graph(2 + n + n * p + l)
    
    for i in 0..<n{
        g.addEdge(0, 2 + i, m)
    }
    for i in 0..<n{
        for j in 0..<p{
            g.addEdge(2 + i, 2 + n + p * i + j, 1)
        }
    }
    var start = 2 + n, dest = 2 + n + n * p
    for _ in 0..<n{
        let tlist = readLine()!.split(separator: " ").map{Int($0)!}
        let t = tlist[0]
        for i in 0..<t{
            let j = tlist[i * 2 + 1], k = tlist[2 * (i + 1)]
            g.addEdge(start + j - 1, dest + sum(L, j - 1) + k - 1, 1)
        }
        start += p
    }
    for i in 0..<l{
        g.addEdge(2 + n + n * p + i, 1, 1)
    }
    let MaxFlow = g.DinicMaxFlow(0, 1)
    if l == MaxFlow{
        print(1)
    }
    else{
        print(0)
    }
    
}
