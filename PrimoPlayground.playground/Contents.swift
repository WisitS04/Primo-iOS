//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var json: Array<Any>!
do {
    json = try JSONSerialization.jsonObject(with: JSONData, options: NSJSONReadingOptions()) as? Array
} catch {
    print(error)
}

if let item = json[0] as? [String: AnyObject] {
    if let person = item["person"] as? [String: AnyObject] {
        if let age = person["age"] as? Int {
            print("Dani's age is \(age)")
        }
    }
}