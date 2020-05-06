## 面试题18. 删除链表的节点

### 题目介绍
```
 面试题18. 删除链表的节点
 给定单向链表的头指针和一个要删除的节点的值，定义一个函数删除该节点。
 返回删除后的链表的头节点。
 注意：此题对比原题有改动
 示例 1:
 输入: head = [4,5,1,9], val = 5
 输出: [4,1,9]
 解释: 给定你链表中值为 5 的第二个节点，那么在调用了你的函数之后，该链表应变为 4 -> 1 -> 9.
 示例 2:
 输入: head = [4,5,1,9], val = 1
 输出: [4,5,9]
 解释: 给定你链表中值为 1 的第三个节点，那么在调用了你的函数之后，该链表应变为 4 -> 5 -> 9.
```

### 思路
* 判断是否为头部节点
* 循环遍历到目标节点的前节点
* 将前节点的 next 指向目标节点的 next

### 代码
```
class Solution {
    func deleteNode(_ head: ListNode?, _ val: Int) -> ListNode? {
        if head == nil { return nil }
        if head!.val == val { return head?.next}

        var cur = head
        while cur?.next != nil && cur?.next!.val != val {
            cur = cur?.next
        }
        if cur?.next != nil {
            cur?.next = cur?.next?.next
        }
        return head
    }
}
```
