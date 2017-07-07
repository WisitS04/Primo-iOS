import SQLite

class StoreDB{
    static let instance = StoreDB()
    private let db: Connection?
    
    private let stores = Table("stores")
    private let storeId = Expression<Int64>("storeId")
    private let branchId = Expression<Int64>("branchId")
    private let storeName = Expression<String>("storeName")
    private let storeNameEng = Expression<String>("storeNameEng")
    private let branchName = Expression<String>("branchName")
    private let branchNameEng = Expression<String>("branchNameEng")
    private let imageUrl = Expression<String>("imageUrl")
    private let distance = Expression<Int64>("distance")
    
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            db = try Connection("\(path)/Primo_Stores.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        //        dropTable(table: cards)
        createTable(table: stores)
    }

    
    func createTable(table: Table) {
        do {
            try db!.run(table.create(ifNotExists: true) { table in
                table.column(storeId)
                table.column(branchId)
                table.column(storeName)
                table.column(storeNameEng)
                table.column(branchName)
                table.column(branchNameEng)
                table.column(imageUrl)
                table.column(distance)
            })
        } catch {
            print("Unable to create table store")
        }
    }
    
    func dropTable(table: Table) {
        do {
            // DROP TABLE IF EXISTS
            try db!.run(table.drop(ifExists: true))
        } catch {
            print("Drop table Stores failed")
        }
    }
    
    
    func addStore(cStoreId: Int64, cBranchId: Int64, cStoreName: String,
                  cStoreNameEng: String, cBranchName: String, cBranchNameEng: String,
                  cImageUrl: String, cDistance: Int64) -> Int64{
        do {
            let insert = stores.insert(storeId <- cStoreId,
                                      branchId <- cBranchId,
                                      storeName <- cStoreName,
                                      storeNameEng <- cStoreNameEng,
                                      branchName <- cBranchName,
                                      branchNameEng <- cBranchNameEng,
                                      imageUrl <- cImageUrl,
                                      distance <- cDistance)
            let id = try db!.run(insert)
            print("Insert SQL: \(insert.asSQL())")
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
    
    
    
    func getStores() -> [Store] {
        var stores = [Store]()
        do {
            for store in try db!.prepare(self.stores) {
                stores.append(Store(storeId: store[storeId],
                                       branchId: store[branchId],
                                       storeName: store[storeName],
                                       storeNameEng: store[storeNameEng],
                                       branchName: store[branchName],
                                       branchNameEng: store[branchNameEng],
                                       imageUrl: store[imageUrl],
                                       distance: store[distance]))
            }
        } catch {
            print("Select failed")
        }
        return stores
    }
    
    func deleteStore() -> Bool {
        do {
            let store = stores
            try db!.run(store.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
    
}
