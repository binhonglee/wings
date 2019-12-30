import tables
import ./goConfig, ./ktConfig, ./nimConfig, ./pyConfig, ./tsConfig
import ../lib/tconfig

let DEFAULT_CONFIGS*: Table[string, TConfig] = {
    GO_CONFIG.filetype: GO_CONFIG,
    KT_CONFIG.filetype: KT_CONFIG,
    NIM_CONFIG.filetype: NIM_CONFIG,
    PY_CONFIG.filetype: PY_CONFIG,
    TS_CONFIG.filetype: TS_CONFIG,
}.toTable()
