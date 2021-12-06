// File created from SimpleUserProfileExample
// $ createScreen.sh AnalyticsPrompt AnalyticsPrompt
//
// Copyright 2021 New Vector Ltd
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

import SwiftUI
import Combine

@available(iOS 14, *)
typealias AnalyticsPromptViewModelType = StateStoreViewModel<AnalyticsPromptViewState,
                                                             AnalyticsPromptStateAction,
                                                             AnalyticsPromptViewAction>
@available(iOS 14, *)
class AnalyticsPromptViewModel: AnalyticsPromptViewModelType {

    // MARK: - Properties

    // MARK: Private

    // MARK: Public

    var completion: ((AnalyticsPromptViewModelResult) -> Void)?

    // MARK: - Setup
    
    /// Initialize a view model with the specified prompt type and app display name.
    init(promptType: AnalyticsPromptType, appDisplayName: String) {
        super.init(initialViewState: AnalyticsPromptViewState(promptType: promptType, appDisplayName: appDisplayName))
    }

    // MARK: - Public
    
    override func process(viewAction: AnalyticsPromptViewAction) {
        switch viewAction {
        case .enable:
            enable()
        case .disable:
            disable()
        case .openTermsURL:
            openTermsURL()
        }
    }

    override class func reducer(state: inout AnalyticsPromptViewState, action: AnalyticsPromptStateAction) {
        // There is no mutable state to reduce :)
    }
    
    /// Enable analytics. The call to the Analytics class is made in the completion.
    private func enable() {
        completion?(.enable)
    }

    /// Disable analytics. The call to the Analytics class is made in the completion.
    private func disable() {
        completion?(.disable)
    }
    
    /// Open the service terms link.
    private func openTermsURL() {
        guard let url = URL(string: "https://element.io/cookie-policy") else { return }
        UIApplication.shared.open(url)
    }
}
