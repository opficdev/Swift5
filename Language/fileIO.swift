import Foundation

class fstream {
    private var fileHandle: FileHandle? = nil
    private var buffer: Data
    private let bufferSize: Int
    private let fileURL: URL
    private let job: String
    
    init?(_ fileName: String, _ job: String, bufferSize: Int = 4096) {
        self.fileURL = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(fileName)
        self.job = job
         do {
             if job == "r"{
                 self.fileHandle = try FileHandle(forReadingFrom: self.fileURL)
             }
         } catch {
             return nil
         }
         
         self.buffer = Data(capacity: bufferSize)
         self.bufferSize = bufferSize
     }
    deinit {
        if fileHandle != nil{
            fileHandle!.closeFile()
        }
    }
    
    func readLine() -> String? {
        var line = Data()
        var byte: UInt8 = 0
        if self.job != "r"{
            return nil
        }
        
        while true {
            if buffer.isEmpty {
                buffer = fileHandle!.readData(ofLength: bufferSize)
                if buffer.isEmpty {
                    return line.isEmpty ? nil : String(data: line, encoding: .utf8)!
                }
            }
            
            byte = buffer.removeFirst()
            
            if byte == 10 { // 10은 ASCII 코드로 줄바꿈(\n)을 의미합니다.
                return String(data: line, encoding: .utf8)!
            }
            
            line.append(byte)
        }
    }
    
    func read() -> [[String]]{
        var lines: [[String]] = []
        if self.job != "r"{
            return lines
        }
        do {
            let fileHandle = try FileHandle(forReadingFrom: fileURL)
            
            var fileContent = ""

            let data = fileHandle.readDataToEndOfFile()
            if let content = String(data: data, encoding: .utf8) {
                fileContent = content
            }
            fileHandle.closeFile()
            
            let filter = fileContent.contains("\r\n") ? "\r\n" : "\n"
            
            lines = fileContent.split(separator: filter).map{$0.split(separator: " ").map{String($0)}}
            

        } catch {
            print(error)
        }
        return lines
    }
    
    func write(_ str: String){
        if self.job == "w"{
            do {
                try str.write(to: fileURL, atomically: true, encoding: .utf8)
            } catch {
                
            }
        }
    }
    
    
}
