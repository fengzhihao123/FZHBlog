## 环形链表 ②
### 简介
```
给定一个链表，返回链表开始入环的第一个节点。 如果链表无环，则返回 null。
为了表示给定链表中的环，我们使用整数 pos 来表示链表尾连接到链表中的位置（索引从 0 开始）。 如果 pos 是 -1，则在该链表中没有环。
说明：不允许修改给定的链表。
```
### 思路
* 使用快慢指针先找到两个指针第一次相遇的节点
* 再将任意一个指针指向头部
* 快慢指针每次走一步，再相遇即是入口节点
### 代码

`很奇怪的是一样的逻辑，Swift 的代码就不能通过，Java 的代码就能通过？？？`
 
#### Swift
```
class Solution {
    func detectCycle(_ head: ListNode?) -> ListNode? {
        var fast = head
        var slow = head
        while true {
            if fast == nil || fast?.next == nil { return nil }
            fast = fast?.next?.next
            slow = slow?.next
            if fast?.val == slow?.val {
                break 
            }
        }
        
        fast = head
        while slow?.val != fast?.val {
            slow = slow?.next
            fast = fast?.next
        }
        return fast
    }
}
```
#### Java
```
public class Solution {
    public ListNode detectCycle(ListNode head) {
        ListNode slow = head;
        ListNode fast = head;
        while (true) {
            if (fast == null || fast.next == null) {
                return null;
            }
            slow = slow.next;
            fast = fast.next.next;
            if (slow == fast) {
                break;
            }
        }
        
        fast = head;
        while (slow != fast) {
            slow = slow.next;
            fast = fast.next;
        }
        return fast;
    }
}
```
