//
//  NoConnectionView.swift
//  Primo
//
//  Created by Macmini on 6/27/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//
import DropDown

class DialogEditePoint
{
    var mainView = UIView()
    var imageViewBG = UIImageView()
    var dialogView = UIView()
    let textContent = UITextField()
    let myCardButton = UIButton()
    let imageLineOne = UIImageView()
    let imageLineTwo = UIImageView()
    let imageCard = UIImageView()
    
    var index: Int?
    let dropDown = DropDown()
    var myCardList: [PrimoCard] = []
    var MyDeal:[Deal] = []
    
    var cardList: [String] = ["  กรุณาเลือกบัตรที่จะใช้คะแนนสะสม"]
    var cardBuffer: [PrimoCard] = []
    var mController: DealViewController? = nil
    var statusmCard: Int = 0
    var memberCardForList: Int = 0
    var creditCardForList: Int = 0
    
    class var shared: DialogEditePoint
    {
        struct Static
        {
            static let instance: DialogEditePoint = DialogEditePoint()
        }
        return Static.instance
    }
    
    
    public func Show(deal :[Deal] ,controller :DealViewController,statusCard :Int , stepCard: Int) {
        let viewSize = UIScreen.main.bounds
        MyDeal.removeAll()
        
        statusmCard = 0
        memberCardForList = 0
        creditCardForList = 0
        
        MyDeal = deal
        mController = controller
        statusmCard = statusCard
        
        mainView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        mainView.backgroundColor = HexStringToUIColor(hex: "#FFFFFF00")
        mainView.contentMode = UIViewContentMode.scaleAspectFill
        mainView.alpha = 1
        
        
        imageViewBG.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        imageViewBG.contentMode = .scaleAspectFit
        imageViewBG.backgroundColor = HexStringToUIColor(hex: "#444444")
        imageViewBG.alpha = 0.5
        mainView.addSubview(imageViewBG)
        
        
        
        
        dialogView.frame = CGRect(x: (mainView.bounds.width-330)/2,
                                  y: 80,
                                  width: 330,
                                  height: 350)
        //278 h 
        // 115 y
        
        
        dialogView.backgroundColor = UIColor.white
        dialogView.alpha = 1
        dialogView.clipsToBounds = true
        dialogView.layer.cornerRadius = 8
        mainView.addSubview(dialogView)
        
        
        
        
        
        let textHeader = UILabel(frame: CGRect(x: 0, y: 26, width: dialogView.bounds.width, height: 40))
        textHeader.numberOfLines = 0;
        textHeader.backgroundColor = UIColor.white
        textHeader.textColor = UIColor.black
        textHeader.text = "เลือกบัตร"
//        textHeader.font = textHeader.font.withSize(17)
        textHeader.font = UIFont.boldSystemFont(ofSize: 18.0)
        textHeader.textAlignment = .center
        dialogView.addSubview(textHeader)
        
        
        
        
        
        myCardButton.frame = CGRect(x: 22,
                                    y: 167,
                                    width: dialogView.bounds.width-48,
                                    height: 40)
        myCardButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        myCardButton.layer.borderWidth = 1
        myCardButton.backgroundColor = HexStringToUIColor(hex: "#F2F2F2")
        myCardButton.setTitleColor(HexStringToUIColor(hex: "#AAAAAA"), for: .normal)
        myCardButton.layer.cornerRadius = 5
        if(statusmCard == 4){
            myCardButton.setTitle(" เลือกบัตรสมาชิก", for: .normal)
        }else{
            myCardButton.setTitle(" เลือกบัตรเครดิต", for: .normal)
        }
        myCardButton.layer.borderColor = UIColor.init(red:222/255.0,
                                                      green:225/255.0,
                                                      blue:227/255.0,
                                                      alpha: 1.0).cgColor
    
        SetupDropDown(step :stepCard)
    
        dialogView.addSubview(myCardButton)
        
        
        
        imageLineOne.frame = CGRect(x: 0,
                             y: 225.5,
                             width: dialogView.bounds.width,
                             height: 1)
        imageLineOne.backgroundColor = HexStringToUIColor(hex: "#F2F2F2")
        dialogView.addSubview(imageLineOne)
        
        
        imageCard.frame = CGRect(x: (dialogView.bounds.width - (dialogView.bounds.width-48)/2)/2,
                                 y: 75,
                                 width: (dialogView.bounds.width-48)/2,
                                 height: 65)
        imageCard.contentMode = .scaleAspectFit
        imageCard.layer.cornerRadius = 5
        dialogView.addSubview(imageCard)
        
        
        
        textContent.frame = CGRect(x: 22,
                                   y: 244,
                                   width: dialogView.bounds.width-48,
                                   height: 40)
        textContent.backgroundColor = HexStringToUIColor(hex: "#F2F2F2")
        textContent.textAlignment = .center
//        textContent.text = String(mPoint)

        textContent.keyboardType = UIKeyboardType.numberPad
        textContent.becomeFirstResponder()
        textContent.font = textContent.font?.withSize(17)
        textContent.layer.cornerRadius = 5
        textContent.tintColor = HexStringToUIColor(hex: "#AAAAAA")
        textContent.layer.borderWidth = 1
        
//        if(stepCard == 1){
//            textContent.isUserInteractionEnabled = true
//            textContent.placeholder = ""
//        }else{
//            textContent.isUserInteractionEnabled = false
//            textContent.placeholder = "ใส่คะแนน"
//        }
        
        textContent.layer.borderColor = UIColor.init(red:222/255.0,
                                                     green:225/255.0,
                                                     blue:227/255.0,
                                                     alpha: 1.0).cgColor
        
        
        dialogView.addSubview(textContent)
        
        
        
        imageLineTwo.frame = CGRect(x: 0,
                                    y: 302.5,
                                    width: dialogView.bounds.width,
                                    height: 1)
        imageLineTwo.backgroundColor = HexStringToUIColor(hex: "#F2F2F2")
        dialogView.addSubview(imageLineTwo)

        
        
        
        
        let buttonLink = UIButton(frame: CGRect(x: 0,
                                                y: 302.5,
                                                width: dialogView.bounds.width/2,
                                                height: 48))
        buttonLink.setTitle("ยกเลิก",for: .normal)
        buttonLink.setTitleColor(UIColor.blue, for: .normal)
        buttonLink.backgroundColor = UIColor.white
        buttonLink.titleLabel?.lineBreakMode = .byWordWrapping
        buttonLink.layer.borderWidth = 1
        buttonLink.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        buttonLink.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        buttonLink.addTarget(self, action: #selector(UrlLink), for: .touchUpInside)
        dialogView.addSubview(buttonLink)
        
        
        let button =  UIButton(frame: CGRect(x: dialogView.bounds.width/2,
                                             y: 302.5,
                                             width: dialogView.bounds.width/2,
                                             height: 48))
        button.setTitle("ตกลง", for: .normal)
        button.backgroundColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.init(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).cgColor
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(sendActionData), for: .touchUpInside)
        dialogView.addSubview(button)
        
        
        
        let window: UIWindow = UIApplication.shared.keyWindow!
        window.addSubview(mainView)
        window.bringSubview(toFront: mainView)
        mainView.frame = window.bounds
        
        //        view.addSubview(mainView)
        
    }
    
