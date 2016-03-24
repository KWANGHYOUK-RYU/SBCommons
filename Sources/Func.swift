//
//  Func.swift
//  SBCommons
//
//  Created by Ed Gamble on 10/22/15.
//  Copyright © 2015 Opus Logica Inc. All rights reserved.
//

/**
 * The Y-combinator - for the hell of it
 *
 * - argument f:
 *
 * - returns: A function
 */
func Y<T, R> (f: (T -> R) -> (T -> R)) -> (T -> R) {
  return { t in f(Y(f))(t) }
}

/** Factorial, defined using the Y-combinator */
let factorial = Y {
  f in {
    n in n == 0 ? 1 : n * f(n - 1)
  }
}

/**
 * A function that always returns x
 *
 * - argument x:
 *
 * - returns: A function of (y:T) that (always) return x
 */
public func always<T> (x:T) -> (y:T) -> T {
  return { (y:T) in return x }
}

/**
 * Complememnt a predicate
 *
 * - argument pred: The function to complement
 *
 * - returns: A function as !pred
 */
public func complement<T> (pred : (T) -> Bool) -> (T) -> Bool {
  return { (x:T) in return !pred(x) }
}

/**
 * Compose functions `f` and `g` as `f(g(x))`
 *
 * - argument f: 
 * - argument g:
 *
 * - returns: a function of `x:T` returning `f(g(x))`
 */
public func compose<T, U, V> (f f: (U) -> V, g: (T) -> U) -> (T) -> V {
  return { (x:T) in f (g (x)) }
}

/**
 * Disjoin two predicates
 *
 * - argument pred1: 
 * - argument pred2:
 *
 * - returns: A function of `x:T` that returns pred1(x) || pred2(x)
 */
public func disjoin<T> (pred1 pred1: (T) -> Bool, pred2: (T) -> Bool) -> (T) -> Bool {
  return { (x:T) in pred1 (x) || pred2 (x) }
}

/**
 * Conjoin two predicates
 *
 * - argument pred1:
 * - argument pred2:
 *
 * - returns: A function of `x:T` that returns pred1(x) && pred2(x)
 */
public func conjoin<T> (pred1 pred1: (T) -> Bool, pred2: (T) -> Bool) -> (T) -> Bool {
  return { (x:T) in pred1 (x) && pred2 (x) }
}

/**
 * 
 *
 * - argument pred:
 * - argument x:
 *
 * - returns: A function of (y:T) that returns pred(x,y)
 */
public func equalTo<T> (pred pred: (T, T) -> Bool, x:T) -> (T) -> Bool {
  return { (y:T) in return pred (x, y) }
}

// MARK: - Sequence App Type

public protocol SequenceAppType : SequenceType {
  /** Think different: renaming of `forEach` to be analogous to `map` */
  func app (@noescape body: (Self.Generator.Element) -> Void) -> Void
}

extension SequenceType {
  public func app (@noescape body: (Self.Generator.Element) throws -> Void) rethrows -> Void {
    for item in self { try body (item) }
  }
}

// MARK: Sequence Logic Type

public protocol SequenceLogicType : SequenceType {
  
  /**
   * Check if any element satisfies `predicate`.
   *
   * - argument predicate: 
   *
   * - returns: `true` if any element satisfies `predicate`; `false` otherwise
   */
  func any (@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Bool
  
  /**
   * Check if all elements satisfy `predicate`.
   *
   * - argument predicate:
   *
   * - returns: `true` if all elements satisfy `predicate`; `false` otherwise
   */
  func all (@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Bool
}

extension SequenceType {
  
  public func any (@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Bool {
    for elt in self {
      if (try predicate (elt)) { return true }
    }
    return false
  }
  
  public func all (@noescape predicate: (Self.Generator.Element) throws -> Bool) rethrows -> Bool {
    for elt in self {
      if (try !predicate (elt)) { return false }
    }
    return true
  }
}

// MARK: Sequence Scan Type

public protocol SequenceScanType : SequenceType {
  /**
   * Scan `self` element by element combining elements.  Resulting array has one element more
   * than `self`.
   *
   * - argument initial: the resulting array's initial element
   * - argument combine: the function combining the 'accumulated' value with next element
   *
   * - retuns: array with scanned elements
   */
  func scan <R> (initial: R, combine: (R, Generator.Element) -> R) -> [R]
}

extension SequenceType {
  func scan <R> (initial: R, combine: (R, Generator.Element) -> R) -> [R] {
    var result = Array<R> (count: 1, repeatedValue: initial)
    var accum = initial
    
    for elt in self {
      accum = combine (accum, elt)
      result.append(accum)
    }
    
    return result
  }
}


// Mark: Curried Functions

/**
 * Curry application of `predicate` on `x`; returns a function of `y` returning `predicate(x,y)`
 *
 * - argument predicate: the predicate
 * - argument x:
 *
 * - returns: A function of (y:T) that returns predicate(x,y)
 */
public func equateUsing<T> (predicate: (T, T) -> Bool) -> (T) -> (T) -> Bool {
  return { (x:T) -> (T) -> Bool in
    return { (y:T) -> Bool in
      return predicate (x, y) }
  }
}

/** Curry `any()` using `predicate` */
public func anyUsing <S: SequenceType> (predicate: (S.Generator.Element) -> Bool) -> (S) -> Bool {
  return { (source:S) -> Bool in
    return source.any (predicate)
  }
}

/** Curry `all()` using `predicate`. */
public func allUsing <S: SequenceType> (predicate: (S.Generator.Element) -> Bool) -> (S) -> Bool {
  return { (source:S) -> Bool in
    return source.all (predicate)
  }
}

/** Curry `map()` using `transform`. */
public func mapUsing <S: SequenceType, T> (transform: (S.Generator.Element) -> T) -> (S) -> [T] {
  return { (source:S) in
    return source.map (transform)
  }
}

/** Curry `app()` using `body`. */
public func appUsing <S: SequenceType> (body: (S.Generator.Element) -> Void) -> (S) -> Void {
  return { (source:S) in
    return source.app (body)
  }
}
