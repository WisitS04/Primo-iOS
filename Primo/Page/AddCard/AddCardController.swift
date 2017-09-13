//
//  AddCardController.swift
//  Primo
//
//  Created by Macmini on 8/28/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Segmentio

class AddCardController: UIViewController
{
    var segmentioView: Segmentio!
    var btn_back: UIButton!
    var request: Alamofire.Request?
    @IBOutlet weak var bankCollection: BankListCollectionView!

    
    
    
    var cardType: Int = PrimoCardType.creditCard.rawValue
    var bankID: Int = -1
    var networkID: Int = -1
    var firstOpent: Int = -1

    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.setHidesBackButton(true, animated:true);
        
//        setUpBack()
        
        AddSegmentioView()
        SetUpSegmentioView()
        
        bankCollection.SetUp(viewController: self)
//        bankCollection.LoadBankList(cardType: cardType)
        bankCollection.CallCrediteBank()
    

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "back"){
             self.request?.cancel()
//            Alamofire.SessionManager.default.session.invalidateAndCancel()
        }
    }

    
    
//    func setUpBack(){
//        
//          btn_back = UIButton()
//          btn_back.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//          btn_back.setTitle("", for: .normal)
//          btn_back.setImage(UIImage(named: "Artboard 2"), for: .normal)
//          btn_back.addTarget(self, action: #selector(backToMainPage), for: .touchUpInside)
//          let btnLeft = UIBarButtonItem(customView: btn_back)
//          navigationItem.setLeftBarButtonItems([btnLeft], animated: true)
//        
//    }
    
    func backToMainPage(){
//        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//        self.navigationController?.pushViewController(secondViewController, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func OnBankSelected(id: Int) {
        bankID = id
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectCard") as! SelectCard
        secondViewController.BankID = bankID
        secondViewController.CardType = cardType
        self.navigationController?.pushViewController(secondViewController, animated: true)

    }
   
    func finishCallService(){
         GuideForAddCard.shared.Show(view: self.view, navigationController: self.navigationController!)
    }
    

    
}

extension AddCardController{
    
    override func viewWillDisappear(_ animated: Bool) {
//        Alamofire.cance
    }
    
    func AddSegmentioView() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0
        let segmentioViewRect = CGRect(
            x: 0,
            y: statusBarHeight + navigationBarHeight,
            width: UIScreen.main.bounds.width,
            height: 50)
        //print("segmentioViewRect = \(segmentioViewRect)")
        segmentioView = Segmentio(frame: segmentioViewRect)
        self.view.addSubview(segmentioView)
    }
    
    
    func SetUpSegmentioView() {
        func Content() -> [SegmentioItem] {
            return [
                SegmentioItem(title: "บัตรเครดิต", image: nil),
                SegmentioItem(title: "บัตรเดบิต", image: nil),
                SegmentioItem(title: "บัตรสมาชิก", image: nil)
            ]
        }
        
        func Option() -> SegmentioOptions {
            let segmentioIndicatorOptions = SegmentioIndicatorOptions(
                type: .bottom,
                ratio: 1,
                height: 5,
                color: PrimoColor.Orange.UIColor
            )
            let segmentioHorizontalSeparatorOptions = SegmentioHorizontalSeparatorOptions(
                type: .topAndBottom, // Top, Bottom, TopAndBottom
                height: 0,
                color: .clear
            )
            let segmentioVerticalSeparatorOptions = SegmentioVerticalSeparatorOptions(
                ratio: 0.1, // from 0.1 to 1
                color: .clear
            )
            let segmentioStates = SegmentioStates(
                defaultState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                    titleTextColor: .white
                ),
                selectedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                    titleTextColor: .white
                ),
                highlightedState: SegmentioState(
                    backgroundColor: .clear,
                    titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                    titleTextColor: .white
                )
            )
            return SegmentioOptions(
                backgroundColor: PrimoColor.Green.UIColor,
                maxVisibleItems: 3,
                scrollEnabled: false,
                indicatorOptions: segmentioIndicatorOptions,
                horizontalSeparatorOptions: segmentioHorizontalSeparatorOptions,
                verticalSeparatorOptions: segmentioVerticalSeparatorOptions,
                imageContentMode: .scaleAspectFit,
                labelTextAlignment: .center,
                labelTextNumberOfLines: 1,
                segmentStates: segmentioStates,
                animationDuration: 0.1
            )
        }
        // MARK: Setup
        segmentioView.setup(
            content: Content(),
            style: SegmentioStyle.onlyLabel,
            options: Option()
        )
        segmentioView.selectedSegmentioIndex = 0
        segmentioView.valueDidChange = OnSegmentValueDidChange
    }
    
    func OnSegmentValueDidChange(segmentio: Segmentio, segmentIndex: Int) {
        //print("Selected item: ", segmentIndex)
        if (segmentIndex == 0) {
            BankSelectIndex =  IndexPath(item: -1, section: -1)
            cardType = PrimoCardType.creditCard.rawValue // Select Credit
        }else if(segmentIndex == 1){
            BankSelectIndex =  IndexPath(item: -1, section: -1)
            cardType = PrimoCardType.debitCard.rawValue // Select Debit
        }else {
            BankSelectIndex =  IndexPath(item: -1, section: -1)
            cardType = PrimoCardType.memberCard.rawValue // Select Member
        }
        bankID = -1
//        bankCollection.LoadBankList(cardType: cardType)
//        bankCollection.CallDebit()
        
        bankCollection.SelectBankTypeAndCompany(cardType: cardType)
        

    }
}
