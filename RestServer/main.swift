// CWID: 890568827
// Antonio de Lis
// HW Assignment #1

import Kitura
import Cocoa

let router = Router()

router.all("/ClaimService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    response.send("Hello! Welcome to visit the service. ")
    next()
}

router.get("ClaimService/getAll"){
    request, response, next in
    let pList = PersonDao().getAll()
    // JSON Serialization
    let jsonData : Data = try JSONEncoder().encode(pList)
    //JSONArray
    let jsonStr = String(data: jsonData, encoding: .utf8)
    // set Content-Type
    response.status(.OK)
    response.headers["Content-Type"] = "application/json"
    response.send(jsonStr)
    // response.send("getAll service response data : \(pList.description)")
    next()
}

router.post("ClaimService/add") {
    request, response, next in
    // JSON deserialization on Kitura server
    let body = request.body
    let jObj = body?.asJSON //JSON object
    if let jDict = jObj as? [String:String] {
        if let i = jDict["id"],let t = jDict["title"],let d = jDict["date"], let is = jDict["isSolved"] {
            let pObj = Claim(i:i, t:t, d:d, is:is)
            PersonDao().addPerson(pObj: pObj)
        }
    }
    response.send("The Claim record was successfully inserted (via POST Method).")
    next()
}


Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()
