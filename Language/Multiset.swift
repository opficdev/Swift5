//
//  Multiset.swift
//  Swift5
//
//  Created by 최윤진 on 2024-07-04.
//  C++

import Foundation



struct Multiset<T1: Hashable & Comparable>{
    private var Tree:RBTree<T1> = RBTree()
    private var ele_count = Dictionary<T1, Int>()
    private struct RBTree<T2: Comparable>{
        private enum Color{
            case RED
            case BLACK
        }

        private class node<T3>{
            var key: T3? = nil
            var left: node? = nil
            var right: node? = nil
            var parent: node? = nil //루트 노드 때문에 nil 포함
            var color = Color.BLACK
            init(){}
        }
        
        private var root:node<T2>? = nil
        private var leafNode: node<T2>? = nil
        init(){
            leafNode = node<T2>()
            root = leafNode
        }
        
        mutating private func InsertFixUp(_ z: inout node<T2>){
            while z !== root && z.parent!.color == Color.RED{ //부모노드의 색이 RED 이므로 무조건 조부 노드가 존재한다
                var grandparent = z.parent!.parent!
                let uncle = z.parent === grandparent.left ? grandparent.right : grandparent.left
                let side: Bool = z.parent === grandparent.left ? true : false
                
                if uncle !== nil && uncle!.color == Color.RED{
                    z.parent?.color = Color.BLACK
                    uncle!.color = Color.BLACK
                    grandparent.color = Color.RED
                    z = grandparent
                }
                else{
                    if z === (side ? z.parent?.right : z.parent?.left){
                        z = z.parent!
                        side ? RotateLeft(&z) : RotateRight(&z)
                    }
                    z.parent?.color = Color.BLACK
                    grandparent.color = Color.RED
                    side ? RotateRight(&grandparent) : RotateLeft(&grandparent)
                }
            }
            root?.color = Color.BLACK
        }
        
        private func tree_minimum(_ x: node<T2>) -> node<T2>{ //가장 좌측으로 내려가기
            var x = x
            while x.left != nil && x.left !== leafNode{
                x = x.left!
            }
            return x
        }
        
        mutating private func DeleteFixUp(_ x: inout node<T2>){
            var s: node<T2>
            while (x !== root && x.color == Color.BLACK){ //x가 루트 노드가 아니고 색이 Black인 노드면 x 위에는 무조건 부모노드 있음
                if x === x.parent!.left{
                    s = x.parent!.right!
                    if s.color == Color.RED{
                        s.color = Color.BLACK
                        x.parent?.color = Color.RED
                        RotateLeft(&x.parent!)
                        s = x.parent!.right!
                    }
                    if s.left?.color == Color.BLACK && s.right?.color == Color.BLACK{
                        s.color = Color.RED
                        x = x.parent!
                    }
                    else{
                        if s.right?.color == Color.BLACK{
                            s.left?.color = Color.BLACK
                            s.color = Color.RED
                            RotateRight(&s)
                            s = x.parent!.right!
                        }
                        s.color = x.parent!.color
                        x.parent!.color = Color.BLACK
                        s.right!.color = Color.BLACK
                        RotateLeft(&x.parent!)
                        x = root!
                    }
                }
                else{
                    s = x.parent!.left!
                    if s.color == Color.RED{
                        s.color = Color.BLACK
                        x.parent!.color = Color.RED
                        RotateRight(&x.parent!)
                        s = x.parent!.left!
                    }
                    if s.left!.color == Color.BLACK && s.right!.color == Color.BLACK{
                        s.color = Color.RED
                        x = x.parent!
                    }
                    else{
                        if s.left!.color == Color.BLACK{
                            s.right!.color = Color.BLACK
                            s.color = Color.RED
                            RotateLeft(&s)
                            s = x.parent!.left!
                        }
                        s.color = x.parent!.color
                        x.parent!.color = Color.BLACK
                        s.left!.color = Color.BLACK
                        RotateRight(&x.parent!)
                        x = root!
                    }
                }
            }
            x.color = Color.BLACK
            root!.color = Color.BLACK
        }
        
        mutating private func Transplant(_ u: inout node<T2>, _ v: inout node<T2>){
            if u.parent == nil{
                root = v
            }
            else if u === u.parent?.left{
                u.parent?.left = v
            }
            else{
                u.parent?.right = v
            }
            v.parent = u.parent
        }
        
