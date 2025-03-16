//
//  MessageProcessor.swift
//  OtpScatcher
//
//  Created by Arumugam Jeganathan on 3/15/25.
//

import Foundation
import SQLite
import os

private let logger = Logger(subsystem: "MessageProcessor", category: "db")

class MessageProcessor {

    var db: Connection

    init(dbFile: String? = nil) throws {
        do {
            let userDir = NSHomeDirectory()
            let dbFileActual = dbFile ?? "\(userDir)/Library/Messages/chat.db"
            db = try Connection(dbFileActual)
        } catch {
            logger.error("Cannot connect to DB. \(error)")
            throw error
        }
    }

    let messages = Table("message")
    let attributedBodyColumn = SQLite.Expression<SQLite.Blob?>("attributedBody")
    let textColumn = SQLite.Expression<String?>("text")
    let idColumn = SQLite.Expression<Int64>("ROWID")


    func getCode() async -> String? {
        // TODO
        return nil
    }

    private func getLatestTexts() -> [String] {
        do
        {
            let query = messages.select(attributedBodyColumn, textColumn, idColumn)
                .order(idColumn.desc).limit(10)
            let numbers =
            try db.prepare(query).map { row in
                row[textColumn] ?? row[attributedBodyColumn]?.asText()
            }
            
            // TODO
        } catch {
            
        }
        return []
    }
}

extension SQLite.Blob {
    fileprivate func asText() -> String {
        // TODO
        return ""
    }
}
