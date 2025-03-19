//
//  SqliteBlob.swift
//  OtpScatcher
//
//  Created by Arumugam Jeganathan on 3/16/25.
//

import Foundation
import SQLite
import os

private let logger = Logger(subsystem: "SQLite.Blob", category: "db")

struct SmsCode {
    var code: String?
    var message: String
    var codePresent: Bool
}

extension SQLite.Blob {
    func asMessageContent() -> SmsCode? {
        let data = Data(bytes)
        do {
            let decoder = NSUnarchiver(forReadingWith: data)
            guard
                let attributedString = try decoder?.decodeTopLevelObject()
                    as? NSAttributedString
            else {
                print("Error: Could not decode to NSAttributedString.")
                return nil
            }
            let code = extractCode(from: attributedString)
            if let code = code {
                return SmsCode(
                    code: code, message: attributedString.string,
                    codePresent: true)
            } else {
                return SmsCode(
                    code: nil, message: attributedString.string,
                    codePresent: false)
            }
        } catch {
            logger.error(
                "Failed to decode attributedBody: \(error.localizedDescription)"
            )
        }
        return nil
    }

    private func extractCode(from attributedString: NSAttributedString)
        -> String?
    {
        let fullRange = NSRange(location: 0, length: attributedString.length)
        var codeFound: String? = nil
        attributedString.enumerateAttributes(in: fullRange) { attrs, _, _ in
            if let oneTimeCodeDict = attrs[
                NSAttributedString.Key(
                    rawValue: "__kIMOneTimeCodeAttributeName")]
                as? [String: Any],
                let code = oneTimeCodeDict["code"] as? String
            {
                codeFound = code
            }
        }

        return codeFound
    }
}
