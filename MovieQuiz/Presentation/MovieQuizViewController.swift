import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol{
    // MARK: - Lifecycle
    
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenter!
    private var statisticService: StatisticService?
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
        showLoadingIndicator()
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    func unlockedButton() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func blockedButton() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    
    func showNetworkError(message: String){
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз")
        { [weak self] in
            guard let self = self else {return}
            self.presenter.restartGame()
            //            self.questionFactory?.loadData()
        }
        alertPresenter?.showAlert(model: model)
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.cornerRadius = 20
        imageView.image = step.image
        counterLabel.text = step.questionNumber
        textLabel.text = step.question
        
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        blockedButton()
    }
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        blockedButton()
    }
    
}



