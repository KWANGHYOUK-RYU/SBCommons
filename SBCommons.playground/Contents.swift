//: Playground - noun: a place where people can play

import SBCommons

var str = "Hello, playground"

//: [Next](@next)

class Person {
  let ssn  : String
  let name : String
  let age  : UInt
  
  init (ssn:String, name:String, age:UInt) {
    self.ssn  = ssn
    self.name = name
    self.age  = age
  }
}

extension Person : Equatable {}
func == (lhs:Person, rhs:Person) -> Bool {
  return lhs.ssn == rhs.ssn
}

let p1 = Person (ssn: "123", name: "Zack", age: 10)
let p2 = Person (ssn: "321", name: "Zoey", age: 9)
let p3 = Person (ssn: "790", name: "Xena", age: 4)

let younger = min (AsComparable (item: p1, value: p1.age),
                   AsComparable (item: p2, value: p2.age)).item
younger.name

var people = [p1, p2, p3]

var alphabetized = people.map { AsComparable(item: $0, value: $0.name) }
  .sorted()
  .map { $0.item }

alphabetized

alphabetized.first?.name

1


let personByName = AsEquatable (item: p1, value: p1.name)



2