// CWID: 890568827
// Antonio de Lis
// HW Assignment #1
//
//  PersonDao.swift
//  RestServer
//
//  Created by ITLoaner on 9/24/20.
//

import SQLite3
import Foundation

// Textbook uses JSONSerialization API (in Foundation module)
// JSONEncoder/JSONDecoder

struct Claim : Codable {
    var id : String?
    var title : String?
    var date : String?
    var isSolved : boolean

    init(t: String?, d: String?, is: Bool) {
        let id = UUID().uuidString
        title = t
        date = d
        isSolved = is
    }
}

class PersonDao {

    func addClaim(pObj : Claim) {
        let sqlStmt = String(format:"insert into claim (id, title, date, isSolved) values ('%@', '%@', '%@', '%@')", (pObj.id)!, (pObj.title)!, pObj.date)!, (pObj.isSolved)
        // get database connection
        let conn = Database.getInstance().getDbConnection()
        // submit the insert sql statement
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert a Claim record due to error \(errcode)")
        }
        // close the connection
        sqlite3_close(conn)
    }

    func getAll() -> [Claim] {
        var pList = [Claim]()
        var resultSet : OpaquePointer?
        let sqlStr = "select id, title, date, isSolved from claim"
        let conn = Database.getInstance().getDbConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW) {
                // Convert the record into a Claim object
                // Unsafe_Pointer<CChar> Sqlite3
                let id_val = sqlite3_column_text(resultSet, 0)
                let id = String(cString: id_val!)
                let t_val = sqlite3_column_text(resultSet, 1)
                let t = String(cString: t_val!)
                let d_val = sqlite3_column_text(resultSet, 2)
                let d = String(cString: d_val!)
                let is_val = sqlite3_column_int(resultSet, 3)
                let is = Bool(String(cString: is_val!))
                pList.append(Claim(i:i, t:t, d:d, is:is))
            }
        }
        return pList
    }
}
