//
//  ChangeOrderPage.swift
//  PDB-Client-App
//
//  Created by Ben Cramer on 10/30/20.
//

import SwiftUI
import ASCollectionView

struct ChangeOrderPage: View {
    var forms: [ChangeOrderForm]
    var projectID: String
    
    var body: some View {
        ASCollectionView(data: forms.indices, dataID: \.self) { index,arg  in
            
            NavigationLink(destination:
                            SignFormPage(form: forms[index], projectID: projectID)
            ) {
                ChangeOrderPreviewView(form: forms[index])
            }
            .padding([.top])
            
        }.layout {
            .grid()
        }.background(Color("backgroundColor"))
    }
}

struct ChangeOrderPage_Previews: PreviewProvider {
    static var formsArr = [ChangeOrderForm(title: "Marble Counter")]
    static var previews: some View {
        ChangeOrderPage(forms: formsArr, projectID: "")
    }
}