    @objc func UrlLink(_ sender: Any){
        textContent.text = ""
        Hide()
    }
    
    
    @objc func sendActionData(_ sender: Any)  {
        var pointvalue: Int?
        
        if((textContent.text?.length)! > 0 ){
            if(self.index != 0){
                pointvalue = Int(textContent.text!) ?? 0
                
                self.cardBuffer[index!-1].pointToUse = pointvalue
                if(mController != nil){
                    mController?.OnReFreshCallService(card: cardBuffer[index!-1])
                }
            }

        }
        textContent.text = ""
        Hide()
    }
    
    
    
    public func Hide() {
        mainView.removeFromSuperview()
        imageViewBG.removeFromSuperview()
        dialogView.removeFromSuperview()
        myCardButton.removeFromSuperview()
        textContent.removeFromSuperview()
    }
    
    
    public func drop() {
        mainView.removeFromSuperview()
    }
    
    
    
    public func SetupDropDown(step: Int) {
        
        clearData()
        myCardList = CardDB.instance.getCards()
        cardList.append(" เลือกบัตร")
        loopCheckTypeCard(mDeal: MyDeal[0])
        
        if(memberCardForList == 1 || creditCardForList == 1){
           setDropdownSumCardIsOne()
        }else{
           setDropdownSumCards()
        }
    }
    
    
    func setDropdownSumCardIsOne(){
        myCardButton.setTitle(cardBuffer[0].nameTH, for: .normal)
        myCardButton.isEnabled = false
        self.index = 1
        imageCard.sd_setImage(with: URL(string: cardBuffer[0].imgUrl))
        textContent.isUserInteractionEnabled = true
        textContent.placeholder = ""
    }
    
