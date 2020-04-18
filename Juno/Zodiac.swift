//
//  Zodiac.swift
//  Juno
//
//  Created by Cicely Beckford on 4/14/20.
//  Copyright © 2020 Cicely Beckford. All rights reserved.
//

import Foundation

class Zodiac {
    
    var signs: [String: [Date]] = ["Aries": [Date("2020-03-21"), Date("2020-04-19")], "Taurus": [Date("2020-04-20"), Date("2020-05-20")], "Gemini": [Date("2020-05-21"), Date("2020-06-20")], "Cancer": [Date("2020-06-21"), Date("2020-07-22")], "Leo": [Date("2020-07-23"), Date("2020-08-22")], "Virgo": [Date("2020-08-23"), Date("2020-09-22")], "Libra": [Date("2020-09-23"), Date("2020-10-22")], "Scorpio": [Date("2020-10-23"), Date("2020-11-21")], "Sagittarius": [Date("2020-11-22"), Date("2020-12-21")], "Capricorn": [Date("2020-12-22"), Date("2020-01-19")], "Aquarius": [Date("2020-01-20"), Date("2020-02-18")], "Pisces": [Date("2020-02-19"), Date("2020-03-20")]]
    
    init() {
        
    }
   
    func getSunSign(date: Date) -> String {
        
        print(signs["Aries"]![0])
        print(signs["Aries"]![1])
        
        if date.isBetweeen(date: signs["Aries"]![0], andDate: signs["Aries"]![1]) {
            return "Aries"
        } else if date.isBetweeen(date: signs["Taurus"]![0], andDate: signs["Taurus"]![1]) {
            return "Taurus"
        } else if date.isBetweeen(date: signs["Gemini"]![0], andDate: signs["Gemini"]![1]) {
            return "Gemini"
        } else if date.isBetweeen(date: signs["Cancer"]![0], andDate: signs["Cancer"]![1]) {
            return "Cancer"
        } else if date.isBetweeen(date: signs["Leo"]![0], andDate: signs["Leo"]![1]) {
            return "Leo"
        } else if date.isBetweeen(date: signs["Virgo"]![0], andDate: signs["Virgo"]![1]) {
            return "Virgo"
        } else if date.isBetweeen(date: signs["Libra"]![0], andDate: signs["Libra"]![1]) {
            return "Libra"
        } else if date.isBetweeen(date: signs["Scorpio"]![0], andDate: signs["Scorpio"]![1]) {
            return "Scorpio"
        } else if date.isBetweeen(date: signs["Sagittarius"]![0], andDate: signs["Sagittarius"]![1]) {
            return "Sagittarius"
        } else if date.isBetweeen(date: signs["Aquarius"]![0], andDate: signs["Aquarius"]![1]) {
            return "Aquarius"
        } else if date.isBetweeen(date: signs["Pisces"]![0], andDate: signs["Pisces"]![1]) {
            return "Pisces"
        }
        return "Capricorn"
    }
    
