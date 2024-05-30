//SelectionSort

func SelectionSort(_ a:[Int]) -> [Int]{
    var arr = a
    for i in 0..<arr.count - 1{
        var min = i
        for j in i+1..<arr.count{
            if (arr[j] < arr[min]){
                min = j
            }
        }
        arr.swapAt(i, min)
    }
    return arr
}

print(SelectionSort([40,10,50,90,20,80,30,60]))
