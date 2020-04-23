## Swift 实现链表

### 链表的定义
```
class LinkList<E: Equatable> {
    var count = 0
    
    private(set) var first: LinkNode<E>?
    var last: LinkNode<E>? { getNode(at: count - 1) }
    
    var isEmpty: Bool { count == 0 }
    
    subscript(index: Int) -> E {
        get {
            return getNode(at: index).val
        }
        
        set(newValue) {
            let node = getNode(at: index)
            node.val = newValue
        }
    }
    
    // MARK - 查找
    func contains(_ element: E) -> Bool {
        return getIndex(element) != nil
    }
    
    // MARK - 私有方法
    private func getIndex(_ element: E) -> Int? {
        let temp = first
        var curIndex = 0
        
        while temp != nil {
            if temp?.val == element {
                return curIndex
            }
            curIndex += 1
        }
        return nil
    }
    
    private func getNode(at i: Int) -> LinkNode<E> {
        if i > count { fatalError("out of Range") }
        var curNode = first
        
        for _ in 0..<i {
            curNode = curNode?.next
        }
        return curNode!
    }
}
```
### 常用的链表操作
#### 移除操作
```
extension LinkList {
    // MARK - 移除
    func remove(_ deleteElement: E) -> E {
        guard let i = getIndex(deleteElement) else { fatalError("Not Found") }
        
        let preNode = getNode(at: i)
        preNode.next = preNode.next?.next
        count -= 1
        
        return deleteElement
    }
    
    func remove(at i: Int) -> E {
        let removeVal = getNode(at: i).val
        if i == 0 {
            first = first?.next
        } else {
            let preNode = getNode(at: i - 1)
            preNode.next = preNode.next?.next
        }
        
        count -= 1
        return removeVal
    }
    
    func removeFirst() { remove(at: 0) }
    
    func removeLast() { remove(at: count - 1) }
    
    func removeAll() {
        first = nil
        count = 0
    }
}
```

#### 添加操作
```
extension LinkList {
    // MARK - 添加
    func append(_ newElement: E) {
        let node = LinkNode(newElement, next: nil)
        
        if first == nil {
            first = node
        } else {
            let lastNode = getNode(at: count - 1)
            lastNode.next = node
        }
        count += 1
    }
    
    func append(contentsOf newElements: [E]) {
        guard !newElements.isEmpty else { return }
        
        if first == nil {
            first = LinkNode(newElements.first!)
            var curNode = first
            
            for i in 1..<newElements.count {
                curNode?.next = LinkNode(newElements[i])
                curNode = curNode?.next
            }
        } else {
            var lastNode = last
            for ele in newElements {
                lastNode?.next = LinkNode(ele)
                lastNode = lastNode?.next
            }
        }
        
        count += newElements.count
    }
    
    func insert(_ newElement: E, at i: Int) {
        let node = LinkNode(newElement, next: nil)
        
        if i == 0 {
            node.next = first
            first = node
        } else {
            let preNode = getNode(at: i - 1)
            node.next = preNode.next
            preNode.next = node
        }
        
        count += 1
    }
}
```
#### 反转链表 
```
extension LinkList {
    func reversed(_ isRecursion: Bool = false) {
        guard !isEmpty else { return }
        
        if isRecursion {
            first = reversedByRecrusion(first)
        } else {
            reversedByLoop()
        }
    }
    
    private func reversedByRecrusion(_ head: LinkNode<E>?) -> LinkNode<E>? {
        if head == nil || head?.next == nil {
            return head
        }
        
        let nextNode = head?.next
        let curNode = reversedByRecrusion(nextNode)
        nextNode?.next = head
        head?.next = nil
        
        return curNode
    }
    
    private func reversedByLoop() {
        var newHead: LinkNode<E>?
        var curNode = first
        var nextNode = first?.next
        while curNode != nil || curNode?.next != nil {
            curNode?.next = newHead
            newHead = curNode
            curNode = nextNode
            
            nextNode = curNode?.next
        }
        
        first = newHead
    }
}
```
