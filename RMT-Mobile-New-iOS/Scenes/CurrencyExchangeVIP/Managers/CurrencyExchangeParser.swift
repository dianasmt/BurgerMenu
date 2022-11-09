//
//  CurrencyRateParser.swift
//  RMT-Mobile-New-iOS
//
//  Created by Диана Смахтина on 30.08.2022.
//

import Foundation
import RxSwift
import RxRelay

protocol CurrencyExchangeParser {
    func getRates() -> Observable<[CurrencyRateModel]>
}

final class CurrencyExchangeXMLParser: NSObject, XMLParserDelegate, CurrencyExchangeParser {
    private let parser: XMLParser
    private let parsedModels = BehaviorRelay<[CurrencyRateModel]>(value: [])
    private enum ParserKeys {
        static let recordKey = "Valute"
        static let numCode = "NumCode"
        static let charCode = "CharCode"
        static let nominal = "Nominal"
        static let name = "Name"
        static let value = "Value"
    }
    
    private var xmlCurrencyDataDictionary = [String: Any]()
    private var currentElement = String.empty
    
    init(parser: XMLParser){
        self.parser = parser
        super.init()
        parser.delegate = self
        parser.parse()
    }
    
    func getRates() -> Observable<[CurrencyRateModel]> {
        return parsedModels.asObservable()
    }
    
    func parser(_ parser: XMLParser,
                         didStartElement elementName: String,
                         namespaceURI: String?,
                         qualifiedName qName: String?,
                         attributes attributeDict: [String : String] = [:]) {
        if elementName == ParserKeys.recordKey {
            xmlCurrencyDataDictionary = [:]
        } else {
            currentElement = elementName
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            if xmlCurrencyDataDictionary[currentElement] == nil {
                xmlCurrencyDataDictionary.updateValue(string, forKey: currentElement)
            }
        }
    }
    
    func parser(_ parser: XMLParser,
                         didEndElement elementName: String,
                         namespaceURI: String?,
                         qualifiedName qName: String?) {
        if elementName == ParserKeys.recordKey {
            addParsedModel(from: xmlCurrencyDataDictionary)
        }
    }
    
    private func addParsedModel(from valuesDict: [String : Any]) {
        if let strNumCode = valuesDict[ParserKeys.numCode] as? String,
           let numCode = Int(strNumCode),
           let charCode = valuesDict[ParserKeys.charCode] as? String,
           let strNominal = valuesDict[ParserKeys.nominal] as? String,
           let nominal = Int(strNominal),
           let name = valuesDict[ParserKeys.name] as? String,
           let strValue = valuesDict[ParserKeys.value] as? String,
           let value = Double(strValue.replacingOccurrences(of: ",", with: "."))
        {
            let model = CurrencyRateModel(numCode: numCode, charCode: charCode, nominal: nominal, name: name, value: value)
            parsedModels.accept(parsedModels.value + [model])
        }
    }
}
