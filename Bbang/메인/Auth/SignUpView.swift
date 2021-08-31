//
//  SignUpView.swift
//  Bbang
//
//  Created by bart Shin on 2021/08/08.
//

import SwiftUI

struct SignUpView: View {
	
	@ObservedObject var authVC: AuthVC
	@State private var showingDuplicated = false
	
    var body: some View {
		Form {
			
			Section(footer:
						Group {
							Text("This nick name is used")
								.foregroundColor(.red)
								.opacity(authVC.nicknameIsDuplciated ? 1: 0)
						}
			) {
				TextField("Nick name", text: $authVC.signUpNickname)
			}
			.padding(.horizontal, 30)
			Button {
				authVC.checkNicknameIsDuplicated()
			} label: {
				Text("Sign up")
					.padding(.horizontal, 30)
			}
			
		}
    }
}
#if DEBUG
class SingUpData: ObservableObject {
	var nickName = ""
	var duplicated = false
}

struct SignUpView_Previews: PreviewProvider {
	@StateObject static var data = SingUpData()
    static var previews: some View {
		SignUpView(authVC: AuthVC())
    }
}
#endif
