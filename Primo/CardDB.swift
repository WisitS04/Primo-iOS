import SQLite

class CardDB {
    
    var DataBaseVersion = UserDefaults.standard
    var dataBaseVS_number:Int = 0
    var fixVersionCardDB:Int = 1
    
    
    var clonValue = [PrimoCard]()
    
    static let instance = CardDB()
    private let db: Connection?
    
    private let cards = Table("cards")
    private let id = Expression<Int64>("id")
    private let cardId = Expression<Int64>("cardId")
    private let type = Expression<Int>("type")
    private let nameEN = Expression<String>("nameEN")
    private let nameTH = Expression<String>("nameTH")
    private let imgUrl = Expression<String>("imgUrl")
    private let point = Expression<Int?>("point")
    private let pointToUse = Expression<Int?>("pointToUse")
    
    private init() {
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            db = try Connection("\(path)/Primo_Cards.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
//        dropTable(table: cards)
        createTable(table: cards)
    }
    
    func createTable(table: Table) {
        do {
            try db!.run(table.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(cardId)
                table.column(type)
                table.column(nameEN)
                table.column(nameTH)
                table.column(imgUrl)
                table.column(point)
                table.column(pointToUse)

            })
        } catch {
            print("Unable to create table")
        }
    }
    
    func dropTable(table: Table) {
        do {
            // DROP TABLE IF EXISTS
            try db!.run(table.drop(ifExists: true))
        } catch {
            print("Drop table failed")
        }
    }
    
    func addCard(cId: Int64, cType: Int, cNameTH: String, cNameEN:
        String, cImgUrl: String, cPoint: Int? = nil, cPointToUse: Int? = nil) -> Int64 {
        do {
            let insert = cards.insert(cardId <- cId,
                                      type <- cType,
                                      nameTH <- cNameTH,
                                      nameEN <- cNameEN,
                                      imgUrl <- cImgUrl,
                                      point <- cPoint,
                                      pointToUse <- cPointToUse)
            let id = try db!.run(insert)
            print("Insert SQL: \(insert.asSQL())")
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    func getCards() -> [PrimoCard] {
        var cards = [PrimoCard]()
        do {
            for card in try db!.prepare(self.cards) {
                cards.append(PrimoCard(id: card[id],
                                       cardId: card[cardId],
                                       type: card[type],
                                       nameEN: card[nameEN],
                                       nameTH: card[nameTH],
                                       imgUrl: card[imgUrl],
                                       point: card[point]))
            }
        } catch {
            print("Select failed")
        }
        return cards
    }
    
    func deleteCard(cId: Int64) -> Bool {
        do {
            let card = cards.filter(cardId == cId)
            try db!.run(card.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
    
    func updateCard(cId:Int64, newCard: PrimoCard) -> Bool {
        let contact = cards.filter(cardId == cId)
        do {
            let update = contact.update([cardId <- newCard.cardId,
                                         type <- newCard.type.rawValue,
                                         nameEN <- newCard.nameEN,
                                         nameTH <- newCard.nameTH,
                                         imgUrl <- newCard.imgUrl,
                                         point <- newCard.point,
                                         pointToUse <- newCard.pointToUse])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }
        return false
    }
    
    
    
    func CheckVertionCardDB(){
        dataBaseVS_number  = DataBaseVersion.integer(forKey: MyCardDB)
        
        if(fixVersionCardDB == dataBaseVS_number){
            print(" = ")
        }else{
            print(" != ")
            ClonValueToDB()
            DataBaseVersion.set(fixVersionCardDB, forKey: MyCardDB)
        }

    }
    
    
    
    func ClonValueToDB(){
        clonValue = CardDB.instance.getCards()
        if(!clonValue.isEmpty){
            dropTable(table: cards)
            createTable(table: cards)
            
            for item in clonValue{
                _ = CardDB.instance.addCard(cId: item.cardId,
                                            cType: item.type.rawValue,
                                            cNameTH: item.nameTH,
                                            cNameEN: item.nameEN,
                                            cImgUrl: item.imgUrl,
                                            cPoint: item.point,
                                            cPointToUse: item.pointToUse)
            }
        }
    }

}
