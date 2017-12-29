//
import SQLite

class NotificationDB{
    
    var dataBaseVS_number:Int = 0
    var fixVersionStoreDB:Int = 1
    
    static let instance = NotificationDB()
    private var db: Connection? = nil
    
    private let notification = Table("notification")
    private let notificationId = Expression<Int64>("notificationId")
    private let imageUrl = Expression<String>("imageUrl")
    private let titleName = Expression<String>("titleName")
    private let subTitleName = Expression<String>("subTitleName")
    private let type = Expression<Int>("type")
    
    private init(){
        let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        do {
            db = try Connection("\(path)/Primo_NotificationDB.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database")
        }
        
        //        dropTable(table: cards)
        createTable(table: notification)
    }
    
    func createTable(table: Table) {
        do {
            try db!.run(table.create(ifNotExists: true) { table in
                table.column(notificationId)
                table.column(imageUrl)
                table.column(titleName)
                table.column(subTitleName)
                table.column(type)
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
    
    
    func add(cNotificationId: Int64, cImageUrl: String, cTitleName: String,
                  cSubTitleName: String, cType: Int) -> Int64{
        do {
            let insert = notification.insert(notificationId <- cNotificationId,
                                       imageUrl <- cImageUrl,
                                       titleName <- cTitleName,
                                       subTitleName <- cSubTitleName,
                                       type <- cType)
            let id = try db!.run(insert)
            print("Insert SQL: \(insert.asSQL())")
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    
    }
    
    
    func deleteItem(cId: Int64) -> Bool {
        do {
            let noti = notification.filter(notificationId == cId)
            try db!.run(noti.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
    
    
    func getNotification() -> [notificationModel] {
        var mNavigation = [notificationModel]()
        do {
            for navigation in try db!.prepare(self.notification) {
                mNavigation.append(notificationModel(notificationId: navigation[notificationId],
                                    imageUrl: navigation[imageUrl],
                                    titleName: navigation[titleName],
                                    subTitleName: navigation[subTitleName],
                                    type: navigation[type]))
            }
        } catch {
            print("Select failed")
        }
        return mNavigation
    }
    
    
    
    func deleteNotification() -> Bool {
        do {
            let notifications = notification
            try db!.run(notifications.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
    
    
    
    
}
