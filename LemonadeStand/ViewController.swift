//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Joshua Robins on 1/14/15.
//  Copyright (c) 2015 Pawswin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var currentDollarAmountLabel: UILabel!
    @IBOutlet weak var currentLemonCountLabel: UILabel!
    @IBOutlet weak var currentIceCubesCountLabel: UILabel!
    
    @IBOutlet weak var numberOfLemonsToBuyLabel: UILabel!
    @IBOutlet weak var numberOfIceCubesToBuyLabel: UILabel!
    @IBOutlet weak var numberOfLemonsToAddLabel: UILabel!
    @IBOutlet weak var numberOfIceCubesToAddLabel: UILabel!
    
    @IBOutlet weak var todaysWeatherIcon: UIImageView!
    
    // Daily user stats
    var currentDollars = 0
    var currentLemons = 0
    var currentIceCubes = 0
    
    // Counter stats
    var numberOfLemonsToBuy = 0
    var numberOfIceCubesToBuy = 0
    var numberOfLemonsToAdd = 0
    var numberOfIceCubesToAdd = 0
    
    // Pricing of ingredients
    let costOfLemons = 2
    let costOfIceCubes = 1
    
    var myLemonadeRatio: Float32 = 1.0
    var dailyCustomers: [Customer] = []
    var dailyEarnings = 0
    var todaysWeather = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        defaultUserStatistics()
        updateUserStats()
        whatIsTodaysWeather()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startDayButtonPressed(sender: UIButton) {
        if numberOfIceCubesToAdd > 0 && numberOfLemonsToAdd > 0 {
            self.myLemonadeRatio = Float(self.numberOfLemonsToAdd) / Float(self.numberOfIceCubesToAdd) // Calculate a new ratio based on mix
            println("Today's lemonade mix ratio: \(myLemonadeRatio)")
            
            createDailyCustomers()
            calculateDailyEarnings()
            
            if dailyCustomers.count > dailyEarnings {
                showAlertWithText(header: "We had \(dailyCustomers.count) visitors today", message: "and you only made $\(dailyEarnings)? You can do better!")
            }
            else {
                showAlertWithText(header: "We had \(dailyCustomers.count) visitors today", message: "and you earned $\(dailyEarnings)! Great job!")
            }
            
            updateUserStats()
            resetCounters()
            whatIsTodaysWeather()
        }
        else {
            showAlertWithText(header: "Inappropriate Mixing", message: "Please make sure you add at least 1 lemon and 1 ice cube to begin mixing lemonade.")
        }
    }
    
    @IBAction func resetGameButtonPressed(sender: UIButton) {
        self.dailyCustomers = []
        defaultUserStatistics()
        resetCounters()
        updateUserStats()
        updateCounters()
    }

    @IBAction func buyLemonsAddButtonPressed(sender: UIButton) {
        if costOfLemons > currentDollars {
            showAlertWithText(header: "Not Enough Money!", message: "You have hit the maximum number of lemons you can purchase with your money. Subtract more ice cubes to buy more lemons.")
        }
        else {
            numberOfLemonsToBuy += 1
            self.currentLemons += 1
            self.currentDollars -= costOfLemons
            updateCounters()
            updateUserStats()
        }
    }
    
    @IBAction func buyLemonsSubtractButtonPressed(sender: UIButton) {
        if numberOfLemonsToBuy == 0 {
            showAlertWithText(header: "Don't Worry Yourself", message: "You have removed all lemons from your shopping basket.")
        }
        else if currentLemons == 0 {
            showAlertWithText(header: "No Lemons to Sell!", message: "You have used all your available lemons.")
        }
        else {
            numberOfLemonsToBuy -= 1
            self.currentLemons -= 1
            self.currentDollars += costOfLemons
            updateCounters()
            updateUserStats()
        }
    }
    
    @IBAction func buyIceCubesAddButtonPressed(sender: UIButton) {
        if costOfIceCubes > currentDollars {
            showAlertWithText(header: "Not Enough Money!", message: "You have hit the maximum number of ice cubes you can purchase with your money. Subtract more lemons to buy more ice cubes.")
        }
        else {
            numberOfIceCubesToBuy += 1
            self.currentIceCubes += 1
            self.currentDollars -= costOfIceCubes
            updateCounters()
            updateUserStats()
        }
    }
    
    @IBAction func buyIceCubesSubtractButtonPressed(sender: UIButton) {
        if numberOfIceCubesToBuy == 0 {
            showAlertWithText(header: "Don't Worry Yourself", message: "You have removed all ice cubes from your shopping basket.")
        }
        else if currentIceCubes == 0 {
            showAlertWithText(header: "No Ice to Sell!", message: "You have used all your available ice cubes.")
        }
        else {
            numberOfIceCubesToBuy -= 1
            self.currentIceCubes -= 1
            self.currentDollars += costOfIceCubes
            updateCounters()
            updateUserStats()
        }
    }
    
    @IBAction func addLemonsAddButtonPressed(sender: UIButton) {
        if currentLemons > 0 {
            numberOfLemonsToAdd += 1
            self.currentLemons -= 1
            updateCounters()
            updateUserStats()
        }
        else {
            showAlertWithText(header: "Not Enough Lemons!", message: "You have no more lemons to use. Buy some more!")
        }
    }
    
    @IBAction func addLemonsSubtractButtonPressed(sender: UIButton) {
        if numberOfLemonsToAdd == 0 {
            showAlertWithText(header: "Don't Worry Yourself", message: "You have removed all lemons from your lemonade mix.")
        }
        else {
            numberOfLemonsToAdd -= 1
            self.currentLemons += 1
            updateCounters()
            updateUserStats()
        }
    }
    
    @IBAction func addIceCubesAddButtonPressed(sender: UIButton) {
        if currentIceCubes > 0 {
            numberOfIceCubesToAdd += 1
            self.currentIceCubes -= 1
            updateCounters()
            updateUserStats()
        }
        else {
            showAlertWithText(header: "Not Enough Ice Cubes!", message: "You have no more ice cubes to use. Buy some more!")
        }
    }
    
    @IBAction func addIceCubesSubtractButtonPressed(sender: UIButton) {
        if numberOfIceCubesToAdd == 0 {
            showAlertWithText(header: "Don't Worry Yourself", message: "You have removed all ice cubes from your lemonade mix.")
        }
        else {
            numberOfIceCubesToAdd -= 1
            self.currentIceCubes += 1
            updateCounters()
            updateUserStats()
        }
    }
    
    func defaultUserStatistics() {
        self.currentDollars = 10
        self.currentLemons = 0
        self.currentIceCubes = 0
    }
    
    func resetCounters() {
        self.numberOfLemonsToBuy = 0
        self.numberOfIceCubesToBuy = 0
        self.numberOfLemonsToAdd = 0
        self.numberOfIceCubesToAdd = 0
        
        updateCounters()
    }
    
    func updateUserStats() {
        currentDollarAmountLabel.text = "$ \(currentDollars)"
        currentLemonCountLabel.text = "\(currentLemons) Lemon(s)"
        currentIceCubesCountLabel.text = "\(currentIceCubes) Ice Cube(s)"
    }
    
    func updateCounters() {
        numberOfLemonsToBuyLabel.text = "\(numberOfLemonsToBuy)"
        numberOfLemonsToAddLabel.text = "\(numberOfLemonsToAdd)"
        numberOfIceCubesToBuyLabel.text = "\(numberOfIceCubesToBuy)"
        numberOfIceCubesToAddLabel.text = "\(numberOfIceCubesToAdd)"
    }
    
    func showAlertWithText (header: String = "Warning", message: String) {
        // Initially set the header, gives us a default option
        // Can be overridden or can be ignored
        
        var alert = UIAlertController(title: header, message: message, preferredStyle: UIAlertControllerStyle.Alert) // Creates an alert instance
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)) // Gives the user a way to dismiss the alert
        self.presentViewController(alert, animated: true, completion: nil) // Displays the alert, does not require an action after it is dismissed
    }
    
    func createDailyCustomers() {
        var randomNumberOfCustomers = 0
        
        if todaysWeather == "Cold" {
            randomNumberOfCustomers = Int(arc4random_uniform(UInt32(5)))
        }
        else if todaysWeather == "Mild" {
            randomNumberOfCustomers = Int(arc4random_uniform(UInt32(10)))
        }
        else {
            randomNumberOfCustomers = Int(arc4random_uniform(UInt32(15)))
        }
        
        for var numberOfCustomers = 0; numberOfCustomers < randomNumberOfCustomers+1; numberOfCustomers++ {
            
            var cust = Customer()
            var randomTastePreference = Int(arc4random_uniform(UInt32(10)))
            cust.tastePreference = 0.1 * Float(randomTastePreference+1)

            // 0 to 0.4 favors acidic lemonade
            // 0.4 to 0.6 favors equal parts lemonade
            // 0.6 to 1.0 favors diluted lemonade
            
            self.dailyCustomers.append(cust)
            
            println("customer created and added to the array! taste pref: \(cust.tastePreference)")
        }
        
    }
    
    func calculateDailyEarnings() {
        for var i = 0; i < self.dailyCustomers.count; i++ {
            
            if dailyCustomers[i].tastePreference < 0.4 {
                if myLemonadeRatio > 1.0 {
                    if todaysWeather == "Warm" {
                        self.dailyEarnings += 2
                        println("Paid $2")
                    }
                    else {
                        self.dailyEarnings += 1
                        println("Paid $1")
                    }
                }
                else {
                    println("Yuck, too diluted!")
                }
            }
            else if dailyCustomers[i].tastePreference >= 0.4 && dailyCustomers[i].tastePreference < 0.6 {
                if myLemonadeRatio == 1.0 {
                    if todaysWeather == "Warm" {
                        self.dailyEarnings += 2
                        println("Paid $2")
                    }
                    else {
                        self.dailyEarnings += 1
                        println("Paid $1")
                    }
                }
                else {
                    println("I want balanced lemonade!")
                }
            }
            else { // customer's taste preference is 0.6 to 1.0
                if myLemonadeRatio < 1.0 {
                    if todaysWeather == "Warm" {
                        self.dailyEarnings += 2
                        println("Paid $2")
                    }
                    else {
                        self.dailyEarnings += 1
                        println("Paid $1")
                    }
                }
                else {
                    println("Too acidic!")
                }
            }
        }
        
        currentDollars += dailyEarnings
    }
    
    func whatIsTodaysWeather() {
        let randomNumber = Int(arc4random_uniform(UInt32(3)))
        
        switch (randomNumber+1) {
        case 1:
            self.todaysWeather = "Cold"
        case 2:
            self.todaysWeather = "Mild"
        default:
            self.todaysWeather = "Warm"
        }
        
        todaysWeatherIcon.image = UIImage(named: todaysWeather)
    }
    
    
    
    
    
    
    
    
    
}

