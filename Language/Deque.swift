import Foundation

///An ordered, non-random-access collection.
struct Deque<Element> {
    private var array: [Element?]
    private var head = 0
    ///The total number of elements that the array can contain without allocating new storage.
    private(set) var capacity = 10
    ///The number of elements in the deque.
    private(set) var count = 0

    ///Creates a new, empty deque.
    init() {
        array = [Element?](repeating: nil, count: capacity)
    }
    
    ///Creates a deque, containing the elements of a sequence.
    init<S: Sequence>(_ s: S) where S.Element == Element{
        array = Array(s)
        count = array.count
        capacity = count
    }
    
    private mutating func resize() {
        let newCapacity = capacity * 2
        var newArray = [Element?](repeating: nil, count: newCapacity)
        for i in 0..<count {
            newArray[i] = array[(head + i) % capacity]
        }
        array = newArray
        head = 0
        capacity = newCapacity
    }
    
    ///Remove all elements of from the deque.
    mutating func removeAll(_ keepingCapacity: Bool = true) {
        capacity = keepingCapacity ? capacity : 10
        array = [Element?](repeating: nil, count: capacity)
        head = 0
        count = 0
    }

    ///Add a new element at the end of the deque.
    mutating func append(_ newElement: Element) {
        if count == capacity {
            resize()
        }
        array[(head + count) % capacity] = newElement
        count += 1
    }

    ///Add a new element at the begin of the deque.
    mutating func prepend(_ newElement: Element) {
        if count == capacity {
            resize()
        }
        head = (head - 1 + capacity) % capacity
        array[head] = newElement
        count += 1
    }
    
    ///Removes and returns the first element of deque.
    @discardableResult
    mutating func removeFirst() -> Element{
        guard let element = popFirst() else{
            fatalError(": Can'Element remove first element from an empty collection")
        }
        return element
    }
    
    ///Removes and returns the last element of deque.
    @discardableResult
    mutating func removeLast() -> Element{
        guard let element = popLast() else{
            fatalError(": Can'Element remove last element from an empty collection")
        }
        return element
    }
    
    ///Removes and returns the first element of deque.
    @discardableResult
    mutating func popFirst() -> Element? {
        guard !isEmpty else { return nil }
        let element = array[head]
        array[head] = nil
        head = (head + 1) % capacity
        count -= 1
        return element
    }
    
    ///Removes and returns the last element of deque.
    @discardableResult
    mutating func popLast() -> Element? {
        guard !isEmpty else { return nil }
        count -= 1
        let index = (head + count) % capacity
        let element = array[index]
        array[index] = nil
        return element
    }
    
    ///The first element of the collection.
    var first: Element? {
        guard !isEmpty else { return nil }
        return array[head]
    }

    ///The last element of the collection.
    var last: Element? {
        guard !isEmpty else { return nil }
        return array[(head + count - 1) % capacity]
    }
    
    ///A Boolean value indicating whether the collection is empty.
    var isEmpty: Bool {
        return count == 0
    }
}
