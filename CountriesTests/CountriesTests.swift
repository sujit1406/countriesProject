//
//  CountriesTests.swift
//  CountriesTests
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import XCTest
@testable import Countries

class CountriesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearchCountriesMethod() {
        let presenter = OnlineSearchPresenter()
        presenter.searchCountriesWithKeyWord(key: "United States of America"){
            if let extracted = presenter.filteredTableData?.count{
            let expected = 1
            XCTAssertEqual(extracted, expected, "Failed to extract full entities")
            }
        }
      
    }

    
    func testSearchAPI() {
         let expect = self.expectation(description: "India")
         let expect1 = self.expectation(description: "UAE")
         let expect2 = self.expectation(description: "United States of America")
         let expect3 = self.expectation(description: "Australia")
        
    APIClient.getCountriesList(keyword: "India") { (result) in
            if let resultvalue = result.value{
            let country:Country = resultvalue[1]
            let extracted = resultvalue.count
            let expected = 2
            expect.fulfill()
            XCTAssertEqual(extracted, expected, "Failed to extract full entities")
            XCTAssertEqual(country.name,"India","Search Country Failed")
                
            }
        }
        
        APIClient.getCountriesList(keyword: "UAE") { (result) in
            if let resultvalue = result.value{
                let country:Country = resultvalue[0]
                let extracted = resultvalue.count
                let expected = 1
                 expect1.fulfill()
                XCTAssertEqual(extracted, expected, "Failed to extract full entities")
                XCTAssertEqual(country.name,"United Arab Emirates","Search Country Failed")
            }
        }
        
        
        APIClient.getCountriesList(keyword: "United States of America") { (result) in
            if let resultvalue = result.value{
                let country:Country = resultvalue[0]
                let extracted = resultvalue.count
                let expected = 1
                 expect2.fulfill()
                XCTAssertEqual(extracted, expected, "Failed to extract full entities")
                XCTAssertEqual(country.name,"United States of America","Search Country Failed")
            }
        }
        
        
        APIClient.getCountriesList(keyword: "Australia") { (result) in
            if let resultvalue = result.value{
                let country:Country = resultvalue[0]
                let extracted = resultvalue.count
                let expected = 1
                expect3.fulfill()
                XCTAssertEqual(extracted, expected, "Failed to extract full entities")
                XCTAssertEqual(country.name,"Australia","Search Country Failed")
            }
        }
        
         waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testSVGImageAPI(){
        let img1 = "https://restcountries.eu/data/col.svg"
        let img2 = "https://restcountries.eu/data/ind.svg"
        let img3 = "https://restcountries.eu/data/usa.svg"
       
        
        let exp1 = self.expectation(description: "col")
        let exp2 = self.expectation(description: "ind")
        let exp3 = self.expectation(description: "usa")
        
        
        let presenter = OnlineSearchPresenter()
        presenter.getSVGImage(url: img1) { (image) in
            exp1.fulfill()
            if(image != nil){
            XCTAssert(true,"Image Exists")
            }
            
        }
        
        presenter.getSVGImage(url: img2) { (image) in
             exp2.fulfill()
            if(image != nil){
                XCTAssert(true,"Image Exists")
            }
        }
        
        presenter.getSVGImage(url: img3) { (image) in
             exp3.fulfill()
            if(image != nil){
                XCTAssert(true,"Image Exists")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
            
    }
    
    
    func testCoreData(){
        
        let presenter = OnlineSearchPresenter()
        
        let expect = self.expectation(description: "Australia")
        APIClient.getCountriesList(keyword: "Australia") { (result) in
            if let resultvalue = result.value{
                
                let country:Country = resultvalue[0]
                let expected = 1
                presenter.getSVGImage(url: country.flagImageURL, completion: { (image) in
                    expect.fulfill()
                    country.flagImage = image
                    
                    let detailPresenter = CountryDetailsPresenter()
                    detailPresenter.currentCountry = country
                    
                    detailPresenter.saveCurrentCountryInDB()
                    //test for duplicate entry
                    detailPresenter.saveCurrentCountryInDB()
                    
                    
                    presenter.loadSavedCountries()
                    let extracted = presenter.filteredTableData?.count
                    if(extracted == 0){
                          XCTAssert(false,"Failed to get any entry")
                    }
                    
                    XCTAssertEqual(extracted,expected,"Loaded duplicate entry")
                    
                })
                
               
                
            }
            else{
                XCTAssert(false,"Failed to get any entry")
            }
        }
        
         waitForExpectations(timeout: 5, handler: nil)
    }
}
