import Cocoa

class ViewController: NSViewController {
    let resetTime = 1200
    var timer: Timer?
    var timeRemaining = 1200 // 15 minutes in seconds
    var isActive = false

    let countdownLabel = NSTextField(labelWithString: "")
    let startButton = NSButton(title: "开始", target: nil, action: nil)
    let pauseButton = NSButton(title: "暂停", target: nil, action: nil)
    let stopButton = NSButton(title: "结束", target: nil, action: nil)

    var alertWindow: NSWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置界面
        setupUI()
        updateLabel()
    }

    func setupUI() {
        // 设置标签
        countdownLabel.font = NSFont.systemFont(ofSize: 48)
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(countdownLabel)

        // 设置按钮
        startButton.target = self
        startButton.action = #selector(startTimer)
        
        pauseButton.target = self
        pauseButton.action = #selector(pauseTimer)
        
        stopButton.target = self
        stopButton.action = #selector(stopTimer)
        
        let buttonStackView = NSStackView(views: [startButton, pauseButton, stopButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.orientation = .horizontal
        buttonStackView.spacing = 10
        view.addSubview(buttonStackView)

        // 设置约束
        NSLayoutConstraint.activate([
            countdownLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            countdownLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20),
            buttonStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonStackView.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 20)
        ])
    }

    @objc func startTimer() {
        timeRemaining = resetTime
        if !isActive {
            isActive = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }

    @objc func pauseTimer() {
        isActive = false
        timer?.invalidate()
 }

    @objc func stopTimer() {
        isActive = false
        timer?.invalidate()
        timeRemaining = 900 // Reset to 15 minutes
        updateLabel()
    }

    @objc func updateTimer() {
        if timeRemaining > 0 {
            timeRemaining -= 1
            updateLabel()
        } else {
            timer?.invalidate()
            isActive = false
            showTimeUpAlert()
        }
    }

    func updateLabel() {
        countdownLabel.stringValue = formattedTime(timeRemaining)
    }

    func formattedTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func showTimeUpAlert() {
        // 创建提示窗口
        if alertWindow == nil {
            alertWindow = NSWindow(contentRect: NSScreen.main!.frame,
                                    styleMask: [.titled, .closable],
                                    backing: .buffered,
                                    defer: false)
            alertWindow?.title = ""
            alertWindow?.isOpaque = true
            alertWindow?.backgroundColor = NSColor.black.withAlphaComponent(0.75)

            // 创建标签
            let alertLabel = NSTextField(labelWithString: "")
            alertLabel.font = NSFont.systemFont(ofSize: 64)
            alertLabel.textColor = NSColor.white
            alertLabel.translatesAutoresizingMaskIntoConstraints = false
            alertLabel.alignment = .center
            alertWindow?.contentView?.addSubview(alertLabel)

            // 设置约束
            NSLayoutConstraint.activate([
                alertLabel.centerXAnchor.constraint(equalTo: alertWindow!.contentView!.centerXAnchor),
                alertLabel.centerYAnchor.constraint(equalTo: alertWindow!.contentView!.centerYAnchor)
            ])
        }
        

        alertWindow?.makeKeyAndOrderFront(nil)
       

        // 3秒后关闭提示窗口
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 隐藏窗口
            self.alertWindow?.orderOut(nil)
//            self.alertWindow = nil // 清空引用以便释放内存
//            // 这里可以选择重置计时器，准备下一个倒计时
            self.resetTimer()
        }
    }
    
  
    func resetTimer() {
        timeRemaining = resetTime // Reset to 15 minutes
        updateLabel()
        startTimer()
    }
}
