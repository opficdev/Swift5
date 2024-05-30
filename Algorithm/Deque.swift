struct Deque<T>{
    private var leftarr:[T] = [] //left 연산 담당하는 배열
    private var rightarr:[T] = [] //right 연산 담당하는 배열
    private var leftindex = 0
    private var rightindex = 0
    
    init(){}
    
    init(_ item: [T]){
        rightarr = item
    }
    
    var isEmpty: Bool{
        return leftarr.isEmpty && rightarr.isEmpty
    }
    
    mutating func append(_ t:T){
        rightarr.append(t)
    }
    
    mutating func appendleft(_ t:T){
        leftarr.append(t)
    }
    
    mutating func pop() -> T?{
        if isEmpty{
            return nil
        }
        else if rightarr.isEmpty {
            let item = leftarr[leftindex]
            leftindex += 1
            if leftindex == leftarr.count{
                leftarr = []
                leftindex = 0
            }
            return item
        }
        return rightarr.popLast()!
    }
    
    mutating func popleft() -> T?{
        if isEmpty{
            return nil
        }
        else if leftarr.isEmpty {
            let item = rightarr[rightindex]
            rightindex += 1
            if rightindex == rightarr.count{
                rightarr = []
                rightindex = 0
            }
            return item
        }
        return leftarr.popLast()!
    }
}
