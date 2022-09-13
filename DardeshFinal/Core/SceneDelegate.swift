//
//  SceneDelegate.swift
//  DardeshFinal
//
//  Created by MacOS on 23/01/2022.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    // to see if youse is login or out
    var authListener : AuthStateDidChangeListenerHandle?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        autoLogin()
        window?.rootViewController = Login_Signup_Bage()
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
      
        LocationManager.shard.startUpdating()
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        LocationManager.shard.stopUpdating()
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        LocationManager.shard.stopUpdating()
    }
    /*
     the remove tase (self.authListener!)
     1- I want it to change once only and then remove the variable
     2- addStateDidChangeListener will change the satae (by only make the func)
     --> the var will make the func if user Change the satte of the app when user is found and his data is on userDefault
     --> the func only go to the main app by Changing the rootViewController
     the func goToApp work on the background so we but it on dispatchQueue
     ?????not understand
     */
    func autoLogin(){
       authListener = Auth.auth().addStateDidChangeListener { auth, user in

           Auth.auth().removeStateDidChangeListener(self.authListener!)
           if user != nil && userDefault.object(forKey : kCURRENTUSER) != nil {
               //DispatchQueue.main.async {
                   self.goToApp()
              // }
           }
        }
    }

    private func goToApp(){
        let VC = TabBarController()
        self.window?.rootViewController = VC
        self.window?.makeKeyAndVisible()
    }
}

