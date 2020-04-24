### 常用的Extension
#### 关于UIColor的hex Extension
* Swift (3.1)
```
extension UIColor {
    class func colorWithHexString(color: String,alpha: CGFloat) -> UIColor {
        
        var colorStr = color
        let length = colorStr.lengthOfBytes(using: String.Encoding.utf8)
        
        if length < 6 {
            return UIColor.clear
        }
        if colorStr.hasPrefix("0X") {
            colorStr = colorStr.substring(from: "0X".endIndex)
        }
        if colorStr.hasPrefix("#") {
            colorStr = colorStr.substring(from: "#".endIndex)
        }
        var chacters = [Character]()
        for chacter in colorStr.characters {
            chacters.append(chacter)
        }
        
        //    red
        let redStr = String(chacters[0]) + String(chacters[1])
        //    green
        let greenStr = String(chacters[2]) + String(chacters[3])
        //    blue
        let blueStr = String(chacters[4]) + String(chacters[5])
        
        var r: UInt32 = 1
        var g: UInt32 = 1
        var b: UInt32 = 1
        
        Scanner.init(string: redStr).scanHexInt32(&r)
        Scanner.init(string: greenStr).scanHexInt32(&g)
        Scanner.init(string: blueStr).scanHexInt32(&b)
        
        return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
    }
    
    class func colorWithHexString(color: String) -> UIColor {
        return self.colorWithHexString(color: color, alpha: 1.0)
    }
}
```

#### 关于UIView的Extension
* Swift (3.1)
```
extension UIView {
    var x: CGFloat {
        set {
            self.frame.origin.x = newValue
        }
        get {
            return self.frame.origin.x
        }
    }
    
    var y: CGFloat {
        set {
            self.frame.origin.y = newValue
        }
        get {
            return self.frame.origin.y
        }
    }
    
    var width: CGFloat {
        set {
            self.frame.size.width = newValue
        }
        get {
            return self.frame.size.width
        }
    }
    var height: CGFloat {
        set {
            self.frame.size.height = newValue
        }
        get {
            return self.frame.size.height
        }
    }
}
```