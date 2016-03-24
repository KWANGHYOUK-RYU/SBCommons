//
//  AnyAs.swift
//  SBCommons
//
//  Created by Ed Gamble on 12/4/15.
//  Copyright © 2015 Opus Logica Inc. All rights reserved.
//

// MARK: As Equatable

/** An AsEquatable is an Equatable, based on Value, for an arbitrary Item */
public struct AsEquatable<Value:Equatable, Item> : Equatable {
  
  /** The value for Equatable */
  public var value: Value
  
  /** The arbitrary item */
  public var item: Item
  
  public init (value: Value, item: Item) {
    self.value = value
    self.item  = item
  }
  
  public init (item: Item, toValue: (Item) -> Value) {
    self.init (value: toValue(item), item: item)
  }
}

public func == <Value:Equatable, Item> (lhs:AsEquatable<Value, Item>, rhs:AsEquatable<Value,Item>) -> Bool {
  return lhs.value == rhs.value
}

// MARK: As Comparable

/** An AsComparable is a Comparable, based on Value, for an arbitary Item */
public struct AsComparable<Value:Comparable, Item> : Comparable {
  
  /** The value for Comparable */
  public var value: Value
  
  /** The arbitrary item */
  public var item: Item
  
  public init (value: Value, item: Item) {
    self.value  = value
    self.item   = item
  }
  
  public init (item: Item, toValue: (Item) -> Value) {
    self.init (value: toValue(item), item: item)
  }
}

public func == <Value:Comparable, Item> (lhs:AsComparable<Value, Item>, rhs:AsComparable<Value,Item>) -> Bool {
  return lhs.value == rhs.value
}

public func < <Value:Comparable, Item> (lhs:AsComparable<Value, Item>, rhs:AsComparable<Value,Item>) -> Bool {
  return lhs.value < rhs.value
}

// MARK: As Comparable Invert

/** An AsComparableInvert is a Comparable that inverts the comparison */
public struct AsComparableInvert<Value:Comparable> : Comparable {
  
  /** The value for Comparable with invert */
  public var value : Value
  
  public init (value: Value) {
    self.value   = value
  }
}

public func == <Value:Comparable> (lhs:AsComparableInvert<Value>, rhs:AsComparableInvert<Value>) -> Bool {
  return lhs.value == rhs.value
}

public func < <Value:Comparable> (lhs:AsComparableInvert<Value>, rhs:AsComparableInvert<Value>) -> Bool {
  return lhs.value > rhs.value
}

// MARK: AsHashable

/** An AsHashable is a Hashable, based on Value, for an arbitrary Item */
public struct AsHashable<Value:Hashable, Item> : Hashable {
  
  /** The value for Hashable */
  public var value: Value
  
  /** The arbitrary item */
  public var item: Item
  
  public init (value: Value, item: Item) {
    self.value = value
    self.item  = item
  }
  
  public init (item: Item, toValue: (Item) -> Value) {
    self.init (value: toValue(item), item: item)
  }
  
  public var hashValue : Int {
    return value.hashValue
  }
}

public func == <Value:Hashable, Item> (lhs:AsHashable<Value, Item>, rhs:AsHashable<Value,Item>) -> Bool {
  return lhs.value == rhs.value
}



