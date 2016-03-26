//: Playground - noun: a place where people can play

import SBCommons

var str = "Hello, playground"

//: [Next](@next)

class Person : Equatable {
  let ssn  : String
  let name : String
  let age  : UInt
  
  init (ssn:String, name:String, age:UInt) {
    self.ssn  = ssn
    self.name = name
    self.age  = age
  }
}

func == (lhs:Person, rhs:Person) -> Bool {
  return lhs.ssn == rhs.ssn
}

let p1 = Person (ssn: "123", name: "Zack", age: 10)
let p2 = Person (ssn: "321", name: "Zoey", age: 9)

let younger = min(AsComparable (value: p1.age, item: p1), AsComparable (value: p2.age, item: p2)).item
younger.name
