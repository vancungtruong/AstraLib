//
//  UpgradeToPremiumViewController.swift
//  SpamDetector
//  Copyright © 2018 astraler. All rights reserved.
//

import UIKit
import AstraLib

class UpgradeToPremiumViewController: BaseViewController {
    
    static weak var current: UpgradeToPremiumViewController?
    
    @IBOutlet weak var monthlyButton: UIButton?
    @IBOutlet weak var yearlyButton: UIButton?
    @IBOutlet weak var lifetimeButton: UIButton?
    @IBOutlet weak var closeButton: UIButton?
    
    @IBOutlet weak var closeButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var monthlyTitleLabel: UILabel!
    @IBOutlet weak var monthlyPriceLabel: UILabel!
    
    @IBOutlet weak var yearlyTitleLabel: UILabel!
    @IBOutlet weak var yearlyPriceLabel: UILabel!
    
    @IBOutlet weak var lifetimePriceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpgradeToPremiumViewController.current = self
        
        getIAPProductsInfo()
        updatePricePackages()
        
        if #available(iOS 13.0, *) {
        } else {
            if let topLayout = UIApplication.shared.keyWindow?.safeAreaInsets.top {
                closeButtonTopConstraint.constant = topLayout
            }
        }
        
    }
    
    // MARK: -
    
    private func updatePricePackages() {
        updateMonthlyPrice()
        updateYearlyPrice()
        updateLifetimePrice()
    }
    
    private func updateMonthlyPrice() {
        
        guard let _ = monthlyButton else { return }
        
        let monthly = PurchaseProduct.monthly
        var price = monthly.priceStringDefault
        //var currencySymbol = "$"
        
        if let product = purchaseKit.productsInfo[monthly.rawValue] {
            if let priceString = product.localizedPrice {
                price = priceString.replacingOccurrences(of: ",", with: "")
                
//                if let currencySymbolString =  product.priceLocale.currencySymbol {
//                    currencySymbol = currencySymbolString
//                }
                
//                let behavior = NSDecimalNumberHandler(roundingMode: .down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
//                let monPriceNumber = product.price.dividing(by: NSDecimalNumber(decimal: 1.0), withBehavior: behavior)
//
//                let currencyFormatter = NumberFormatter()
//                        currencyFormatter.usesGroupingSeparator = true
//                        currencyFormatter.numberStyle = .currency
//                currencyFormatter.locale = product.priceLocale
//                pricePerMonth = currencyFormatter.string(from: monPriceNumber) ?? pricePerMonth
            }

            if product.hasFreeTrial {
                monthlyTitleLabel.text = "3-day free trial"
                monthlyPriceLabel.text = "then \(price) / month."
            } else {
                monthlyTitleLabel.text = "Monthly"
                monthlyPriceLabel.text = "\(price) / month."
            }
        } else {
            monthlyTitleLabel.text = "Monthly"
            monthlyPriceLabel.text = "\(price) per month"
        }
    }
    
    private func updateYearlyPrice() {
        
        guard let _ = yearlyButton else { return }
        
        let yearly = PurchaseProduct.yearly
        var price = yearly.priceStringDefault
        //var currencySymbol = "$"
//        var pricePerMonth = yearly.pricePerMonString
        
        if let product = purchaseKit.productsInfo[yearly.rawValue] {
            if let priceString = product.localizedPrice {
                price = priceString.replacingOccurrences(of: ",", with: "")
                
//                if let currencySymbolString =  product.priceLocale.currencySymbol {
//                    currencySymbol = currencySymbolString
//                }
                
//                let behavior = NSDecimalNumberHandler(roundingMode: .down, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
//                let monPriceNumber = product.price.dividing(by: NSDecimalNumber(decimal: 12.0), withBehavior: behavior)
//
//                let currencyFormatter = NumberFormatter()
//                        currencyFormatter.usesGroupingSeparator = true
//                        currencyFormatter.numberStyle = .currency
//                currencyFormatter.locale = product.priceLocale
//                pricePerMonth = currencyFormatter.string(from: monPriceNumber) ?? pricePerMonth
            }

            if product.hasFreeTrial {
                yearlyTitleLabel.text = "3-day free trial"
                yearlyPriceLabel.text = "then \(price) / year."
//                yearlyPricePerMonLabel.text = "\(pricePerMonth)/mo"
//                yearlyPriceLabel.font = UIFont.Exo2.regular(15)
            } else {
                yearlyTitleLabel.text = "Yearly"
                yearlyPriceLabel.text = "\(price) / year."
//                yearlyPricePerMonLabel.text = "\(pricePerMonth)/mo"
//                yearlyPriceLabel.font = UIFont.Exo2.bold(20)
            }
        } else {
            yearlyTitleLabel.text = "Yearly"
            yearlyPriceLabel.text = "\(price) / year."
//            yearlyPricePerMonLabel.text = "\(pricePerMonth)/mo"
//            yearlyPriceLabel.font = UIFont.Exo2.bold(20)
        }
    }
    
    private func priceFormatter(locale: Locale) -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = locale
        formatter.numberStyle = .currency
        return formatter
    }
    
    private func updateLifetimePrice() {
        
        guard let _ = lifetimeButton else { return }
        
        var price = PurchaseProduct.lifetime.priceStringDefault
        if let product = purchaseKit.productsInfo[PurchaseProduct.lifetime.rawValue] {
            if let priceString = product.localizedPrice {
                price = priceString
            }
        }
        
        lifetimePriceLabel.text = price + " / lifetime"
    }
    
    // MARK: -
    
    @IBAction func monthlyButtonTapped(_ sender: UIButton) {
        actionPurchase(product: .monthly)
    }
    
    @IBAction func yearlyButtonTapped(_ sender: UIButton) {
        actionPurchase(product: .yearly)
    }
    
    @IBAction func lifetimeButtonTapped(_ sender: UIButton) {
        actionPurchase(product: .lifetime)
    }
    
    
    @IBAction func restoreButtonTapped(_ sender: Any) {
        actionRestore()
    }
    
    @IBAction func privacyPolicyButtonTapped(_ sender: Any) {
//        Helper.openURL(urlString: kAppPolicyURL)
    }
    
    @IBAction func termsOfUseButtonTapped(_ sender: Any) {
//        Helper.openURL(urlString: kAppTermsOfUseURL)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true){
            //self.showInterstitial()
        }
    }
    
}


