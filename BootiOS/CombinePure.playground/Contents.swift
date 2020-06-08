import Combine
import Dispatch

let source = DispatchSource.makeTimerSource()
source.schedule(deadline: .now(), repeating: 1)
source.setEventHandler{
    print("DispatchQueue", "source", "timer")
}
source.resume()
