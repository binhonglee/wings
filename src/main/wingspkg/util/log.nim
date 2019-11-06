from strutils import indent
import terminal

type
    AlertLevel* = enum
        FATAL = 0,
        ERROR = 1,
        SUCCESS = 2,
        WARNING = 3,
        DEPRECATED = 4,
        INFO = 5,

var LEVEL: AlertLevel = SUCCESS

proc prefix(level: AlertLevel): string =
    case level
    of FATAL:
        result =
            ansiForegroundColorCode(ForegroundColor.fgRed) &
            "FATAL" & ansiForegroundColorCode(ForegroundColor.fgDefault)
    of ERROR:
        result =
            ansiForegroundColorCode(ForegroundColor.fgRed) &
            "ERROR" & ansiForegroundColorCode(ForegroundColor.fgDefault)
    of SUCCESS:
        result =
            ansiForegroundColorCode(ForegroundColor.fgGreen) &
            "SUCCESS" & ansiForegroundColorCode(ForegroundColor.fgDefault)
    of WARNING:
        result =
            ansiForegroundColorCode(ForegroundColor.fgYellow) &
            "WARNING" & ansiForegroundColorCode(ForegroundColor.fgDefault)
    of DEPRECATED:
        result =
            ansiForegroundColorCode(ForegroundColor.fgYellow) &
            "DEPRECATED" & ansiForegroundColorCode(ForegroundColor.fgDefault)
    of INFO:
        result =
            ansiForegroundColorCode(ForegroundColor.fgBlue) &
            "INFO" & ansiForegroundColorCode(ForegroundColor.fgDefault)

proc LOG*(level: AlertLevel, message: string): void =
    if LEVEL >= level:
        echo indent(message, 1, prefix(level) & ": ")

proc setLevel*(level: AlertLevel): void =
    LEVEL = level
    LOG(INFO, "Set logging level to " & $ord(level))