//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import Testing
import Subprocess

@Suite
struct SubprocessTests {
    @Test
    func manySubprocesses() async throws {
        for _ in 0..<1000 {
            let output = try await run(
                .path(.init("/bin/echo")),
                arguments: ["Hello, world!"],
            )
            #expect(output.standardOutput == "Hello, world!\n")
        }
    }
}
