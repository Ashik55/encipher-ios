//
// Copyright 2024 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import Foundation

extension Notification.Name {
    static let roomSummaryDidRemoveExpiredDataFromStore = Notification.Name(MXRoomSummary.roomSummaryDidRemoveExpiredDataFromStore)
}

@objc extension MXRoomSummary {
    static let roomSummaryDidRemoveExpiredDataFromStore = "roomSummaryDidRemoveExpiredDataFromStore"
    
    private enum Constants {
        static let roomRetentionInDaysKey = "roomRetentionInDays"
    }
    /// Get the room messages retention period in days
    func roomRetentionPeriodInDays() -> uint {
        if let period = self.others[Constants.roomRetentionInDaysKey] as? uint {
            return period
        } else {
            return 365
        }
    }
    
    /// Get the timestamp below which the received messages must be removed from the store, and the display
    func mininumTimestamp() -> UInt64 {
        let periodInMs = Tools.durationInMs(fromDays: self.roomRetentionPeriodInDays())
        let currentTs = (UInt64)(Date().timeIntervalSince1970 * 1000)
        return (currentTs - periodInMs)
    }
    
    /// Remove the expired messages from the store.
    /// If some data are removed, this operation posts the notification: roomSummaryDidRemoveExpiredDataFromStore.
    /// This operation does not commit the potential change. We let the caller trigger the commit when this is the more suitable.
    ///
    /// Provide a boolean telling whether some data have been removed.
    func removeExpiredRoomContentsFromStore() -> Bool {
        let ret = self.mxSession.store.removeAllMessagesSent(before: self.mininumTimestamp(), inRoom: roomId)
        if ret {
            NotificationCenter.default.post(name: .roomSummaryDidRemoveExpiredDataFromStore, object: self)
        }
        return ret
    }
}
