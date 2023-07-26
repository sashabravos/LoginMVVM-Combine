//
//  LoginViewController.swift
//  JustChat
//
//  Created by Александра Кострова on 21.06.2023.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    var loginViewModel = LoginViewModel()
    var cancellables = Set<AnyCancellable>()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 40.0, weight: .medium)
        label.textColor = .label
        label.text = "Login"
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.0, weight: .regular)
        label.isHidden = true
        label.textColor = .systemGray2
        label.text = ""
        return label
    }()
    
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Login"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        view.backgroundColor = .white

        [pageTitle,loginTextField, passwordTextField, loginButton, statusLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            pageTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            
            loginTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginTextField.topAnchor.constraint(equalTo: pageTitle.bottomAnchor, constant: 20),
                loginTextField.widthAnchor.constraint(equalToConstant: 200),
            
            passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 20),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func loginButtonTapped() {
        loginViewModel.submitLogin()
    }
    
    func bindViewModel() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: loginTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.email, on: loginViewModel)
            .store(in: &cancellables)
        
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: passwordTextField)
            .map { ($0.object as! UITextField).text ?? "" }
            .assign(to: \.password, on: loginViewModel)
            .store(in: &cancellables)
        
        loginViewModel.isLoginEnable
            .assign(to: \.isEnabled, on: loginButton)
            .store(in: &cancellables)
        
        loginViewModel.$state
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.statusLabel.isHidden = true
                    self?.loginButton.isEnabled = false
                    self?.loginButton.setTitle("Loading", for: .normal)
                    
                case .success:
                    self?.statusLabel.isHidden = false
                    self?.statusLabel.text = "Login success"
                    self?.statusLabel.textColor = .systemGreen
                    self?.loginButton.setTitle("Login", for: .normal)
                    
                case .failed:
                    self?.statusLabel.isHidden = false
                    self?.statusLabel.text = "Login failed"
                    self?.statusLabel.textColor = .systemRed
                    self?.loginButton.setTitle("Login", for: .normal)
                    
                case .none:
                    break
                }
            }
        
            .store(in: &cancellables)
    }
}



