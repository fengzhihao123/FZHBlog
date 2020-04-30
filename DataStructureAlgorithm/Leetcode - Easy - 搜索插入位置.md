## 搜索插入位置

### 介绍
```
给定一个排序数组和一个目标值，在数组中找到目标值，并返回其索引。如果目标值不存在于数组中，返回它将会被按顺序插入的位置。
你可以假设数组中无重复元素。
示例 1:
输入: [1,3,5,6], 5
输出: 2
示例 2:
输入: [1,3,5,6], 2
输出: 1
示例 3:
输入: [1,3,5,6], 7
输出: 4
示例 4:
输入: [1,3,5,6], 0
输出: 0
```
### 思路
```
1、判断头尾边界值
2、使用二分法查找位置
```
### 代码
```
class Solution {
    func searchInsert(_ nums: [Int], _ target: Int) -> Int {
        // 检查头尾边界
        if let first = nums.first, first > target { return 0 }
        if let last = nums.last, last < target { return nums.count }
        // 二分法查找位置
        var left = 0
        var right = nums.count - 1
        while left <= right {
            let mid = (left + right)/2
            if nums[mid] == target {
                return mid
            } else if nums[mid] < target {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
        return left
    }
}
```