    func setDropdownSumCards(){
//        if(statusmCard == 4){
//            cardList.append(" เลือกบัตร")
//        }else{
//            cardList.append(" เลือกบัตร")
//        }
        imageCard.image = UIImage(named: "")
        myCardButton.isEnabled = true
        dropDown.anchorView = myCardButton
//        loopCheckTypeCard(mDeal: MyDeal[0])
        dropDown.dataSource = cardList
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.myCardButton.setTitle(item, for: .normal)
            if (index == 0) {
                self.textContent.isUserInteractionEnabled = false
                self.textContent.placeholder = "ใส่คะแนน"
                self.index = index
                self.imageCard.image = UIImage(named: "")
            } else {
                self.textContent.isUserInteractionEnabled = true
                self.textContent.placeholder = ""
                self.textContent.becomeFirstResponder()
                self.index = index
                self.imageCard.sd_setImage(with: URL(string: self.cardBuffer[index - 1].imgUrl))
            }
        }
        
        textContent.isUserInteractionEnabled = false
        textContent.placeholder = "ใส่คะแนน"
        myCardButton.addTarget(self, action: #selector(OnMyCardButtonClicked),for: .touchUpInside)
    }
    
    func loopCheckTypeCard(mDeal: Deal) {
        if(mDeal.Childs != nil){
            for card in myCardList {
                if(card.cardId == mDeal.card?.cardId){
                    if(!cardList.contains(card.nameTH)){
                        
                        if(statusmCard == 4){
                            if(card.type == .memberCard && mDeal.isStorewide != true){
                                cardList.append(card.nameTH)
                                cardBuffer.append(card)
                                memberCardForList = memberCardForList + 1
                            }
                            
                        }else{
                            if(card.type == .creditCard || card.type == .debitCard){
                                cardList.append(card.nameTH)
                                cardBuffer.append(card)
                                creditCardForList = creditCardForList + 1
                            }
                        }

                    }
                }
            }
            return loopCheckTypeCard(mDeal: mDeal.Childs!)
        }else{
            for card in myCardList {
                if(card.cardId == mDeal.card?.cardId){
                    if(!cardList.contains(card.nameTH)){
                        
                        if(statusmCard == 4 && mDeal.isStorewide != true){
                            if(card.type == .memberCard){
                                cardList.append(card.nameTH)
                                cardBuffer.append(card)
                                memberCardForList = memberCardForList + 1
                            }
                            
                        }else{
                            if(card.type == .creditCard || card.type == .debitCard){
                                cardList.append(card.nameTH)
                                cardBuffer.append(card)
                                creditCardForList = creditCardForList + 1
                            }
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    
    func clearData(){
        cardList.removeAll()
        cardBuffer.removeAll()
        index = 0
    }

    
    @objc func OnMyCardButtonClicked(_ sender: Any) {
                dropDown.show()
   }
}

