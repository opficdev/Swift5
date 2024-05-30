//BubbleSort

func BubbleSort(_ A: [Int]) -> [Int]{
    var arr = A
    for i in 1..<arr.count - 1{
        for j in 0..<arr.count - i{
            if (arr[j] > arr[j+1]){
                arr.swapAt(j, j+1)
            }
        }
    }
    return arr
}

print(BubbleSort([40,10,50,90,20,80,30,60]))
