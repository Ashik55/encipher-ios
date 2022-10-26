// 
// Copyright 2022 New Vector Ltd
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
import DSBottomSheet

extension View {
    func bottomSheet<V: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> V) -> some View {
        Group {
            if #available(iOS 16, *) {
                sheet(isPresented: isPresented) {
                    content()
                        .presentationDetents([.medium, .large])
                }
            } else {
                bottomSheet(BottomSheet(isExpanded: isPresented,
                                        minHeight: .percentage(0),
                                        maxHeight: .percentage(0.5),
                                        style: BottomSheetStyle(cornerRadius: 8, handleStyle: .init(width: 50, height: 4)),
                                        content: content))
            }
        }
    }
}
