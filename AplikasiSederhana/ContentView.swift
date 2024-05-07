import SwiftUI

struct ContentView: View {
  @State private var alert: Bool = false
  @State private var alertMessage: String = ""
  @State private var alertDialog: Bool = false
  
  @State private var kode   : String = ""
  @State private var matkul : String = ""
  @State private var sks    : String = ""
  @State private var bu     : String = ""
  
  let dataManager = DataManager()
  var body: some View {
    NavigationStack {
      List {
        Section {
          TextField("Kode", text: $kode)
          TextField("Mata Kuliah", text: $matkul)
          TextField("SKS", text: $sks)
          TextField("Baru/Ulang", text: $bu)
        } header: {
          Text("Input Data")
        }
        Section {
          Button("Tambah Data", systemImage: "plus", action: {
            if kode.isEmpty || matkul.isEmpty || sks.isEmpty || bu.isEmpty {
              alert.toggle()
              alertMessage = "Semua bidang wajib diisi semua sebelum menambahkan data"
            } else {
              if let dataMatKul = dataManager.get() {
                alertMessage = "Anda harus menghapus data yang sebelumnya ditambahkan sebelum menambah data baru"
                alert.toggle()
              } else {
                dataManager.save(course: Course(kode: kode, matkul: matkul, sks: sks, bu: bu))
                alert.toggle()
                alertMessage = "Data berhasil ditambahkan"
              }
            }
          })
          Button("Tampil Data", systemImage: "eye.fill") {
            if let dataMatKul = dataManager.get() {
              kode   = dataMatKul.kode
              matkul = dataMatKul.matkul
              sks    = dataMatKul.sks
              bu     = dataMatKul.bu
            } else {
              alertMessage = "Tidak ada data tersimpan di database, silakan tambah data terlebih dahulu"
              alert.toggle()
            }
          }
          Button("Edit Data", systemImage: "pencil", action: {
            if kode.isEmpty || matkul.isEmpty || sks.isEmpty || bu.isEmpty {
              alertMessage = "Tampilkan data atau tambah data terlebih dahulu"
              alert.toggle()
            } else if let dataMatKul = dataManager.get(), kode != dataMatKul.kode || matkul != dataMatKul.matkul || sks != dataMatKul.sks || bu != dataMatKul.bu {
              dataManager.save(course: Course(kode: kode, matkul: matkul, sks: sks, bu: bu))
              alert.toggle()
              alertMessage = "Data berhasil diedit"
            } else {
              alert.toggle()
              alertMessage = "Tidak ada data yang diedit"
            }
          })
          
          Button("Kosongkan Bidang", systemImage: "eraser") {
            kode   = ""
            matkul = ""
            sks    = ""
            bu     = ""
          }
          
          Button(action: {
            if kode.isEmpty || matkul.isEmpty || sks.isEmpty || bu.isEmpty {
              alert.toggle()
              alertMessage = "Tampilkan data atau tambah data terlebih dahulu"
            } else {
              alertMessage = "Apakah yakin Anda ingin menghapus data Anda?"
              alertDialog.toggle()
            }
          }, label: {
            Label("Hapus Data", systemImage: "trash")
          })
          .foregroundStyle(.red)
          
          
        } header: {
          Text("Opsi Menu")
        }
      }
      .alert(alertMessage, isPresented: $alert, actions: {})
      .confirmationDialog(alertMessage, isPresented: $alertDialog, titleVisibility: .visible) {
        Button("Hapus data", role: .destructive) {
          dataManager.delete()
          alert.toggle()
          alertMessage = "Data berhasil dihapus!"
          kode   = ""
          matkul = ""
          sks    = ""
          bu     = ""
        }
      }
      .navigationTitle("Aplikasi-Ku")
    }
  }
}

#Preview {
  ContentView()
}
