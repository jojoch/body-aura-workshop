//
//  CombineCocoaPublishers+Convenience.swift
//  STRV Project template
//
//  Created by Marek Slávik on 11.02.2021.
//  Copyright © 2021 STRV. All rights reserved.
//

import Combine
import Foundation
import UIKit

// swiftlint:disable nesting
// MARK: - Publisher
public extension Combine.Publishers {
    /// A publisher which wraps objects that use the Target & Action mechanism,
    /// for example - a UIBarButtonItem which isn't KVO-compliant and doesn't use UIControlEvent(s).
    ///
    /// Instead, you pass in a generic Control, and two functions:
    /// One to add a target action to the provided control, and a second one to
    /// remove a target action from a provided control.
    struct ControlTarget<Control: AnyObject>: Publisher {
        public typealias Output = Control
        public typealias Failure = Never

        private let control: Control
        private let addTargetAction: (AnyObject, Selector) -> Void
        private let removeTargetAction: (AnyObject, Selector) -> Void

        /// Initialize a publisher that emits a Self whenever the
        /// provided control fires an action.
        ///
        /// - parameter control: UI Control.
        /// - parameter addTargetAction: A function which accepts the Control, a Target and a Selector and it is
        ///                              responsible to add the target action to the provided control.
        /// - parameter removeTargetAction: A function which accepts the Control, a Target and a Selector and it is
        ///                                 responsible to remove the target action from the provided control.
        public init(
            control: Control,
            addTargetAction: @escaping (AnyObject, Selector) -> Void,
            removeTargetAction: @escaping (AnyObject, Selector) -> Void
        ) {
            self.control = control
            self.addTargetAction = addTargetAction
            self.removeTargetAction = removeTargetAction
        }

        public func receive<S: Subscriber>(subscriber: S) where S.Failure == Failure, S.Input == Output {
            let subscription = Subscription(
                subscriber: subscriber,
                control: control,
                addTargetAction: addTargetAction,
                removeTargetAction: removeTargetAction
            )

            subscriber.receive(subscription: subscription)
        }
    }
}

// MARK: - Subscription
private extension Combine.Publishers.ControlTarget {
    private final class Subscription<S: Subscriber, Control: AnyObject>: Combine.Subscription where S.Input == Control {
        private var subscriber: S?

        private let removeTargetAction: (AnyObject, Selector) -> Void
        private let action = #selector(handleAction)
        private var currentDemand = Subscribers.Demand.none // keep track of subscriber demand
        private weak var control: Control?

        init(
            subscriber: S,
            control _: Control,
            addTargetAction: @escaping (AnyObject, Selector) -> Void,
            removeTargetAction: @escaping (AnyObject, Selector) -> Void
        ) {
            self.subscriber = subscriber
            self.removeTargetAction = removeTargetAction

            addTargetAction(self, action)
        }

        func request(_ demand: Subscribers.Demand) {
            // add new demand of subscriber to previously requested demand
            currentDemand += demand == .none ?
                Subscribers.Demand.max(0) :
                demand
        }

        func cancel() {
            subscriber = nil
            removeTargetAction(self, action)
        }

        @objc private func handleAction() {
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
