## 反转链表
* 链表：链表是一种物理存储单元上非连续、非顺序的存储结构，数据元素的逻辑顺序是通过链表中的指针链接次序实现的。链表由一系列结点（链表中每一个元素称为结点）组成，结点可以在运行时动态生成。每个结点包括两个部分：一个是存储数据元素的数据域，另一个是存储下一个结点地址的指针域。
* Swift 代码示例
```
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

func reverseListNode(headNode: ListNode?, newNode: ListNode?) -> ListNode? {
    if headNode == nil {
        return newNode
    }
    let next = headNode?.next
    headNode?.next = newNode
    return reverseListNode(headNode: next, newNode: headNode!)
}

func createListNode() {
    var i = 0
    var firstNode = ListNode(i);
    while i < 10 {
        i = i + 1
        firstNode.next = ListNode(i);
    }
    print(firstNode.val)
    firstNode = reverseListNode(headNode: firstNode, newNode: nil)!
    print(firstNode.val)
}

createListNode()
```

* 链表的增删改查

## 冒泡排序
* Swift代码示例
```
func bubbleSort(arr: inout [Int], length:Int) ->[Int] {
    for index1 in 0...length {
        for index2 in index1...length {
            if arr[index1] > arr[index2] {
                let temp = arr[index1]
                arr[index1] = arr[index2]
                arr[index2] = temp
            }
        }
    }
    return arr
}

var arr = [3,6,9,1,0]

print(bubbleSort(arr: &arr, length: 4))
```

## 二分法
* Swift
```
func bisectionFunc(nums: [Int], key: Int) -> Int? {
    var left = 0
    var right = nums.count - 1
    while left <= right {
        let mid = (left + right)/2
        if nums[mid] == key {
            return mid
        } else if nums[mid] > key {
            right = right - 1
        } else {
            left = left + 1
        }
    }
    return nil
}
```

## Extension
* [github](https://github.com/CyC2018/Interview-Notebook)

