//
//  Result.swift
//  SBCommons
//
//  Created by Ed Gamble on 10/22/15.
//  Copyright © 2015 Opus Logica Inc. All rights reserved.
//

/**
 * A variant type with an arbitrary `value` on Success or an `error` on Failure.
 */
public enum Result<V,E:ErrorType> : CustomStringConvertible, CustomDebugStringConvertible {
  case Success(V)
  case Failure(E)

  /** Apply `f` to the `Result` value returning the result; otherwise return error */
  public func map<P>(@noescape f: V -> P) -> Result<P,E> {
    switch self {
    case Success(let value):
      return .Success(f(value))
    case Failure(let error):
      return .Failure(error)
    }
  }

  /** Apply `f` to the `Result` value returning the result; otherwsise return error */
  public func flatMap<P> (@noescape f: V -> Result<P,E>) -> Result<P,E> {
    switch self {
    case Success(let value):
      return f (value)
    case Failure(let error):
      return .Failure(error)
    }
  }
  
  /** Return the `Result` value otherwise Optional.None */
  public var value : V? {
    switch self {
    case Success(let value):
      return value
    case Failure:
      return nil;
    }
  }

  /** Return the `Result` value otherwise throw the `Result` error */
  public func valueOrThrow () throws -> V {
    switch self {
    case Success(let value):
      return value
    case Failure(let error):
      throw error
    }
  }

  /** Return the `Result` value otherwise return the value returned by `other` */
  public func valueOrOther (@autoclosure other: () -> V) -> V {
    switch self {
    case Success(let value):
      return value
    case Failure:
      return other()
    }
  }

  /** Return `Result` if it has a value otherwise return the result returned by `otherwise` */
  public func otherwise (@autoclosure other: () -> Result<V,E>) -> Result<V,E> {
    switch self {
    case Success:
      return self
    case Failure:
      return other()
    }
  }
  
  /** Return the `Result` error otherwise Optional.None */
  public var error : E? {
    switch self {
    case Success:
      return nil
    case Failure(let e):
      return e
    }
  }
  
  /**
   * Create a handler function
   *
   * - argument f: A function accepting a `Result1
   *
   * - returns: A function of (V!, E!) that applies `f` to `E` or to `V`.
   */
  public static func handler (f:Result<V,E> -> Void) -> (V!, E!) -> Void {
    return { (value:V!, error:E!) in
      if nil != error { f (Result.Failure(error)) }
      if nil != value { f (Result.Success(value)) }
      preconditionFailure("V! and E! both nil")
    }
  }
  
  // MARK: CustomStringConvertable
  
  public var description : String {
    switch self {
    case Success(let v):
      return "Result.Success(\(v))"
    case Failure(let e):
      return "Result.Failure(\(e))"
    }
  }
  
  public var debugDescription : String {
    return description
  }
}

