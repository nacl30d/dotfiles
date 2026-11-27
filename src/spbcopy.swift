// Usage: <command> | spbcopy [ttl-seconds]   (default 15, 0 = keep)
import AppKit

let concealed = NSPasteboard.PasteboardType("org.nspasteboard.ConcealedType")
let pb = NSPasteboard.general
let args = CommandLine.arguments

if args.count == 4, args[1] == "--clear" {
    // 親の端末が閉じられても消去を完了させる。
    signal(SIGHUP, SIG_IGN)
    guard let ttl = UInt32(args[2]), let cc = Int(args[3]) else { exit(2) }
    sleep(ttl)
    if pb.changeCount == cc { pb.clearContents() }
    exit(0)
}

let ttl = args.count > 1 ? UInt32(args[1]) : 15
guard let ttl else {
    FileHandle.standardError.write("usage: spbcopy [ttl-seconds]\n".data(using: .utf8)!)
    exit(2)
}

let data = FileHandle.standardInput.readDataToEndOfFile()
guard let text = String(data: data, encoding: .utf8) else { exit(1) }

pb.declareTypes([.string, concealed], owner: nil)
pb.setString(text, forType: .string)
pb.setString("", forType: concealed)

guard ttl > 0 else { exit(0) }

// Swift では fork() が使えないため、自身を別プロセスとして起動して待たずに終了する。
let p = Process()
p.executableURL = Bundle.main.executableURL
p.arguments = ["--clear", String(ttl), String(pb.changeCount)]
p.standardInput = FileHandle.nullDevice
p.standardOutput = FileHandle.nullDevice
p.standardError = FileHandle.nullDevice
try p.run()
