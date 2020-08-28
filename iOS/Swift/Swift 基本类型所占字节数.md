* Bool 占 1 字节
* Int64 占 8 字节
* Float 占 4 字节
* Double 占 8 字节
* String 占 16 字节
* Character 占 16 字节

```
/// Bool 占 1 字节
print("========Bool========")
func boolPointer(_ p1: UnsafePointer<Bool>, _ p2: UnsafePointer<Bool>) {
    print("p1 address = \(p1), p2 address = \(p2)")
}

var boolX = true
var boolY = false
boolPointer(&boolX, &boolY)

/// Int64 占 8 字节
print("========Int========")
func intPointer(_ p1: UnsafePointer<Int>, _ p2: UnsafePointer<Int>) {
    print("p1 address = \(p1), p2 address = \(p2)")
}

var intX = 1
var intY = intX
intPointer(&intX, &intY)

/// Float 占 4 字节
print("========Float========")
func floatPointer(_ p1: UnsafePointer<Float>, _ p2: UnsafePointer<Float>) {
    print("p1 address = \(p1), p2 address = \(p2)")
}

var floatX: Float = 1.0
var floatY = floatX
floatPointer(&floatX, &floatY)

/// Double 占 8 字节
print("========Double========")
func doublePointer(_ p1: UnsafePointer<Double>, _ p2: UnsafePointer<Double>) {
    print("p1 address = \(p1), p2 address = \(p2)")
}

var doubleX = 1.0
var doubleY = doubleX
doublePointer(&doubleX, &doubleY)

/// String 占 16 字节
print("========String========")
func stringPointer(_ p1: UnsafePointer<String>, _ p2: UnsafePointer<String>) {
    print("p1 address = \(p1), p2 address = \(p2)")
}

var strX = "1"
var strY = strX
stringPointer(&strX, &strY)

/// Character 占 16 字节
print("========Char========")
func charPointer(_ p1: UnsafePointer<Character>, _ p2: UnsafePointer<Character>) {
     print("p1 address = \(p1), p2 address = \(p2)")
}

var charX: Character = "1"
var charY = charX
charPointer(&charX, &charY)
```
