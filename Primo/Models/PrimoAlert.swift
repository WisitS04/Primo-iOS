
class PrimoAlert {
    // Global
    func Error() {
        let title = "Oops!"
        let desc = "มีบางอย่างผิดปกติเกิดขึ้น กรุณาลองใหม่อีกครั้ง"
        _ = SweetAlert().showAlert(title, subTitle: desc, style: .warning)
    }
    // Nearby page
    func NoInternet() {
        let title = "ไม่สามารถเชื่อมต่ออินเตอร์เนต"
        let desc = "โปรดตรวจสอบการเชื่อมต่อ และลองใหม่อีกครั้ง"
        _ = SweetAlert().showAlert(title, subTitle: desc, style: .warning)
    }
    func GetLocationError() {
        let title = "ไม่สามารถเชื่อมต่อสัญญาณจีพีเอส"
        let desc = "กรุณาเปิดบริการหาตำแหน่งที่ตั้ง (GPS)"
        _ = SweetAlert().showAlert(title, subTitle: desc, style: .warning)
    }
    // Shoping Detail page
    func PriceNotFound() {
        let title = "ไม่พบยอดใช้จ่าย"
        let desc = "โปรดใส่ยอดใช้จ่าย"
        _ = SweetAlert().showAlert(title, subTitle: desc, style: .warning)
    }
    // Add Member page
    func AddMemberSuccess(cardName: String) {
        let title = "เพิ่มบัตรเรียบร้อย!"
        let desc = String(format: "พรีโมได้จัดเก็บบัตร %@ เข้าบัญชีบัตรของคุณ", cardName)
        _ = SweetAlert().showAlert(title, subTitle: desc, style: .success)
    }
    // Deal Detail page
    func SmsDetail(desc: String, number: String, action: ((Bool) -> Void)?) {
        let title = "วิธีการรับสิทธิ์"
        let btn: String!
//        _ = SweetAlert().showAlert(
//            title, subTitle: desc, style: AlertStyle.none,
//            buttonTitle:"ยกเลิก", buttonColor: UIColor.darkGray,
//            otherButtonTitle:  "ส่ง", otherButtonColor: PrimoColor.Red.UIColor,
//            action: action)
        
        if(number[0] == "*"){
            btn = "OK"
        }else{
            btn = "SEND"
        }
    
//        _ = SweetAlert().showAlert(
//            title,
//            subTitle: desc,
//            style: AlertStyle.none,
//            buttonTitle:btn,
//            action: action)
        
        _ = SweetAlert().showAlert(title,
                                   subTitle: desc,
                                   style: AlertStyle.none,
                                   buttonTitle:"Cancel",
                                   buttonColor:UIColor.darkGray,
                                   otherButtonTitle:  btn,
                                   action: action)

    }
    

}
