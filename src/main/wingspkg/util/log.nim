from strutils import indent
import terminal

type
    GenericError* = object of Exception
        ## Default exception to throw if there is no error passed in with a `FATAL` call.

type
    AlertLevel* = enum
        ## Level of noise to be logged.
        FATAL = 0,
        ERROR = 1,
        SUCCESS = 2,
        DEPRECATED = 3,
        WARNING = 4,
        INFO = 5,
        DEBUG = 6,

var LEVEL: AlertLevel = DEPRECATED

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
    of DEPRECATED:
        result =
            ansiForegroundColorCode(ForegroundColor.fgYellow) &
            "DEPRECATED" & ansiForegroundColorCode(ForegroundColor.fgDefault)
    of WARNING:
        result =
            ansiForegroundColorCode(ForegroundColor.fgYellow) &
            "WARNING" & ansiForegroundColorCode(ForegroundColor.fgDefault)
    of INFO:
        result =
            ansiForegroundColorCode(ForegroundColor.fgBlue) &
            "INFO" & ansiForegroundColorCode(ForegroundColor.fgDefault)
    of DEBUG:
        result = "DEBUG"

proc LOG*(level: AlertLevel, message: string, exception: typedesc = GenericError): void =
    ## Log message (and possibly throw error).
    if LEVEL >= level:
        echo indent(message, 1, prefix(level) & ": ")
    if level == FATAL:
        raise newException(exception, message)

proc setLevel*(level: AlertLevel): void =
    ## Sets the `AlertLevel`.
    LEVEL = level
    LOG(INFO, "Set logging level to " & $ord(level))