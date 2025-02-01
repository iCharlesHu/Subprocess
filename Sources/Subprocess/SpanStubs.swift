//
//  SpanStubs.swift
//  SwiftExperimentalSubprocess
//
//  Created by Charles Hu on 1/29/25.
//

import Foundation
import Dispatch

@_unsafeNonescapableResult
@inlinable @inline(__always)
@lifetime(borrow source)
public func _overrideLifetime<
    T: ~Copyable & ~Escapable,
    U: ~Copyable & ~Escapable
>(
    of dependent: consuming T,
    to source: borrowing U
) -> T {
    dependent
}

@_unsafeNonescapableResult
@inlinable @inline(__always)
@lifetime(source)
public func _overrideLifetime<
    T: ~Copyable & ~Escapable,
    U: ~Copyable & ~Escapable
>(
    of dependent: consuming T,
    copyingFrom source: consuming U
) -> T {
    dependent
}

@available(macOS 9999, *)
extension Data {
    init(_ s: borrowing RawSpan) {
        self = s.withUnsafeBytes { Data($0) }
    }

    public var bytes: RawSpan {
        // FIXME: For demo purpose only
        let ptr = self.withUnsafeBytes { ptr in
            return ptr
        }
        let span = RawSpan(_unsafeBytes: ptr)
        return _overrideLifetime(of: span, to: self)
    }
}

@available(macOS 9999, *)
extension DataProtocol {
    var bytes: RawSpan {
        _read {
            if self.regions.isEmpty {
              let empty = UnsafeRawBufferPointer(start: nil, count: 0)
              let span = RawSpan(_unsafeBytes: empty)
              yield _overrideLifetime(of: span, to: self)
            }
            else if self.regions.count == 1 {
                // Easy case: there is only one region in the data
                let ptr = self.regions.first!.withUnsafeBytes { ptr in
                    return ptr
                }
                let span = RawSpan(_unsafeBytes: ptr)
                yield _overrideLifetime(of: span, to: self)
            }
            else {
                // This data contains discontiguous chunks. We have to
                // copy and make a contiguous chunk
                var contiguous: ContiguousArray<UInt8>?
                for region in self.regions {
                    if contiguous != nil {
                        contiguous?.append(contentsOf: region)
                    } else {
                        contiguous = .init(region)
                    }
                }
                let ptr = contiguous!.withUnsafeBytes { ptr in
                    return ptr
                }
                let span = RawSpan(_unsafeBytes: ptr)
                yield _overrideLifetime(of: span, to: self)
            }
        }
    }
}
