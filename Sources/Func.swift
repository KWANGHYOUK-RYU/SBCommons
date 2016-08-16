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
func Y<T, R> (_ f: @escaping (@escaping (T) -> R) -> ((T) -> R)) -> ((T) -> R) {
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
public func always<T> (_ x:T) -> (_ y:T) -> T {
  return { (y:T) in return x }
}

/**
 * Complememnt a predicate
 *
 * - argument pred: The function to complement
 *
 * - returns: A function as !pred
 */
public func complement<T> (_ pred : @escaping (T) -> Bool) -> (T) -> Bool {
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
public func compose<T, U, V> (f: @escaping (U) -> V, g: @escaping (T) -> U) -> (T) -> V {
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
public func disjoin<T> (pred1: @escaping (T) -> Bool, pred2: @escaping (T) -> Bool) -> (T) -> Bool {
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
public func conjoin<T> (pred1: @escaping (T) -> Bool, pred2: @escaping (T) -> Bool) -> (T) -> Bool {
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
public func equalTo<T> (pred: @escaping (T, T) -> Bool, x:T) -> (T) -> Bool {
  return { (y:T) in return pred (x, y) }
}

// MARK: - Sequence App Type

public protocol SequenceAppType : Sequence {
  /** Think different: renaming of `forEach` to be analogous to `map` */
  func app ( _ body: (Self.Iterator.Element) -> Void) -> Void
}

extension Sequence {
  public func app (_ body: (Self.Iterator.Element) throws -> Void) rethrows -> Void {
    for item in self { try body (item) }
  }
}

// MARK: Sequence Logic Type

public protocol SequenceLogicType : Sequence {
  
  /**
   * Check if any element satisfies `predicate`.
   *
   * - argument predicate: 
   *
   * - returns: `true` if any element satisfies `predicate`; `false` otherwise
   */
  func any (_ predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Bool
  
  /**
   * Check if all elements satisfy `predicate`.
   *
   * - argument predicate:
   *
   * - returns: `true` if all elements satisfy `predicate`; `false` otherwise
   */
  func all (_ predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Bool
}

extension Sequence {
  
  public func any (_ predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Bool {
    for elt in self {
      if (try predicate (elt)) { return true }
    }
    return false
  }
  
  public func all (_ predicate: (Self.Iterator.Element) throws -> Bool) rethrows -> Bool {
    for elt in self {
      if (try !predicate (elt)) { return false }
    }
    return true
  }
}

// MARK: Sequence Scan Type

public protocol SequenceScanType : Sequence {
  /**
   * Scan `self` element by element combining elements.  Resulting array has one element more
   * than `self`.
   *
   * - argument initial: the resulting array's initial element
   * - argument combine: the function combining the 'accumulated' value with next element
   *
   * - retuns: array with scanned elements
   */
  func scan <R> (_ initial: R, combine: (R, Iterator.Element) -> R) -> [R]
}

extension Sequence {
  func scan <R> (_ initial: R, combine: (R, Iterator.Element) -> R) -> [R] {
    var result = Array<R> (repeating: initial, count: 1)
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
public func equateUsing<T> (_ predicate: @escaping (T, T) -> Bool) -> (T) -> (T) -> Bool {
  return { (x:T) -> (T) -> Bool in
    return { (y:T) -> Bool in
      return predicate (x, y) }
  }
}

/** Curry `any()` using `predicate` */
public func anyUsing <S: Sequence> (_ predicate: @escaping (S.Iterator.Element) -> Bool) -> (S) -> Bool {
  return { (source:S) -> Bool in
    return source.any (predicate)
  }
}

/** Curry `all()` using `predicate`. */
public func allUsing <S: Sequence> (_ predicate: @escaping (S.Iterator.Element) -> Bool) -> (S) -> Bool {
  return { (source:S) -> Bool in
    return source.all (predicate)
  }
}

/** Curry `map()` using `transform`. */
public func mapUsing <S: Sequence, T> (_ transform: @escaping (S.Iterator.Element) -> T) -> (S) -> [T] {
  return { (source:S) in
    return source.map (transform)
  }
}

/** Curry `app()` using `body`. */
public func appUsing <S: Sequence> (_ body: @escaping (S.Iterator.Element) -> Void) -> (S) -> Void {
  return { (source:S) in
    return source.app (body)
  }
}
