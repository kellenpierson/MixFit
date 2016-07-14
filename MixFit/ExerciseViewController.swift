//
//  ExerciseViewController.swift
//  MixFit
//
//  Created by Kellen Pierson on 6/15/16.
//  Copyright © 2016 Jetpilot. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {

    var coreDataStack = CoreDataStack.sharedInstance

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var exerciseNameLabel: UILabel!
    @IBOutlet weak var setsAndRepsLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var addToFavoritesButton: UIButton!
    @IBOutlet weak var addToMixlistButton: UIButton!
    @IBOutlet weak var targetedMuscleGroupsLabel: UILabel!
    @IBOutlet weak var trainersNotesLabel: UILabel!

    var page = 0
//    var isFavorite: Bool = false
    var exercise: Exercise!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadExerciseData()
        setFavoriteButtonTitle()

        scrollView.contentSize.width = view.frame.width
//        let topInset = CGRectGetHeight(navigationController!.navigationBar.frame) + CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
//        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)
//        scrollView.scrollIndicatorInsets = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: 0)

    }

    private func loadExerciseData() {
        exerciseNameLabel.text = exercise.name.uppercaseString
        setsAndRepsLabel.text = "5 sets of 5 reps"
        restTimeLabel.text = "90 seconds rest"
        targetedMuscleGroupsLabel.text = exercise.targetedMuscleGroups
        trainersNotesLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    }

    private func setFavoriteButtonTitle() {
        if exercise.isFavorite.boolValue {
            addToFavoritesButton.setTitle("❤️ Favorite", forState: .Normal)
        } else {
            addToFavoritesButton.setTitle("+ Add to Favorites", forState: .Normal)
        }
    }

    @IBAction func onAddToFavoritesButtonPressed(sender: UIButton) {
        if exercise.isFavorite.boolValue == false {
            exercise.setValue(!exercise.isFavorite.boolValue, forKey: "isFavorite")
            coreDataStack.saveMainContext()
            notificationAlertWithTitle("Added to Favorites")
//            print(exercise.isFavorite.boolValue)
        } else {
            exercise.setValue(!exercise.isFavorite.boolValue, forKey: "isFavorite")
            coreDataStack.saveMainContext()
            notificationAlertWithTitle("Removed from Favorites")
//            print(exercise.isFavorite.boolValue)
        }

        setFavoriteButtonTitle()
    }

    @IBAction func onAddToMixlistButtonPressed(sender: UIButton) {
//        print("Add to a mixlist!")
        self.performSegueWithIdentifier("ShowMixlistsSegue", sender: self)
    }

    func notificationAlertWithTitle(title: String) {
        let notificationAlert = storyboard!.instantiateViewControllerWithIdentifier("NotificationAlert") as! NotificationAlertViewController

        // Get height of status bar + nav bar (only if translucent navbar)
//        let topInset = CGRectGetHeight(navigationController!.navigationBar.frame) + CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)

        // Create notification view
        let notificationFrameView = UIView(frame: CGRectMake(0, -50, view.frame.width, 50))

        // Specify frame for notification alert vc view
        notificationAlert.view.frame = CGRectMake(0, 0, notificationFrameView.frame.width, notificationFrameView.frame.height)

        // Set title text for notification alert view
        notificationAlert.notificationTitleLabel.text = title.uppercaseString

        // Add notification alert vc to current vc
        addChildViewController(notificationAlert)
        notificationFrameView.addSubview(notificationAlert.view)
        notificationAlert.didMoveToParentViewController(self)

        // Add the notification view to the main view
        view.addSubview(notificationFrameView)

        // And finally animate the notification bar down...
        UIView.animateWithDuration(0.2, animations: {
            notificationFrameView.frame.origin.y =  -1
            }) { (Bool) in
                // ...and back up after a slight delay
                UIView.animateWithDuration(0.4, delay: 1.8, options: [], animations: {
                    notificationFrameView.frame.origin.y = -70
                    }, completion: { (Bool) in
                        notificationFrameView.removeFromSuperview()
                })
        }
    }

    func pauseLayer(layer: CALayer) {
        let pausedTime = layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }

    func resumeLayer(layer: CALayer) {
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        layer.beginTime = timeSincePause
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowMixlistsSegue" {
            let navController = segue.destinationViewController as? UINavigationController
            let destinationViewController = navController?.topViewController as? AddToMixlistTableViewController
            destinationViewController?.exercise = self.exercise
            destinationViewController?.delegate = self
        }
    }

    @IBAction func unwindToExerciseViewController(segue: UIStoryboardSegue) {

    }
    

}

extension ExerciseViewController: AddToMixlistDelegate {

    func exerciseAddedToMixlist(mixlistName: String) {
        let alertTitle = "Added to \"\(mixlistName)\""
//        print("\(alertTitle.uppercaseString)")
        self.notificationAlertWithTitle(alertTitle.uppercaseString)
    }

}








