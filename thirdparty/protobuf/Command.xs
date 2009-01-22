#ifdef __cplusplus
extern "C" {
#endif
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#ifdef __cplusplus
}
#endif
#ifdef do_open
#undef do_open
#endif
#ifdef do_close
#undef do_close
#endif
#ifdef New
#undef New
#endif
#include <sstream>
#include <stdint.h>
#include "firewall_command.pb.h"

using namespace std;

typedef ::HoneyClient::Message::Firewall::Command __HoneyClient__Message__Firewall__Command;


static ::HoneyClient::Message::Firewall::Command *
__HoneyClient__Message__Firewall__Command_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message::Firewall::Command * msg0 = new ::HoneyClient::Message::Firewall::Command;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "action", sizeof("action") - 1, 0)) != NULL ) {
      msg0->set_action((HoneyClient::Message::Firewall::Command::ActionType)SvIV(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "response", sizeof("response") - 1, 0)) != NULL ) {
      msg0->set_response((HoneyClient::Message::Firewall::Command::ResponseType)SvIV(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "err_message", sizeof("err_message") - 1, 0)) != NULL ) {
      msg0->set_err_message(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "chain_name", sizeof("chain_name") - 1, 0)) != NULL ) {
      msg0->set_chain_name(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "mac_address", sizeof("mac_address") - 1, 0)) != NULL ) {
      msg0->set_mac_address(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "ip_address", sizeof("ip_address") - 1, 0)) != NULL ) {
      msg0->set_ip_address(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "protocol", sizeof("protocol") - 1, 0)) != NULL ) {
      msg0->set_protocol(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "port", sizeof("port") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          SV ** sv1;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            msg0->add_port(SvUV(*sv1));
          }
        }
      }
    }
  }

  return msg0;
}



MODULE = HoneyClient::Message::Firewall::Command PACKAGE = HoneyClient::Message::Firewall::Command
PROTOTYPES: ENABLE


BOOT:
  {
    HV * stash;

    stash = gv_stashpv("HoneyClient::Message::Firewall::Command::ActionType", TRUE);
    newCONSTSUB(stash, "UNKNOWN", newSViv(::HoneyClient::Message::Firewall::Command::UNKNOWN));
    newCONSTSUB(stash, "DENY_ALL", newSViv(::HoneyClient::Message::Firewall::Command::DENY_ALL));
    newCONSTSUB(stash, "DENY_VM", newSViv(::HoneyClient::Message::Firewall::Command::DENY_VM));
    newCONSTSUB(stash, "ALLOW_VM", newSViv(::HoneyClient::Message::Firewall::Command::ALLOW_VM));
    newCONSTSUB(stash, "ALLOW_ALL", newSViv(::HoneyClient::Message::Firewall::Command::ALLOW_ALL));
    stash = gv_stashpv("HoneyClient::Message::Firewall::Command::ResponseType", TRUE);
    newCONSTSUB(stash, "ERROR", newSViv(::HoneyClient::Message::Firewall::Command::ERROR));
    newCONSTSUB(stash, "OK", newSViv(::HoneyClient::Message::Firewall::Command::OK));
  }