        mutating private func RotateLeft(_ x: inout node<T2>){
            let y = x.right
            x.right = y?.left
            if y?.left !== leafNode{
                y?.left?.parent = x
            }
            y?.parent = x.parent
            if (x.parent == nil){
                root = y
            }
            else if x === x.parent?.left{
                x.parent?.left = y
            }
            else{
                x.parent?.right = y
            }
            x.parent = y
            x.parent?.left = x
        }
        
        mutating private func RotateRight(_ y: inout node<T2>){
            let x = y.left
            y.left = x?.right
            if x?.right !== leafNode{
                x?.right?.parent = y
            }
            x?.parent = y.parent
            if y.parent == nil{
                root = x
            }
            else if y === y.parent?.left{
                y.parent!.left = x
            }
            else{
                y.parent!.right = x
            }
            y.parent = x
            x?.right = y
        }
        
        mutating func Insert(_ item: T2){
            var x = root, y: node<T2>? = nil
            var z = node<T2>()
            
            z.key = item
            z.color = Color.RED
            z.left = leafNode
            z.right = leafNode
            
            while x !== leafNode{
                y = x
                if x!.key! < item{
                    x = x!.right
                }
                else{
                    x = x!.left
                }
            }

            z.parent = y
            if y == nil{
                root = z
            }
            else if z.key! > y!.key!{
                y!.right = z
            }
            else{
                y!.left = z
            }
            
            if z.parent == nil{
                z.color = Color.BLACK
                return
            }
            if z.parent!.parent == nil{
                return
            }
            InsertFixUp(&z)
        }
        
        private func Search(_ item: T2) -> node<T2>?{
            var t = root
            while t != nil && t!.key != item{
                t = item < t!.key! ? t!.left : t!.right
            }
            return t
        }
        
        private func inOrderTraverse(_ node: node<T2>?, _ arr: inout [T2]){
            if node === self.leafNode{ //현재 노드가 리프노드(더미값)일 떄
                return
            }
            if node!.left != nil{
                inOrderTraverse(node!.left, &arr)
            }
            arr.append(node!.key!)
            if node!.right != nil{
                inOrderTraverse(node!.right, &arr)
            }
        }
        
        mutating func Delete(_ item: T2){
            var z:node? = Search(item)
            var x = node<T2>(), y: node<T2>
            var OriginalColor = z!.color
            if z!.left === leafNode{
                x = z!.right!
                Transplant(&z!, &z!.right!)
            }
            else if z!.right === leafNode{
                x = z!.left!
                Transplant(&z!, &z!.left!)
            }
            else{
                if z!.right != nil{
                    y = tree_minimum(z!.right!)
                    OriginalColor = y.color
                    x = y.right!
                    if y.parent === z{
                        x.parent = y
                    }
                    else{
                        Transplant(&y, &y.right!)
                        y.right = z!.right
                        y.right?.parent = y
                    }
                    Transplant(&z!, &y)
                    y.left = z!.left
                    y.left?.parent = y
                    y.color = z!.color
                }
            }
            z = nil
            if OriginalColor == Color.BLACK{
                DeleteFixUp(&x)
            }
        }
        
        func getAllElements() -> [T2]{
            var arr:[T2] = []
            inOrderTraverse(self.root, &arr)
            return arr
        }
        
        func contains(_ item: T2) -> Bool{
            return Search(item) === self.root && item != self.root?.key ? false : true
        }
        
        func getMin() -> T2?{
            var x = self.root
            if x != nil{
                while x!.left != nil && x!.left !== leafNode{
                    x = x!.left!
                }
                return x!.key
            }
            return nil
        }
        
        func getMax() -> T2?{
            var x = self.root
            if x != nil{
                while x!.right != nil && x!.right !== leafNode{
                    x = x!.right!
                }
                return x!.key
            }
            return nil
        }
    }
    init(){}
    init(_ data: T1){
        append(data)
    }
    
    init(_ data: [T1]){
        for i in data{
            append(i)
        }
    }
    var min: T1?{
        return self.Tree.getMin()
    }
    
    var max: T1?{
        return self.Tree.getMax()
    }
    
    mutating func append(_ data: T1){
        if self.ele_count[data] == nil{
            self.ele_count[data] = 1
        }
        else{
            self.ele_count[data]! += 1
        }
        self.Tree.Insert(data)
    }
    
    mutating func remove(_ data: T1){
        if contains(data){
            self.Tree.Delete(data)
            self.ele_count[data]! -= 1
            if self.ele_count[data] == 0{
                self.ele_count.removeValue(forKey: data)
            }
        }
    }
    
    func contains(_ key: T1) -> Bool{
        return self.Tree.contains(key)
    }
}

