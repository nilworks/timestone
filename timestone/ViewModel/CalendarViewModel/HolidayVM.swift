//
//  HolidayVM.swift
//  timestone
//
//  Created by 조성빈 on 1/6/25.
//

import Foundation

class HolidayVM: ObservableObject {
    let baseURL = "https://apis.data.go.kr/B090041/openapi/service/SpcdeInfoService/getRestDeInfo"
    let privateKey: String = Bundle.main.object(forInfoDictionaryKey: "HolidayKey") as? String ?? ""
    
    @Published var holidays: [Holiday] = []
    
    func load(year: Int) {
        let urlString = "\(baseURL)?ServiceKey=\(privateKey)&solYear=\(year)&numOfRows=50"
        
        guard let url = URL(string: urlString) else {
            print("잘못된 URL입니다.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("에러 발생: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("데이터 없음")
                return
            }
            
            // XML 파싱
            let parser = HolidayParser()
            let holidays = parser.parse(data: data)
            
            DispatchQueue.main.async {
                for holiday in holidays {
                    self.holidays.append(holiday)
                    print("날짜: \(holiday.locdate), 공휴일 명: \(holiday.dateName), 공휴일 유무: \(holiday.isHoliday)")
                }
            }
        }.resume()
    }
}


class HolidayParser: NSObject, XMLParserDelegate {
    private var holidays: [Holiday] = []
    private var currentElement = ""
    private var currentDateName = ""
    private var currentIsHoliday = false
    private var currentLocDate = ""

    func parse(data: Data) -> [Holiday] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return holidays
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentDateName = ""
            currentIsHoliday = false
            currentLocDate = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "dateName":
            currentDateName += string
        case "isHoliday":
            currentIsHoliday = string == "Y"
        case "locdate":
            currentLocDate += string
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let holiday = Holiday(dateName: currentDateName, isHoliday: currentIsHoliday, locdate: currentLocDate)
            holidays.append(holiday)
        }
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        print("XML 파싱 완료")
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("XML 파싱 에러: \(parseError.localizedDescription)")
    }
}