::HoneyClient::Message::Firewall::Command *
::HoneyClient::Message::Firewall::Command::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Firewall::Command") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message__Firewall__Command_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message::Firewall::Command;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message::Firewall::Command;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message::Firewall::Command::copy_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Firewall::Command") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message::Firewall::Command * other = INT2PTR(__HoneyClient__Message__Firewall__Command *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message::Firewall::Command * other = __HoneyClient__Message__Firewall__Command_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message::Firewall::Command::merge_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Firewall::Command") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message::Firewall::Command * other = INT2PTR(__HoneyClient__Message__Firewall__Command *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message::Firewall::Command * other = __HoneyClient__Message__Firewall__Command_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message::Firewall::Command::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message::Firewall::Command::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message::Firewall::Command::error_string()
  PREINIT:
    string estr;

  CODE:
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message::Firewall::Command::debug_string()
  PREINIT:
    string dstr;

  CODE:
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message::Firewall::Command::short_debug_string()
  PREINIT:
    string dstr;

  CODE:
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
::HoneyClient::Message::Firewall::Command::unpack(arg)
  SV *arg;
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    if ( THIS != NULL ) {
      str = SvPV(arg, len);
      if ( str != NULL ) {
        RETVAL = THIS->ParseFromArray(str, len);
      } else {
        RETVAL = 0;
      }
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message::Firewall::Command::pack()
  PREINIT:
    string output;

  CODE:
    if ( THIS != NULL ) {
      if ( THIS->SerializeToString(&output) == true ) {
        RETVAL = newSVpv(output.c_str(), output.length());
      } else {
        RETVAL = Nullsv;
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
::HoneyClient::Message::Firewall::Command::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::fields()
  PPCODE:
    EXTEND(SP, 8);
    PUSHs(sv_2mortal(newSVpv("action",0)));
    PUSHs(sv_2mortal(newSVpv("response",0)));
    PUSHs(sv_2mortal(newSVpv("err_message",0)));
    PUSHs(sv_2mortal(newSVpv("chain_name",0)));
    PUSHs(sv_2mortal(newSVpv("mac_address",0)));
    PUSHs(sv_2mortal(newSVpv("ip_address",0)));
    PUSHs(sv_2mortal(newSVpv("protocol",0)));
    PUSHs(sv_2mortal(newSVpv("port",0)));


SV *
::HoneyClient::Message::Firewall::Command::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message::Firewall::Command * msg0 = THIS;

      if ( msg0->has_action() ) {
        SV * sv0 = newSViv(msg0->action());
        hv_store(hv0, "action", sizeof("action") - 1, sv0, 0);
      }
      if ( msg0->has_response() ) {
        SV * sv0 = newSViv(msg0->response());
        hv_store(hv0, "response", sizeof("response") - 1, sv0, 0);
      }
      if ( msg0->has_err_message() ) {
        SV * sv0 = newSVpv(msg0->err_message().c_str(), msg0->err_message().length());
        hv_store(hv0, "err_message", sizeof("err_message") - 1, sv0, 0);
      }
      if ( msg0->has_chain_name() ) {
        SV * sv0 = newSVpv(msg0->chain_name().c_str(), msg0->chain_name().length());
        hv_store(hv0, "chain_name", sizeof("chain_name") - 1, sv0, 0);
      }
      if ( msg0->has_mac_address() ) {
        SV * sv0 = newSVpv(msg0->mac_address().c_str(), msg0->mac_address().length());
        hv_store(hv0, "mac_address", sizeof("mac_address") - 1, sv0, 0);
      }
      if ( msg0->has_ip_address() ) {
        SV * sv0 = newSVpv(msg0->ip_address().c_str(), msg0->ip_address().length());
        hv_store(hv0, "ip_address", sizeof("ip_address") - 1, sv0, 0);
      }
      if ( msg0->has_protocol() ) {
        SV * sv0 = newSVpv(msg0->protocol().c_str(), msg0->protocol().length());
        hv_store(hv0, "protocol", sizeof("protocol") - 1, sv0, 0);
      }
      if ( msg0->port_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->port_size(); i0++ ) {
          SV * sv1 = newSVuv(msg0->port(i0));
          av_push(av0, sv1);
        }
        hv_store(hv0, "port", sizeof("port") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
::HoneyClient::Message::Firewall::Command::has_action()
  CODE:
    RETVAL = THIS->has_action();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::clear_action()
  CODE:
    THIS->clear_action();


void
::HoneyClient::Message::Firewall::Command::action()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->action()));
      PUSHs(sv);
    }


void
::HoneyClient::Message::Firewall::Command::set_action(val)
  IV val

  CODE:
    if ( ::HoneyClient::Message::Firewall::Command_ActionType_IsValid(val) ) {
      THIS->set_action((::HoneyClient::Message::Firewall::Command_ActionType)val);
    }


I32
::HoneyClient::Message::Firewall::Command::has_response()
  CODE:
    RETVAL = THIS->has_response();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::clear_response()
  CODE:
    THIS->clear_response();


void
::HoneyClient::Message::Firewall::Command::response()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->response()));
      PUSHs(sv);
    }


void
::HoneyClient::Message::Firewall::Command::set_response(val)
  IV val

  CODE:
    if ( ::HoneyClient::Message::Firewall::Command_ResponseType_IsValid(val) ) {
      THIS->set_response((::HoneyClient::Message::Firewall::Command_ResponseType)val);
    }


I32
::HoneyClient::Message::Firewall::Command::has_err_message()
  CODE:
    RETVAL = THIS->has_err_message();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::clear_err_message()
  CODE:
    THIS->clear_err_message();


void
::HoneyClient::Message::Firewall::Command::err_message()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->err_message().c_str(),
                              THIS->err_message().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message::Firewall::Command::set_err_message(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_err_message(sval);


I32
::HoneyClient::Message::Firewall::Command::has_chain_name()
  CODE:
    RETVAL = THIS->has_chain_name();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::clear_chain_name()
  CODE:
    THIS->clear_chain_name();


void
::HoneyClient::Message::Firewall::Command::chain_name()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->chain_name().c_str(),
                              THIS->chain_name().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message::Firewall::Command::set_chain_name(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_chain_name(sval);


I32
::HoneyClient::Message::Firewall::Command::has_mac_address()
  CODE:
    RETVAL = THIS->has_mac_address();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::clear_mac_address()
  CODE:
    THIS->clear_mac_address();


void
::HoneyClient::Message::Firewall::Command::mac_address()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->mac_address().c_str(),
                              THIS->mac_address().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message::Firewall::Command::set_mac_address(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_mac_address(sval);


I32
::HoneyClient::Message::Firewall::Command::has_ip_address()
  CODE:
    RETVAL = THIS->has_ip_address();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::clear_ip_address()
  CODE:
    THIS->clear_ip_address();


void
::HoneyClient::Message::Firewall::Command::ip_address()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->ip_address().c_str(),
                              THIS->ip_address().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message::Firewall::Command::set_ip_address(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_ip_address(sval);


I32
::HoneyClient::Message::Firewall::Command::has_protocol()
  CODE:
    RETVAL = THIS->has_protocol();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::clear_protocol()
  CODE:
    THIS->clear_protocol();


void
::HoneyClient::Message::Firewall::Command::protocol()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->protocol().c_str(),
                              THIS->protocol().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message::Firewall::Command::set_protocol(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_protocol(sval);


I32
::HoneyClient::Message::Firewall::Command::port_size()
  CODE:
    RETVAL = THIS->port_size();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::Firewall::Command::clear_port()
  CODE:
    THIS->clear_port();


void
::HoneyClient::Message::Firewall::Command::port(...)
  PREINIT:
    SV * sv;
    int index = 0;

  PPCODE:
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::Firewall::Command::port(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->port_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          sv = sv_2mortal(newSVuv(THIS->port(index)));
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->port_size() ) {
        EXTEND(SP,1);
        sv = sv_2mortal(newSVuv(THIS->port(index)));
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
::HoneyClient::Message::Firewall::Command::add_port(val)
  UV val

  CODE:
    THIS->add_port(val);


