//
//  UIControl+CustomPublisher.swift
//  STRV Project template
//
//  Created by Marek Slávik on 11.02.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Combine
import UIKit

// swiftlint:disable nesting
extension UIControl {
    struct EventPublisher<Control: UIControl>: Publisher {
        typealias Output = Control
        typealias Failure = Never

        private let control: Control
        private let event: Event

        init(control: Control, event: Control.Event) {
            self.control = control
            self.event = event
        }

        // Combine will call this method on our publisher whenever
        // a new object started observing it. Within this method,
        // we'll need to create a subscription instance and
        // attach it to the new subscriber:
        func receive<S: Subscriber>(
            subscriber: S
        ) where S.Input == Output, S.Failure == Failure {
            // Creating our custom subscription instance:
            let subscription = EventSubscription<S, Control>(subscriber: subscriber, control: control)
            // Attaching our subscription to the subscriber:
            subscriber.receive(subscription: subscription)

            // Connecting our subscription to the control that's
            // being observed:
            control.addTarget(
                subscription,
                action: #selector(subscription.trigger),
                for: event
            )
        }
    }
}

private extension UIControl {
    class EventSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Control {
        private var subscriber: S?
        private var currentDemand = Subscribers.Demand.none // keep track of subscriber demand
        private weak var control: Control?

        init(subscriber: S, control: Control) {
            self.subscriber = subscriber
            self.control = control
        }

        // This subscription doesn't respond to demand, since it'll
        // simply emit events according to its underlying UIControl
        // instance, but we still have to implement this method
        // in order to conform to the Subscription protocol:
        func request(_ demand: Subscribers.Demand) {
            // add new demand of subscriber to previously requested demand
            currentDemand += demand == .none ?
                Subscribers.Demand.max(0) :
                demand
        }

        func cancel() {
            // When our subscription was cancelled, we'll release
            // the reference to our target to prevent any
            // additional events from being sent to it:
            subscriber = nil
        }

        @objc func trigger() {
            // only sending value when subscriber has a demand
            // this implentation does not buffer values
            guard let control = control, currentDemand > 0 else {
                return
            }

            let newDemand = subscriber?.receive(control) ?? .none

            // fulfilled demand with one value -> reduce current demand by one
            currentDemand -= 1

            // adding subscribers new demand to current demand
            currentDemand += newDemand == .none ?
                .max(0) :
                newDemand
        }
    }
}

// swiftlint:enable nesting
