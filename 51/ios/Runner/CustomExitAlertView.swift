import UIKit

class CustomExitAlertView: UIView {

    var onConfirm: (() -> Void)?
    var onCancel: (() -> Void)?

    private let container = UIView()
    private let titleLabel = UILabel()
    private let cancelButton = UIButton(type: .system)
    private let confirmButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)

    init(title: String) {
        super.init(frame: UIScreen.main.bounds)
        backgroundColor = UIColor.black.withAlphaComponent(0.4)

        setupUI(title: title)
        showAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String) {
        // 弹窗容器
        container.backgroundColor = .white
        container.layer.cornerRadius = 20
        container.translatesAutoresizingMaskIntoConstraints = false
        addSubview(container)

        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor),
            container.widthAnchor.constraint(equalToConstant: 300),
            container.heightAnchor.constraint(equalToConstant: 200)
        ])

        // 标题
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -20)
        ])

        // 关闭按钮（右上角叉）
        closeButton.setTitle("✕", for: .normal)
        closeButton.setTitleColor(.gray, for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        container.addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        // 按钮
        let buttonStack = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 20
        buttonStack.distribution = .fillEqually
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            buttonStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 44)
        ])

        // 取消按钮样式
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.setTitleColor(.gray, for: .normal)
        cancelButton.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cancelButton.layer.cornerRadius = 10
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        // 确定按钮样式
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = UIColor(red: 16/255, green: 200/255, blue: 227/255, alpha: 1)
        confirmButton.layer.cornerRadius = 10
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }

    private func showAnimation() {
        container.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        container.alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.container.alpha = 1
            self.container.transform = .identity
        }
    }

    @objc private func cancelTapped() {
        onCancel?()
        dismiss()
    }

    @objc private func confirmTapped() {
        onConfirm?()
        dismiss()
        AppDelegate.flutterCallbackChannel?.invokeMethod("onExitConfirmed", arguments: [
            "source": "NativeWebView",
            "title": titleLabel.text ?? ""
        ])
    }

    func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
