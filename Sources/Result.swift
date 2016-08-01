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
public enum Result<V,E:Error> : CustomStringConvertible, CustomDebugStringConvertible {
  case success(V)
  case failure(E)

  /** Apply `f` to the `Result` value returning the result; otherwise return error */
  public func map<P>( _ f: @noescape(V) -> P) -> Result<P,E> {
    switch self {
    case .success(let value):
      return .success(f(value))
    case .failure(let error):
      return .failure(error)
    }
  }

  /** Apply `f` to the `Result` value returning the result; otherwsise return error */
  public func flatMap<P> ( _ f: @noescape(V) -> Result<P,E>) -> Result<P,E> {
    switch self {
    case .success(let value):
      return f (value)
    case .failure(let error):
      return .failure(error)
    }
  }
  
  /** Return the `Result` value otherwise Optional.None */
  public var value : V? {
    switch self {
    case .success(let value):
      return value
    case .failure:
      return nil;
    }
  }

  /** Return the `Result` value otherwise throw the `Result` error */
  public func valueOrThrow () throws -> V {
    switch self {
    case .success(let value):
      return value
    case .failure(let error):
      throw error
    }
  }

  /** Return the `Result` value otherwise return the value returned by `other` */
  public func valueOrOther ( _ other: @autoclosure() -> V) -> V {
    switch self {
    case .success(let value):
      return value
    case .failure:
      return other()
    }
  }

  /** Return `Result` if it has a value otherwise return the result returned by `otherwise` */
  public func otherwise ( _ other: @autoclosure() -> Result<V,E>) -> Result<V,E> {
    switch self {
    case .success:
      return self
    case .failure:
      return other()
    }
  }
  
  /** Return the `Result` error otherwise Optional.None */
  public var error : E? {
    switch self {
    case .success:
      return nil
    case .failure(let e):
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
  public static func handler (_ f:(Result<V,E>) -> Void) -> (V?, E?) -> Void {
    return { (value:V?, error:E?) in
      if nil != error { f (Result.failure(error!)) }
      if nil != value { f (Result.success(value!)) }
      preconditionFailure("V! and E! both nil")
    }
  }
  
  // MARK: CustomStringConvertable
  
  public var description : String {
    switch self {
    case .success(let v):
      return "Result.Success(\(v))"
    case .failure(let e):
      return "Result.Failure(\(e))"
    }
  }
  
  public var debugDescription : String {
    return description
  }
}

