//
//  queue.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-02.
//

import Foundation

struct Queue<T>{
    private class node<t>{
        var data: t? = nil, front: node? = nil, back: node? = nil //front: head쪽으로 가는 다음 노드 / back: tail쪽으로 가는 다음 노드
        init(){}
        init(_ data: t){
            self.data = data
        }
    }
    //output node
    private var head: node<T>? = nil
    //input node
    private var tail: node<T>? = nil
    
    var count = 0
    
    ///Only declaration.
    init(){}
    ///Declaration with input datas.
    init(_ datas: [T]){
        for data in datas{
            append(data)
        }
    }
    
    var isEmpty: Bool {
        return self.head == nil && self.tail == nil
    }
    
    ///Get head
    var first: T?{
        return self.head?.data
    }
    ///Get tail
    var last: T?{
        return self.tail?.data
    }
        
    ///Input data into queue.
    mutating func append(_ data: T){
        self.count += 1
        let newNode = node(data)
        if self.isEmpty{
            self.head = newNode
            self.tail = self.head
        }
        else{
            newNode.front = self.tail
            self.tail!.back = newNode
            self.tail = newNode
        }
    }
    
    ///Get data from queue.
    mutating func remove(){
        if !self.isEmpty{
            self.head = self.head!.back
            self.head?.front = nil
            if self.head == nil{
                self.tail = nil
            }
            self.count -= 1
        }
    }
    
    ///Get data from queue and remove last node.
    mutating func pop() -> T?{
        let data = first
        remove()
        return data
    }
}
