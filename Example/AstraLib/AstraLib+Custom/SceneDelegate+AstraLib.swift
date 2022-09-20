//
//  SceneDelegate+AstraLib.swift
//  AstraDemo
//
//  Created by Cung Truong on 20/03/2022.
//

import AstraLib

extension SceneDelegate {
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let url = URLContexts.first?.url else {
            return
        }

        FacebookTracking.open(url: url)
    }
}
