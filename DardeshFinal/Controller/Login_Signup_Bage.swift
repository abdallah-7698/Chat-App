

import UIKit
import Firebase
import ProgressHUD


class Login_Signup_Bage: UIViewController {
    
    //MARK: - IBOutlet
    
    // Lables
    
    @IBOutlet weak var titleOutletLable: UILabel!
    @IBOutlet weak var emailLableOutlet: UILabel!
    @IBOutlet weak var passwordLableOutlet: UILabel!
    @IBOutlet weak var confirmPasswordLableOutlet: UILabel!
    @IBOutlet weak var accountQuestionLableOutlet: UILabel!
    
    
    // TextField
    // make clear button
    @IBOutlet weak var emailTextFieldOutlet: UITextField!
    @IBOutlet weak var passwordTextFieldOutlet: UITextField!
    @IBOutlet weak var confirmPasswordTextFieldOutlet: UITextField!
   
    //Buttons
    
    @IBOutlet weak var forgetPasswordButtonOutlet: UIButton!
    @IBOutlet weak var resendPasswordButtonOutlet: UIButton!
    @IBOutlet weak var registerButtonOutlet: UIButton!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    // View
    @IBOutlet weak var hiddenViewOutlet: UIView!
    
    //MARK: - Constant
    
    var isLogin : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // make all lanbles empty at first
        prepareLables()
        prepareTextField()
        setupBackgroundTap()
    }
    
    //MARK: - IBAction
    
    @IBAction func forgetPasswordPressed(_ sender: UIButton) {
        if isDataValidFor(mode: "Forget Password ?"){
            forgetPassword()
        }else{
            let alert = UIAlertController(title: "Error", message: "Email is required", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default , handler: nil)
            alert.addAction(action)
            present(alert, animated: false, completion: nil)
        }
    }
    
    @IBAction func resendPasswordPressed(_ sender: UIButton) {
         resendVarificationEmail()
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if isDataValidFor(mode: isLogin ? "Login" : "Register"){
            isLogin ? loginUser() : registerUser()
        }else{
            ProgressHUD.showError("Data is not valid Check your data!")
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        updateUIMode(mode: isLogin)
    }
    
    
    
    
    //MARK: - HelperFunctions
    private func prepareTextField(){
        emailTextFieldOutlet.clearButtonMode = .whileEditing
        passwordTextFieldOutlet.clearButtonMode = .whileEditing
        confirmPasswordTextFieldOutlet.clearButtonMode = .whileEditing
    }
    
    func prepareLables(){
        // because it will not be "" untill you press on the emailtextField
        forgetPasswordButtonOutlet.isHidden = true
        emailLableOutlet.text               = ""
        passwordLableOutlet.text            = ""
        confirmPasswordLableOutlet.text     = ""
        
        // email text field can call the func on the extension
        emailTextFieldOutlet.delegate           = self
        passwordTextFieldOutlet.delegate        = self
        confirmPasswordTextFieldOutlet.delegate = self
    }
    
    private func updateUIMode(mode : Bool){
        if !mode{
            titleOutletLable.text =  "Login"
            confirmPasswordLableOutlet.isHidden     = true
            confirmPasswordTextFieldOutlet.isHidden = true
            resendPasswordButtonOutlet.isHidden     = true
            forgetPasswordButtonOutlet.isHidden     = false
            accountQuestionLableOutlet.text         = "Create an Account "
            registerButtonOutlet.setTitle("Login", for: .normal)
            loginButtonOutlet.setTitle("Signin", for: .normal)
        }else{
            titleOutletLable.text = "Register"
            confirmPasswordLableOutlet.isHidden     = false
            confirmPasswordTextFieldOutlet.isHidden = false
            resendPasswordButtonOutlet.isHidden     = false
            forgetPasswordButtonOutlet.isHidden     = true
            accountQuestionLableOutlet.text         = "Have an account ?"
            registerButtonOutlet.setTitle("Register", for: .normal)
            loginButtonOutlet.setTitle("Login", for: .normal)
        }
        isLogin.toggle()
    }
    
    // general for all the buttons
    private func isDataValidFor(mode : String)-> Bool{
        switch mode{
        case "Login":
            return emailTextFieldOutlet.text       != ""
            && passwordTextFieldOutlet.text        != ""
        case "Register":
            return emailTextFieldOutlet.text       != ""
            && passwordTextFieldOutlet.text        != ""
            && confirmPasswordTextFieldOutlet.text != ""
            && passwordTextFieldOutlet.text == confirmPasswordTextFieldOutlet.text
        case "Forget Password ?":
            return emailTextFieldOutlet.text       != ""
        default:
            return false
        }
    }
    
    @objc func hideKeybord(){
        view.endEditing(false)
    }
    
    //MARK: - Register User
    private func registerUser(){
        FUserListener.shared.RegisterUserWith(email: emailTextFieldOutlet.text!, password: passwordTextFieldOutlet.text!) { error in
            if error == nil{
                ProgressHUD.showSuccess("you have receved the varification email")
            }else{
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }
    
    //MARK: - resend Varification Email
    private func resendVarificationEmail(){
        FUserListener.shared.resendVarification(email: emailTextFieldOutlet.text!) { error in
            if error == nil {
                ProgressHUD.showSucceed("Veridication email has been sent")
            }else{
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }
    //MARK: - forget password
    private func forgetPassword(){
        FUserListener.shared.resetPasswordFor(email: emailTextFieldOutlet.text!) { error in
            if error == nil {
                ProgressHUD.showSuccess("reset password has been sent")
            }else{
                ProgressHUD.showFailed(error?.localizedDescription)
            }
        }
    }

    
    //MARK: - Login User
    private func loginUser(){
        FUserListener.shared.loginUserWith(email: emailTextFieldOutlet.text!, password: passwordTextFieldOutlet.text!) { error, isEmailVerified in
            if error == nil{
                if isEmailVerified{
                    self.goToApp()
                }else{
                    ProgressHUD.showFailed("you must confirm your Email")
                }
            }else{
                ProgressHUD.showError(error?.localizedDescription)
            }
        }
    }

    private func goToApp(){
      let VC = TabBarController()
        VC.modalPresentationStyle = .fullScreen
        present(VC, animated: true, completion: nil)
    }

    //MARK: - Tab Gesture
    private func setupBackgroundTap(){
        let tapgesturn = UITapGestureRecognizer(target: self, action: #selector(hideKeybord))
        view.addGestureRecognizer(tapgesturn)
    }
    
    
    
    
}

extension Login_Signup_Bage : UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailLableOutlet.text           = emailTextFieldOutlet.hasText ? "Email" : ""
        passwordLableOutlet.text        = passwordTextFieldOutlet.hasText ? "Password" : ""
        confirmPasswordLableOutlet.text = confirmPasswordTextFieldOutlet.hasText ? "Password" : ""
    }
    
}
