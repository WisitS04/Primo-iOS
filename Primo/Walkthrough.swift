//
//  Walkthrough.swift
//  Primo
//
//  Created by Macmini on 9/1/2560 BE.
//  Copyright © 2560 Primo World Co., Ltd. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Segmentio

class Walkthrough: UIViewController
{
 var pagerView: FSPagerView!
 var pageControl: FSPageControl!

    
 var numberOfPage: Int = 4
 var buttonLink = UIButton()
var ViewPage = UIView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setBG()
        AddFSPage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
}

extension Walkthrough{
    
    func setBG(){

        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg_walkthrough")
        self.view.insertSubview(backgroundImage, at: 0)
        
//        let imageName = "bg_walkthrough"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        imageView.contentMode = .scaleAspectFill
////        view_page.addSubview(imageView)
//
//        let viewSize = UIScreen.main.bounds
//        ViewPage.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
//        ViewPage.center = view.center
////        ViewPage.backgroundColor = UIColor.blue
//        ViewPage.alpha = 1
//        ViewPage.addSubview(imageView)
        
    }
    //
    func AddFSPage() {

        let viewSize = UIScreen.main.bounds
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = self.navigationController?.navigationBar.bounds.height ?? 0.0


        

//        mainView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
//        mainView.center = view.center

        
        func AddFSPager() {
            let pagerFrame = CGRect( x: 0,y: 0,width: viewSize.width,height: viewSize.height-100)
            let position = CGPoint(x: viewSize.width / 2, y: viewSize.height/2 )
            self.pagerView = FSPagerView(frame: pagerFrame)
            self.pagerView.center = position
//            self.pagerView.backgroundColor = UIColor.black
            self.pagerView.dataSource = self
            self.pagerView.delegate = self
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.itemSize = CGSize(width: viewSize.width, height: viewSize.height-100)
//            self.pagerView.itemSize = CGSize(width: viewSize.width-50, height: viewSize.height-100)
            
            self.pagerView.collectionView.allowsSelection = false
//            self.pagerView.interitemSpacing = 60
            self.pagerView.interitemSpacing = 0
            self.view.addSubview(self.pagerView)
        }
        func AddFSPageControl() {
            let pageControlFrame = CGRect(
                x: 0,
                y: 0,
                width: 20,
                height: 80)
            
            let position = CGPoint(x: viewSize.width / 2,
                                   y: viewSize.height/1.05)
            
            self.pageControl = FSPageControl(frame: pageControlFrame)
            self.view.addSubview(self.pageControl)
            self.pageControl.numberOfPages = numberOfPage
            self.pageControl.center = position
//            self.pageControl.contentHorizontalAlignment = .center
            self.pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            self.pageControl.setStrokeColor(UIColor.white, for: .normal)
            self.pageControl.setStrokeColor(UIColor.white, for: .selected)
            self.pageControl.setFillColor(UIColor.white, for: .selected)
   
        }
        
        func addButton(){
            buttonLink = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 35))
            
            buttonLink.center = CGPoint(x: viewSize.width / 2,
                                        y: viewSize.height/1.08)
            
            buttonLink.layer.cornerRadius = 5
            buttonLink.setTitleColor(HexStringToUIColor(hex: PrimoColor.Green.rawValue), for: .normal)
            buttonLink.setTitle("เริ่มกันเลย", for: .normal)
            buttonLink.backgroundColor = UIColor.white
//            buttonLink.setBackgroundImage(UIImage(named: "start_button"), for: .normal)
            buttonLink.addTarget(self, action: #selector(sendActionData), for: .touchUpInside)
//            self.pagerView.addSubview(buttonLink)
            self.view.addSubview(buttonLink)
        }
        addButton()
        AddFSPager()
        AddFSPageControl()
    }
    
    @objc func sendActionData(_ sender: Any)  {
        
         VersionNumber.set(cerrentVersin,forKey: KEYAppVersion)

        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlaceViewController") as! PlaceViewController
        self.navigationController?.pushViewController(secondViewController, animated: true)

    }
   
}



extension Walkthrough: FSPagerViewDelegate, FSPagerViewDataSource
{
    
    
    // MARK: DataSource
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return numberOfPage
    }
    
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = 0.1
        cell.layer.cornerRadius = 5
        
        var imageName = ""

        if(index == 0){
           imageName = "walkthrough_one"
           setHide_btn(index : index , imageName: imageName)
        }else if(index == 1){
           imageName = "walkthrough_two"
           setHide_btn(index : index , imageName: imageName)
        }else if(index == 2){
           imageName = "walkthrough_three"
           setHide_btn(index : index , imageName: imageName)
        }else{
           imageName = "walkthrough_four"
           setHide_btn(index: index, imageName: imageName)
        }

        
        cell.imageView?.image = UIImage(named: imageName)
        cell.imageView?.contentMode = .scaleAspectFit

        cell.contentView.layer.shadowOpacity = 0.0
        
        return cell
    }
    
    func setHide_btn(index : Int, imageName: String){
//        let name: String?
//        let number: Int?
//        
//        name = imageName
//        number = index
//        
        if(index == 0){
           buttonLink.isHidden = true
           pageControl.isHidden = false
        }else if(index == 1){
           buttonLink.isHidden = true
        pageControl.isHidden = false
        }else if(index == 2){
            buttonLink.isHidden = true
            pageControl.isHidden = false
         }else{
            pageControl.isHidden = true
            buttonLink.isHidden = false
        }
        
    }
    
    // MARK: Delegate
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
        guard self.pageControl.currentPage != targetIndex else {
            return
        }
        
        print("pagerViewWillEndDragging -> pagerView.currentIndex = \(pagerView.currentIndex) | targetIndex = \(targetIndex)")
        self.pageControl.currentPage = targetIndex // Or Use KVO with property "currentIndex"
//        self.networkID = cardNetworkList[targetIndex].id
//        self.cardResultTable.LoadData(bankId: self.bankID,
//                                      cardType: self.cardType,
//                                      cardNetwork: self.networkID)
    }
}
