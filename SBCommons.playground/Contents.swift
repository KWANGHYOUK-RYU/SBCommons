//: Playground - noun: a place where people can play

import SBCommons

var str = "Hello, playground"

var foo = [String:Int]()
foo
foo["a"] = 10
foo

foo.updateValue(20, forKey: "a")  // returns old, if exists.

var bar = Dictionary<String,Int>()
bar["b"] = 1
bar

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


var s1 = Set<AsHashable<String,Person>>()
s1.insert(AsHashable(item: p1, value: p1.name))
s1


2

var person_by_age_builder = AsComparable<UInt,Person>.builder { (p:Person) in p.age }

var p1ac = person_by_age_builder(p1)
var p2ac = person_by_age_builder(p2)

p1ac < p2ac

//var person_by_ssn_builder = AsComparable<String,Person>.builder { Person.ssn }

struct Contract {
  let person : Person
}

class Employer {
  var contracts = Dictionary<AsHashable<String,Person>,Contract>()

  func employ (person: Person) {
    contracts[AsHashable(item: person, value: person.ssn)] = Contract(person: person)
    return
  }
}

3

var e1 = Employer()
e1.employ(person: p1)
e1.contracts.count
e1.contracts


/*
}
var e1 = Employer()
e1
*/
