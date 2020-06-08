//
//  TestScheduler.swift
//  CombinePlayground
//
//  Created by Wasin Passornpakorn on 8/6/2563 BE.
//  Copyright © 2563 Wasin Passornpakorn. All rights reserved.
//

import Combine
import Dispatch

final class TestScheduler<SchedulerTimeType, SchedulerOptions>: Scheduler where SchedulerTimeType: Strideable, SchedulerTimeType.Stride: SchedulerTimeIntervalConvertible {
    var now: SchedulerTimeType
    
    var minimumTolerance: SchedulerTimeType.Stride = 0
    
    private var scheduled: [() -> Void] = []
    
    init(now: SchedulerTimeType) {
        self.now = now
    }
    
    func advanced() {
        for action in self.scheduled {
            action()
        }
        self.scheduled.removeAll()
    }
    
    func schedule(
        options _: SchedulerOptions?,
        _ action: @escaping () -> Void
    ) {
        self.scheduled.append(action)
    }
    
    func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {}
    
    func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
        return AnyCancellable {}
    }
}


extension DispatchQueue{
    static var testScheduler: TestScheduler<SchedulerTimeType, SchedulerOptions>{
        TestScheduler(now: .init(.init(uptimeNanoseconds: 1)))
    }
}
