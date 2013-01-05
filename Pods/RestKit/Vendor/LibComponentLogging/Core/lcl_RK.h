//
//
// lcl_RK.h -- LibComponentLogging, embedded, RK
//
// un-embedded by LibComponentLogging-pods, http://0xc0.de/LibComponentLogging#CocoaPods
//

#import "lcl.h"

#define RKlcl_vOff                     lcl_vOff
#define RKlcl_vCritical                lcl_vCritical
#define RKlcl_vError                   lcl_vError
#define RKlcl_vWarning                 lcl_vWarning
#define RKlcl_vInfo                    lcl_vInfo
#define RKlcl_vDebug                   lcl_vDebug
#define RKlcl_vTrace                   lcl_vTrace

#define RKlcl_log                      lcl_log
#define RKlcl_log_if                   lcl_log_if

#define RKlcl_configure_by_component   lcl_configure_by_component
#define RKlcl_configure_by_identifier  lcl_configure_by_identifier
#define RKlcl_configure_by_header      lcl_configure_by_header
#define RKlcl_configure_by_name        lcl_configure_by_name

enum _RKlcl_enum_component_t {
#   define  _RKlcl_component(_identifier, _header, _name)         \
    RKlcl_c##_identifier = lcl_c##_identifier,                    \
    __lcl_log_symbol_RKlcl_c##_identifier = lcl_c##_identifier,
#   include "RestKit/RestKit/Support/lcl_config_components_RK.h"
#   undef   _RKlcl_component
    _RKlcl_component_t_count
};

#define _RKlcl_component_level         _lcl_component_level

#define __RKlcl_log_symbol             __lcl_log_symbol

#define __lcl_log_symbol_RKlcl_vOff       lcl_vOff
#define __lcl_log_symbol_RKlcl_vCritical  lcl_vCritical
#define __lcl_log_symbol_RKlcl_vError     lcl_vError
#define __lcl_log_symbol_RKlcl_vWarning   lcl_vWarning
#define __lcl_log_symbol_RKlcl_vInfo      lcl_vInfo
#define __lcl_log_symbol_RKlcl_vDebug     lcl_vDebug
#define __lcl_log_symbol_RKlcl_vTrace     lcl_vTrace