    func getCompatibility(first sign1: String, second sign2: String) -> String {
        if sign1 == "Aries" {
            switch(sign2) {
                case "Taurus" :
                    return "50%"
                case "Gemini" :
                    return "85%"
                case "Cancer" :
                    return "65%"
                case "Leo" :
                    return "95%"
                case "Virgo" :
                    return "55%"
                case "Libra" :
                    return "55%"
                case "Scorpio" :
                    return "75%"
                case "Sagittarius" :
                    return "100%"
                case "Capricorn" :
                    return "40%"
                case "Aquarius" :
                    return "90%"
                case "Pisces" :
                    return "65%"
                default:
                    return "50%"
            }
        } else if sign1 == "Taurus" {
            switch(sign2) {
                case "Aries" :
                    return "50%"
                case "Gemini" :
                    return "40%"
                case "Cancer" :
                    return "85%"
                case "Leo" :
                    return "70%"
                case "Virgo" :
                    return "90%"
                case "Libra" :
                    return "65%"
                case "Scorpio" :
                    return "75%"
                case "Sagittarius" :
                    return "40%"
                case "Capricorn" :
                    return "100%"
                case "Aquarius" :
                    return "40%"
                case "Pisces" :
                    return "85%"
                default:
                    return "100%"
            }
        } else if sign1 == "Gemini" {
            switch(sign2) {
                case "Aries" :
                    return "85%"
                case "Taurus" :
                    return "40%"
                case "Cancer" :
                    return "45%"
                case "Leo" :
                    return "90%"
                case "Virgo" :
                    return "60%"
                case "Libra" :
                    return "95%"
                case "Scorpio" :
                    return "50%"
                case "Sagittarius" :
                    return "75%"
                case "Capricorn" :
                    return "60%"
                case "Aquarius" :
                    return "100%"
                case "Pisces" :
                    return "45%"
                default:
                    return "60%"
            }
        } else if sign1 == "Cancer" {
            switch(sign2) {
                case "Aries" :
                    return "65%"
                case "Taurus" :
                    return "85%"
                case "Gemini" :
                    return "45%"
                case "Leo" :
                    return "85%"
                case "Virgo" :
                    return "75%"
                case "Libra" :
                    return "65%"
                case "Scorpio" :
                    return "90%"
                case "Sagittarius" :
                    return "45%"
                case "Capricorn" :
                    return "60%"
                case "Aquarius" :
                    return "40%"
                case "Pisces" :
                    return "100%"
                default:
                    return "80%"
            }
        } else if sign1 == "Leo" {
            switch(sign2) {
                case "Aries" :
                    return "95%"
                case "Taurus" :
                    return "70%"
                case "Gemini" :
                    return "90%"
                case "Cancer" :
                    return "85%"
                case "Virgo" :
                    return "50%"
                case "Libra" :
                    return "100%"
                case "Scorpio" :
                    return "40%"
                case "Sagittarius" :
                    return "90%"
                case "Capricorn" :
                    return "50%"
                case "Aquarius" :
                    return "55%"
                case "Pisces" :
                    return "60%"
                default:
                    return "50%"
            }
        } else if sign1 == "Virgo" {
            switch(sign2) {
                case "Aries" :
                    return "55%"
                case "Taurus" :
                    return "90%"
                case "Gemini" :
                    return "60%"
                case "Cancer" :
                    return "75%"
                case "Leo" :
                    return "50%"
                case "Libra" :
                    return "40%"
                case "Scorpio" :
                    return "70%"
                case "Sagittarius" :
                    return "40%"
                case "Capricorn" :
                    return "100%"
                case "Aquarius" :
                    return "55%"
                case "Pisces" :
                    return "65%"
                default:
                    return "95%"
            }
        } else if sign1 == "Libra" {
            switch(sign2) {
                case "Aries" :
                    return "55%"
                case "Taurus" :
                    return "65%"
                case "Gemini" :
                    return "95%"
                case "Cancer" :
                    return "65%"
                case "Leo" :
                    return "100%"
                case "Virgo" :
                    return "40%"
                case "Scorpio" :
                    return "50%"
                case "Sagittarius" :
                    return "95%"
                case "Capricorn" :
                    return "55%"
                case "Aquarius" :
                    return "90%"
                case "Pisces" :
                    return "50%"
                default:
                    return "80%"
            }
        } else if sign1 == "Scorpio" {
            switch(sign2) {
                case "Aries" :
                    return "75%"
                case "Taurus" :
                    return "75%"
                case "Gemini" :
                    return "50%"
                case "Cancer" :
                    return "90%"
                case "Leo" :
                    return "40%"
                case "Virgo" :
                    return "70%"
                case "Libra" :
                    return "50%"
                case "Sagittarius" :
                    return "40%"
                case "Capricorn" :
                    return "95%"
                case "Aquarius" :
                    return "45%"
                case "Pisces" :
                    return "100%"
                default:
                    return "70%"
            }
        } else if sign1 == "Sagittarius" {
            switch(sign2) {
                case "Aries" :
                    return "100%"
                case "Taurus" :
                    return "40%"
                case "Gemini" :
                    return "75%"
                case "Cancer" :
                    return "45%"
                case "Leo" :
                    return "90%"
                case "Virgo" :
                    return "40%"
                case "Libra" :
                    return "95%"
                case "Scorpio" :
                    return "40%"
                case "Capricorn" :
                    return "60%"
                case "Aquarius" :
                    return "95%"
                case "Pisces" :
                    return "40%"
                default:
                    return "85%"
            }
        } else if sign1 == "Sagittarius" {
            switch(sign2) {
                case "Aries" :
                    return "100%"
                case "Taurus" :
                    return "40%"
                case "Gemini" :
                    return "75%"
                case "Cancer" :
                    return "45%"
                case "Leo" :
                    return "90%"
                case "Virgo" :
                    return "40%"
                case "Libra" :
                    return "95%"
                case "Scorpio" :
                    return "40%"
                case "Capricorn" :
                    return "60%"
                case "Aquarius" :
                    return "95%"
                case "Pisces" :
                    return "40%"
                default:
                    return "85%"
            }
        } else if sign1 == "Capricorn" {
            switch(sign2) {
                case "Aries" :
                    return "40%"
                case "Taurus" :
                    return "100%"
                case "Gemini" :
                    return "60%"
                case "Cancer" :
                    return "60%"
                case "Leo" :
                    return "50%"
                case "Virgo" :
                    return "100%"
                case "Libra" :
                    return "55%"
                case "Scorpio" :
                    return "95%"
                case "Sagittarius" :
                    return "60%"
                case "Aquarius" :
                    return "60%"
                case "Pisces" :
                    return "100%"
                default:
                    return "75%"
            }
        } else if sign1 == "Aquarius" {
            switch(sign2) {
                case "Aries" :
                    return "90%"
                case "Taurus" :
                    return "40%"
                case "Gemini" :
                    return "100%"
                case "Cancer" :
                    return "40%"
                case "Leo" :
                    return "55%"
                case "Virgo" :
                    return "55%"
                case "Libra" :
                    return "90%"
                case "Scorpio" :
                    return "45%"
                case "Sagittarius" :
                    return "95%"
                case "Capricorn" :
                    return "60%"
                case "Pisces" :
                    return "50%"
                default:
                    return "80%"
            }
        } else if sign1 == "Pisces" {
            switch(sign2) {
                case "Aries" :
                    return "65%"
                case "Taurus" :
                    return "85%"
                case "Gemini" :
                    return "45%"
                case "Cancer" :
                    return "100%"
                case "Leo" :
                    return "60%"
                case "Virgo" :
                    return "65%"
                case "Libra" :
                    return "50%"
                case "Scorpio" :
                    return "100%"
                case "Sagittarius" :
                    return "40%"
                case "Capricorn" :
                    return "100%"
                case "Aquarius" :
                    return "50%"
                default:
                    return "75%"
            }
        }
        return ""
    }
}

extension Date {
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
    
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self).rawValue * self.compare(date2).rawValue >= 0
    }
}
