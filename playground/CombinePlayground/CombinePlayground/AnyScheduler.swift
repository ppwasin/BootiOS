//
//  AnyScheduler.swift
//  CombinePlayground
//
//  Created by Wasin Passornpakorn on 20/6/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import Combine

/*
let schedule: any Scheduler where .ScheduleTimeType ==  DispatchQueue.SchedulerTimeType, .SchedulerOptions == DispatchQueue.SchedulerOptions
 //Adhoc (EraseType) The same as AnySubscriber
 let schedule: AnyScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>
 */

// Init with S, but after init, then S will be not need to provide anymore
struct AnyScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler
    where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    var now: SchedulerTimeType {
        self._now()
    }
    
    var minimumTolerance: SchedulerTimeType.Stride {
        self._minimumTolerance()
    }
    
    private let _now: () -> SchedulerTimeType
    private let _minimumTolerance: () -> SchedulerTimeType.Stride
    private let _scheduler: (SchedulerOptions?, @escaping () -> Void) -> Void
    private let _schedulerAfterDelay: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Void
    private let _schedulerWithInterval: (SchedulerTimeType, SchedulerTimeType.Stride, SchedulerTimeType.Stride, SchedulerOptions?, @escaping () -> Void) -> Cancellable
    
    init<S: Scheduler>(_ scheduler: S) where S.SchedulerTimeType == SchedulerTimeType, S.SchedulerOptions == SchedulerOptions {
        self._now = { scheduler.now }
        self._minimumTolerance = { scheduler.minimumTolerance }
        self._scheduler = { scheduler.schedule(options: $0, $1) }
        self._schedulerAfterDelay = { scheduler.schedule(after: $0, tolerance: $1, $3) }
        self._schedulerWithInterval = { scheduler.schedule(after: $0, interval: $1, tolerance: $2, options: $3, $4) }
    }
    
    func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
        self._schedulerWithInterval(date, interval, tolerance, options, action)
    }
    
    func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
        self._schedulerAfterDelay(date, tolerance, options, action)
    }
    
    func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
        self._scheduler(options, action)
    }
}

//Instead of call AnyScheduler<DispatchQueue.SchedulerTimeType, DispatchQueue.SchedulerOptions>
typealias AnySchedulerOf<S: Scheduler> = AnyScheduler<S.SchedulerTimeType, S.SchedulerOptions>

//Instead of call AnyScheduler(Dispatcher.main)
extension Scheduler {
    func eraseToAnyScheduler() -> AnySchedulerOf<Self> {
        AnyScheduler(self)
    }
}
