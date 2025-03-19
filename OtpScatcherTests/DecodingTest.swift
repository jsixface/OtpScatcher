//
//  DecodingTest.swift
//  OtpScatcherTests
//
//  Created by Arumugam Jeganathan on 3/16/25.
//

import Foundation
import SQLite
import Testing

@testable import OtpScatcher

struct DecodingTest {

    @Test func properDataDecodeTest() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let expectedText = "Test Message"
        let attributedString = NSAttributedString(
            string: expectedText,
            attributes: [NSAttributedString.Key("__"): "123456"])

        do {
            let data = try NSKeyedArchiver.archivedData(
                withRootObject: attributedString, requiringSecureCoding: false)
            let blob = SQLite.Blob(bytes: [UInt8](data))

            let extractedText = blob.asMessageContent()

            #expect(extractedText == expectedText)

        } catch {
            print("Failed to archive NSAttributedString: \(error)")
        }
    }

    @Test func testAttributedBodyDecoding() async throws {
        guard
            let fileURL = Bundle.path(
                forResource: "attributedBody", withExtension: "dat")
        else {
            fail("Test file not found: attributedBody.dat")
            return
        }

        let testData = try Data(contentsOf: fileURL)
        let blob = SQLite.Blob(bytes: [UInt8](testData))

        let extractedText = blob.asMessageContent()
        print("Extracted Text: \(extractedText)")

        #expect(!extractedText.isEmpty, "Decoded text should not be empty")
    }
}