extension UpgradeToPremiumViewController {
    
    var purchaseKit: PurchaseKit {
        return PurchaseKit.shared
    }
    
    func getIAPProductsInfo() {
        let productIDs = PurchaseProduct.currentPremiumIDs
        purchaseKit.retrieveProductsInfo(productIDs: productIDs, completion: { [weak self] isSuccess in
            if isSuccess == true {
                self?.updatePricePackages()
            }
        })
    }
    
    func actionPurchase(product: PurchaseProduct) {
        print("product.title: \(product.title)")
        let productID = product.rawValue
        let completion: PurchaseCompletion = { [unowned self] success in
            if success == true {
                let vc = self.presentingViewController ?? self
                vc.dismiss(animated: true, completion: nil)
                self.trackBuyEvent(package: product)
                self.purchaseKit.postInAppPurchasedNotification(object: product)
                
                if self.purchaseKit.config.serverVerifyProductIDs.contains(productID) {
                    self.purchaseKit.config.verifyReceiptHandler?(nil, true, { [unowned self] in
                        self.purchaseKit.finishAllTransactions()
                    })
                }
            }
        }
        
        if let product = purchaseKit.productsInfo[productID] {
            purchaseKit.purchaseProduct(product, completion: completion)
        } else {
            purchaseKit.purchaseProduct(productID, completion: completion)
        }
    }
    
    @objc func actionRestore() {
        
        purchaseKit.restorePurchases() { [unowned self] (isSuccess) in
            if isSuccess == true {
                let vc = self.presentingViewController ?? self
                vc.dismiss(animated: true, completion: nil)
                self.purchaseKit.verifyPurchaseIfNeed()
                self.purchaseKit.postInAppPurchasedNotification(object: nil)
                
                if !self.purchaseKit.config.serverVerifyProductIDs.isEmpty {
                    self.purchaseKit.config.verifyReceiptHandler?(nil, true, { [unowned self] in
                        self.purchaseKit.finishAllTransactions()
                    })
                }
            }
        }
    }
    
}


extension UpgradeToPremiumViewController {
    
    static func show(from: UIViewController?) {
        
        if UpgradeToPremiumViewController.current != nil { return }
        
        let storyboard = UIStoryboard(name: "UpgradeToPremium", bundle: nil)
        if let premiumVC = storyboard.instantiateInitialViewController() as? UpgradeToPremiumViewController {
            premiumVC.modalPresentationStyle = .fullScreen
            if let fromVC = from {
                fromVC.present(premiumVC, animated: true, completion: nil)
            } else {
                var presentVC = UIApplication.shared.keyWindowScene?.rootViewController
                while (presentVC?.presentedViewController != nil) {
                    presentVC = presentVC?.presentedViewController
                }
                
                presentVC?.present(premiumVC, animated: true, completion: nil)
            }
        }
    }
    
}


// MARK: - App Events

extension UpgradeToPremiumViewController {
    
    func trackBuyEvent(package: PurchaseProduct) {
        
        let additionParams: TrackingParameters = [:]
        
        package.trackAdjust(additionParams: [:])
        if package.type == .subscription {
            package.trackAdjustSubscription()
        }
        
        package.trackFirebase(additionParams: additionParams)
        package.trackFacebook(additionParams: additionParams)
    }
    
    /*
    func logAttributionEvent(package: PurchaseProduct) {
        if let product = PurchaseKit.shared.productsInfo[package.rawValue], let attributionApiID = UserDefaults.standard.object(forKey: kAttributionApiID) as? String {
            
            var timePeriod: Double = 0.0
            if let timeOpen = UserDefaults.standard.object(forKey: kFirstTimeOpenApp) as? Date {
                if #available(iOS 13.0, *) {
                    timePeriod = timeOpen.distance(to: Date())
                } else {
                    timePeriod = Date().timeIntervalSince(timeOpen)
                }
            }
            let currency = product.priceLocale.currencyCode ?? "USD"
            guard let receiptUrl = Bundle.main.appStoreReceiptURL else { return }
            guard let receipt = try? Data(contentsOf: receiptUrl) else { return }
            
            var eventParams: [String: Any] = ["item_id" : package.rawValue,
                               "item_name" : package.title,
                               "contition" : storeCondition,
                               "time_to_purchase" : timePeriod,
                               "currency" : currency,
                               "receipt" : receipt]
            if selectedBrand_ != nil {
                eventParams["carmake_select"] = selectedBrand_?.name
            }
            let params: [String: Any]  = ["attribution": attributionApiID,
                          "eventName": "keyconnect_in_app_purchases",
                          "eventParams": eventParams]
            let request = APIRequestInfo.postAttributionEvent(params: params)
            APIService.postAttributionEvent(info: request) {
                //
            }
        }
    }
     */
    
}
