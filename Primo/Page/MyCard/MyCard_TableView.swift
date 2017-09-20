import UIKit

class MyCard_TableView: UITableView{
    var myCards: [PrimoCard] = []
    var myCardItemsBuffer: [[PrimoCard]] = [[],[],[]]
    var myCardItems = [[PrimoCard]]()
    var selectedCard: PrimoCard?
    var myView: UIView? = nil
    fileprivate var tableType: PrimoCardType = .unknown
    
    
    var sectionTitle = [String]()
    
//    var sectionTitle = ["บัตรเครดิต",
//                        "บัตรเดบิต",
//                        "บัตรสมาชิก"]
    
    
    func Setup(tableType: PrimoCardType, mView: UIView) {
        self.dataSource = self
        self.delegate = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 58.0
        self.myView? = mView
        self.tableType = tableType
        
        FilterCard()
        setSection()
        
//        setCard()
    }
    
    
//    func setCard(){
//        
//        myCards.removeAll()
//        myCardItemsBuffer[0].removeAll()
//        myCardItemsBuffer[1].removeAll()
//        myCardItemsBuffer[2].removeAll()
//        
//        if(!sectionTitle.isEmpty){
//           var count: Int = 0
//           count = sectionTitle.count
//        
//            for i in 0 ..< count {
//                sectionTitle[i].removeAll()
//                        
//             }
//        }
//        
//        
//        myCards = CardDB.instance.getCards()
//        for item in myCards {
//            
//            if(item.type == .creditCard){
//                myCardItemsBuffer[0].append(item)
//            }else if(item.type == .debitCard){
//                myCardItemsBuffer[1].append(item)
//            }else if(item.type == .memberCard){
//                myCardItemsBuffer[2].append(item)
//            }
//            
//        }
//
//        
//        
//        if(!myCardItemsBuffer[0].isEmpty){
//                     sectionTitle.append("บัตรเครดิต")
//        }
//        
//        if(!myCardItemsBuffer[1].isEmpty){
//                    sectionTitle.append("บัตรเดบิต")
//        }
//        
//        if(!myCardItemsBuffer[2].isEmpty){
//                    sectionTitle.append("บัตรสมาชิก")
//         }
//        
//        
//
//    }
    
    func FilterCard() {
        
        if(!myCards.isEmpty){
            myCards.removeAll()

        }
        
        if(!myCardItemsBuffer.isEmpty){
            myCardItemsBuffer[0].removeAll()
            myCardItemsBuffer[1].removeAll()
            myCardItemsBuffer[2].removeAll()
        }
        
        if(!myCardItems.isEmpty){
            
            var count: Int = 0
            count = myCardItems.count
            
            for i in 0 ..< count {
                myCardItems[i].removeAll()
                
            }
        }
        
        
        myCards = CardDB.instance.getCards()
        for item in myCards {

            if(item.type == .creditCard){
                 myCardItemsBuffer[0].append(item)
            }else if(item.type == .debitCard){
                 myCardItemsBuffer[1].append(item)
            }else if(item.type == .memberCard){
                myCardItemsBuffer[2].append(item)
            }
            
        }
    }
    
    func setSection(){
        
        if(!sectionTitle.isEmpty){
            
            var count: Int = 0
            count = sectionTitle.count
            
            for i in 0 ..< count {
                sectionTitle[i].removeAll()
                
            }
        }
        
        
        if(!myCardItemsBuffer[0].isEmpty){
             myCardItems.append(myCardItemsBuffer[0])
             sectionTitle.append("บัตรเครดิต")
        }
        
        if(!myCardItemsBuffer[1].isEmpty){
            myCardItems.append(myCardItemsBuffer[1])
            sectionTitle.append("บัตรเดบิต")
        }
        
        if(!myCardItemsBuffer[2].isEmpty){
            myCardItems.append(myCardItemsBuffer[2])
            sectionTitle.append("บัตรสมาชิก")
        }
    }
    
    
   
    
}

extension MyCard_TableView {
    func confrimDialog(value: Int , id: Int64){
        
        for item in myCards {
            if(item.cardId == id){
               item.point = value
             _ = CardDB.instance.updateCard(cId: id, newCard: item)
            }
        }
        UpdateMyCards()
    }
    
    func DeleteCard(id: Int64) {
        if (CardDB.instance.deleteCard(cId: Int64(id))) {
            UpdateMyCards()
        }
    }
    

}

extension MyCard_TableView: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//                return myCardItemsBuffer[section].count
        return myCardItems[section].count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCardList", for: indexPath) as! MyCardCell
        let card = myCardItems[indexPath.section][indexPath.row]
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
         let point: Int?
        
        if(card.point != nil){
           point = card.point
        }else{
           point = 0
        }
        
        cell.view_bg.layer.borderWidth = 1
        cell.view_bg.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        cell.view_bg.layer.cornerRadius = 5
       
        
        cell.image_card.sd_setImage(with: URL(string: card.imgUrl))
        cell.nameTH?.text = card.nameTH
        cell.nameEN?.text = card.nameEN
        cell.image_point.image = UIImage(named: "point_icon")
        cell.image_delete_card.image = UIImage(named : "bin_icon")
        cell.point_value?.text = (formatter.string(from: NSNumber(value: point!)) ?? "0")
        
        
        
        cell.btn_delete?.backgroundColor = UIColor.clear
        cell.btn_delete.tag = Int(card.cardId)
        cell.btn_delete.setTitle("", for: .normal)
        cell.btn_delete.addTarget(self, action: #selector(sendActionData), for: .touchUpInside)
        
        cell.btn_point?.setTitle("", for: .normal)
        cell.btn_point?.backgroundColor = UIColor.clear
        cell.btn_point?.tag = Int(card.cardId)
        cell.btn_point?.addTarget(self, action: #selector(setPointCard), for: .touchUpInside)
        
        
        return cell
    }
    
    
    
    @objc func sendActionData(_ sender: Any)  {
        let value = sender as! UIButton
        ConfrimDialog.shared.Show(id : Int64(value.tag) , mTable: self)
    }
    
    @objc func setPointCard(_ sender: Any) {
        let value = sender as! UIButton
        var point: Int = 0
        
        for item in myCards {
            if(item.cardId == Int64(value.tag)){
                if(item.point != nil){
                    point = item.point!
                }else{
                    point = 0
                }
                
            }
            
        }
         DialogForMyCard.shared.Show(mPoint: point ,id : Int64(value.tag), mTable: self)
    }
    
    

    
    func UpdateMyCards() {
        FilterCard()
        setSection()
//        setCard()
        self.reloadData()
    }
    
}
