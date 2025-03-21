//
//  MessageProcessor.swift
//  OtpScatcher
//
//  Created by Arumugam Jeganathan on 3/15/25.
//

import AppKit
import EonilFSEvents
import Foundation
import SQLite
import os

private let logger = Logger(subsystem: "MessageProcessor", category: "db")

class MessageProcessor {

    let messages = Table("message")
    let attributedBodyColumn = SQLite.Expression<SQLite.Blob?>("attributedBody")
    let textColumn = SQLite.Expression<String?>("text")
    let idColumn = SQLite.Expression<Int64>("ROWID")
    var dbFileActual: String
    var lastIdRead: Int64 = 0

    init(dbFile: String? = nil) throws {
        dbFileActual = dbFile ?? "\(NSHomeDirectory())/Library/Messages/chat.db"
    }

    func startWatching(withHandler: @escaping () -> Void) {
        do {
            try EonilFSEvents.startWatching(
                paths: [(dbFileActual as NSString).deletingLastPathComponent],
                for: ObjectIdentifier(self),
                with: { event in
                    print("Got notified for file: \(event.path)")
                    if event.path.hasSuffix(".db") || event.path.hasSuffix(".db-wal") {
                        withHandler()
                    }
                })
        } catch {
            logger.error("Error watching directory \(self.dbFileActual)")
        }
    }

    func stopWatching() {
        EonilFSEvents.stopWatching(for: ObjectIdentifier(self))
    }

    func getLatestText() -> SmsCode? {
        do {
            print ("Last row id = \(lastIdRead)")
            let db = try Connection(dbFileActual, readonly: true)
            let query = messages.select(attributedBodyColumn, textColumn, idColumn)
                .filter(idColumn > lastIdRead)
                .order(idColumn.desc)
                .limit(1)
            let result = try db.prepare(query).map { row in
                (row[idColumn], row[attributedBodyColumn])
            }
            if !result.isEmpty {
                let (rowId, blob) = result[0]
                lastIdRead = rowId
                if let smsCode = blob?.asMessageContent() {
                    if smsCode.codePresent { return smsCode }
                }
            }
        } catch {
            logger.error("Error while talking to database. [\(self.dbFileActual)]")
        }
        return nil
    }
}

extension MessageProcessor {

    static var codes: AsyncStream<SmsCode> {
        AsyncStream<SmsCode> { continuation in
            do {
                // dbFile: "\(NSHomeDirectory())/temp/chat.db"
                let processor = try MessageProcessor()
                processor.startWatching {
                    if let code = processor.getLatestText() {
                        continuation.yield(code)
                    }
                }
                continuation.onTermination = { @Sendable _ in
                    processor.stopWatching()
                }
            } catch {
                logger.error("Error getting codes from db. \(error)")
            }

        }
    }
}
