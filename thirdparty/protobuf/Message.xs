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
#include <stdint.h>
#include <sstream>
#include <google/protobuf/stubs/common.h>
#include <google/protobuf/io/zero_copy_stream.h>
#include "message.pb.h"

using namespace std;

class message_OutputStream :
  public google::protobuf::io::ZeroCopyOutputStream {
public:
  explicit message_OutputStream(SV * sv) :
  sv_(sv), len_(0) {}
  ~message_OutputStream() {}

  bool Next(void** data, int* size)
  {
    STRLEN nlen = len_ << 1;

    if ( nlen < 16 ) nlen = 16;
    SvGROW(sv_, nlen);
    *data = SvEND(sv_) + len_;
    *size = SvLEN(sv_) - len_;
    len_ = nlen;

    return true;
  }

  void BackUp(int count)
  {
    SvCUR_set(sv_, SvLEN(sv_) - count);
  }

  void Sync() {
    if ( SvCUR(sv_) == 0 ) {
      SvCUR_set(sv_, len_);
    }
  }

  int64_t ByteCount() const
  {
    return (int64_t)SvCUR(sv_);
  }

private:
  SV * sv_;
  STRLEN len_;

  GOOGLE_DISALLOW_EVIL_CONSTRUCTORS(message_OutputStream);
};


typedef ::HoneyClient::Message_Application __HoneyClient__Message_Application;
typedef ::HoneyClient::Message_Os __HoneyClient__Message_Os;
typedef ::HoneyClient::Message_ClientStatus __HoneyClient__Message_ClientStatus;
typedef ::HoneyClient::Message_Host __HoneyClient__Message_Host;
typedef ::HoneyClient::Message_Client __HoneyClient__Message_Client;
typedef ::HoneyClient::Message_Group __HoneyClient__Message_Group;
typedef ::HoneyClient::Message_JobSource __HoneyClient__Message_JobSource;
typedef ::HoneyClient::Message_JobAlert __HoneyClient__Message_JobAlert;
typedef ::HoneyClient::Message_UrlStatus __HoneyClient__Message_UrlStatus;
typedef ::HoneyClient::Message_Url __HoneyClient__Message_Url;
typedef ::HoneyClient::Message_Job __HoneyClient__Message_Job;
typedef ::HoneyClient::Message_FileContent __HoneyClient__Message_FileContent;
typedef ::HoneyClient::Message_ProcessFile __HoneyClient__Message_ProcessFile;
typedef ::HoneyClient::Message_ProcessRegistry __HoneyClient__Message_ProcessRegistry;
typedef ::HoneyClient::Message_OsProcess __HoneyClient__Message_OsProcess;
typedef ::HoneyClient::Message_Fingerprint __HoneyClient__Message_Fingerprint;
typedef ::HoneyClient::Message_Firewall_Command __HoneyClient__Message_Firewall_Command;
typedef ::HoneyClient::Message_Firewall __HoneyClient__Message_Firewall;
typedef ::HoneyClient::Message_Pcap_Command __HoneyClient__Message_Pcap_Command;
typedef ::HoneyClient::Message_Pcap __HoneyClient__Message_Pcap;
typedef ::HoneyClient::Message __HoneyClient__Message;


static ::HoneyClient::Message_Application *
__HoneyClient__Message_Application_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Application * msg0 = new ::HoneyClient::Message_Application;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "manufacturer", sizeof("manufacturer") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_manufacturer(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "version", sizeof("version") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_version(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_short_name(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Os *
__HoneyClient__Message_Os_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Os * msg0 = new ::HoneyClient::Message_Os;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "version", sizeof("version") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_version(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_short_name(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_ClientStatus *
__HoneyClient__Message_ClientStatus_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_ClientStatus * msg0 = new ::HoneyClient::Message_ClientStatus;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "status", sizeof("status") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_status(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "description", sizeof("description") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_description(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Host *
__HoneyClient__Message_Host_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Host * msg0 = new ::HoneyClient::Message_Host;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "hostname", sizeof("hostname") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_hostname(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "ip", sizeof("ip") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_ip(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Client *
__HoneyClient__Message_Client_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Client * msg0 = new ::HoneyClient::Message_Client;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "quick_clone_name", sizeof("quick_clone_name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_quick_clone_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "snapshot_name", sizeof("snapshot_name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_snapshot_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "created_at", sizeof("created_at") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_created_at(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "os", sizeof("os") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_Os * msg2 = msg0->mutable_os();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_name(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "version", sizeof("version") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_version(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_short_name(sval);
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "application", sizeof("application") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_Application * msg2 = msg0->mutable_application();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "manufacturer", sizeof("manufacturer") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_manufacturer(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "version", sizeof("version") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_version(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_short_name(sval);
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "client_status", sizeof("client_status") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_ClientStatus * msg2 = msg0->mutable_client_status();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "status", sizeof("status") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_status(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "description", sizeof("description") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_description(sval);
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "host", sizeof("host") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_Host * msg2 = msg0->mutable_host();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "hostname", sizeof("hostname") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_hostname(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "ip", sizeof("ip") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_ip(sval);
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "suspended_at", sizeof("suspended_at") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_suspended_at(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "ip", sizeof("ip") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_ip(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "mac", sizeof("mac") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_mac(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Group *
__HoneyClient__Message_Group_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Group * msg0 = new ::HoneyClient::Message_Group;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_name(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_JobSource *
__HoneyClient__Message_JobSource_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_JobSource * msg0 = new ::HoneyClient::Message_JobSource;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "protocol", sizeof("protocol") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_protocol(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "group", sizeof("group") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_Group * msg2 = msg0->mutable_group();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_name(sval);
        }
      }
    }
  }

  return msg0;
}

static ::HoneyClient::Message_JobAlert *
__HoneyClient__Message_JobAlert_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_JobAlert * msg0 = new ::HoneyClient::Message_JobAlert;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "protocol", sizeof("protocol") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_protocol(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "address", sizeof("address") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_address(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_UrlStatus *
__HoneyClient__Message_UrlStatus_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_UrlStatus * msg0 = new ::HoneyClient::Message_UrlStatus;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "status", sizeof("status") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_status(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "description", sizeof("description") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_description(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Url *
__HoneyClient__Message_Url_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Url * msg0 = new ::HoneyClient::Message_Url;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "url", sizeof("url") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_url(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "priority", sizeof("priority") - 1, 0)) != NULL ) {
      uint64_t uv0 = strtoull(SvPV_nolen(*sv1), NULL, 0);
      
      msg0->set_priority(uv0);
    }
    if ( (sv1 = hv_fetch(hv0, "url_status", sizeof("url_status") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_UrlStatus * msg2 = msg0->mutable_url_status();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "status", sizeof("status") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_status(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "description", sizeof("description") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_description(sval);
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
      msg0->set_time_at(SvNV(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "client", sizeof("client") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_Client * msg2 = msg0->mutable_client();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "quick_clone_name", sizeof("quick_clone_name") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_quick_clone_name(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "snapshot_name", sizeof("snapshot_name") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_snapshot_name(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "created_at", sizeof("created_at") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_created_at(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "os", sizeof("os") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_Os * msg4 = msg2->mutable_os();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "name", sizeof("name") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_name(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "version", sizeof("version") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_version(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_short_name(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "application", sizeof("application") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_Application * msg4 = msg2->mutable_application();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "manufacturer", sizeof("manufacturer") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_manufacturer(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "version", sizeof("version") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_version(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_short_name(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "client_status", sizeof("client_status") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_ClientStatus * msg4 = msg2->mutable_client_status();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "status", sizeof("status") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_status(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "description", sizeof("description") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_description(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "host", sizeof("host") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_Host * msg4 = msg2->mutable_host();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "hostname", sizeof("hostname") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_hostname(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "ip", sizeof("ip") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_ip(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "suspended_at", sizeof("suspended_at") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_suspended_at(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "ip", sizeof("ip") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_ip(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "mac", sizeof("mac") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_mac(sval);
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "ip", sizeof("ip") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_ip(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Job *
__HoneyClient__Message_Job_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Job * msg0 = new ::HoneyClient::Message_Job;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "uuid", sizeof("uuid") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_uuid(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "job_source", sizeof("job_source") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_JobSource * msg2 = msg0->mutable_job_source();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_name(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "protocol", sizeof("protocol") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_protocol(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "group", sizeof("group") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_Group * msg4 = msg2->mutable_group();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "name", sizeof("name") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_name(sval);
            }
          }
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "created_at", sizeof("created_at") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_created_at(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "completed_at", sizeof("completed_at") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_completed_at(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "client", sizeof("client") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_Client * msg2 = msg0->mutable_client();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "quick_clone_name", sizeof("quick_clone_name") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_quick_clone_name(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "snapshot_name", sizeof("snapshot_name") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_snapshot_name(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "created_at", sizeof("created_at") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_created_at(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "os", sizeof("os") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_Os * msg4 = msg2->mutable_os();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "name", sizeof("name") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_name(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "version", sizeof("version") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_version(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_short_name(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "application", sizeof("application") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_Application * msg4 = msg2->mutable_application();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "manufacturer", sizeof("manufacturer") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_manufacturer(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "version", sizeof("version") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_version(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_short_name(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "client_status", sizeof("client_status") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_ClientStatus * msg4 = msg2->mutable_client_status();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "status", sizeof("status") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_status(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "description", sizeof("description") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_description(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "host", sizeof("host") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_Host * msg4 = msg2->mutable_host();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "hostname", sizeof("hostname") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_hostname(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "ip", sizeof("ip") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_ip(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "suspended_at", sizeof("suspended_at") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_suspended_at(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "ip", sizeof("ip") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_ip(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "mac", sizeof("mac") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_mac(sval);
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "job_alerts", sizeof("job_alerts") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          ::HoneyClient::Message_JobAlert * msg2 = msg0->add_job_alerts();
          SV ** sv1;
          SV *  sv2;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            sv2 = *sv1;
            if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
              HV *  hv2 = (HV *)SvRV(sv2);
              SV ** sv3;
              
              if ( (sv3 = hv_fetch(hv2, "protocol", sizeof("protocol") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_protocol(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "address", sizeof("address") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_address(sval);
              }
            }
          }
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "urls", sizeof("urls") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          ::HoneyClient::Message_Url * msg2 = msg0->add_urls();
          SV ** sv1;
          SV *  sv2;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            sv2 = *sv1;
            if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
              HV *  hv2 = (HV *)SvRV(sv2);
              SV ** sv3;
              
              if ( (sv3 = hv_fetch(hv2, "url", sizeof("url") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_url(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "priority", sizeof("priority") - 1, 0)) != NULL ) {
                uint64_t uv2 = strtoull(SvPV_nolen(*sv3), NULL, 0);
                
                msg2->set_priority(uv2);
              }
              if ( (sv3 = hv_fetch(hv2, "url_status", sizeof("url_status") - 1, 0)) != NULL ) {
                ::HoneyClient::Message_UrlStatus * msg4 = msg2->mutable_url_status();
                SV * sv4 = *sv3;
                
                if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                  HV *  hv4 = (HV *)SvRV(sv4);
                  SV ** sv5;
                  
                  if ( (sv5 = hv_fetch(hv4, "status", sizeof("status") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_status(sval);
                  }
                  if ( (sv5 = hv_fetch(hv4, "description", sizeof("description") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_description(sval);
                  }
                }
              }
              if ( (sv3 = hv_fetch(hv2, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                msg2->set_time_at(SvNV(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "client", sizeof("client") - 1, 0)) != NULL ) {
                ::HoneyClient::Message_Client * msg4 = msg2->mutable_client();
                SV * sv4 = *sv3;
                
                if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                  HV *  hv4 = (HV *)SvRV(sv4);
                  SV ** sv5;
                  
                  if ( (sv5 = hv_fetch(hv4, "quick_clone_name", sizeof("quick_clone_name") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_quick_clone_name(sval);
                  }
                  if ( (sv5 = hv_fetch(hv4, "snapshot_name", sizeof("snapshot_name") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_snapshot_name(sval);
                  }
                  if ( (sv5 = hv_fetch(hv4, "created_at", sizeof("created_at") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_created_at(sval);
                  }
                  if ( (sv5 = hv_fetch(hv4, "os", sizeof("os") - 1, 0)) != NULL ) {
                    ::HoneyClient::Message_Os * msg6 = msg4->mutable_os();
                    SV * sv6 = *sv5;
                    
                    if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                      HV *  hv6 = (HV *)SvRV(sv6);
                      SV ** sv7;
                      
                      if ( (sv7 = hv_fetch(hv6, "name", sizeof("name") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_name(sval);
                      }
                      if ( (sv7 = hv_fetch(hv6, "version", sizeof("version") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_version(sval);
                      }
                      if ( (sv7 = hv_fetch(hv6, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_short_name(sval);
                      }
                    }
                  }
                  if ( (sv5 = hv_fetch(hv4, "application", sizeof("application") - 1, 0)) != NULL ) {
                    ::HoneyClient::Message_Application * msg6 = msg4->mutable_application();
                    SV * sv6 = *sv5;
                    
                    if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                      HV *  hv6 = (HV *)SvRV(sv6);
                      SV ** sv7;
                      
                      if ( (sv7 = hv_fetch(hv6, "manufacturer", sizeof("manufacturer") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_manufacturer(sval);
                      }
                      if ( (sv7 = hv_fetch(hv6, "version", sizeof("version") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_version(sval);
                      }
                      if ( (sv7 = hv_fetch(hv6, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_short_name(sval);
                      }
                    }
                  }
                  if ( (sv5 = hv_fetch(hv4, "client_status", sizeof("client_status") - 1, 0)) != NULL ) {
                    ::HoneyClient::Message_ClientStatus * msg6 = msg4->mutable_client_status();
                    SV * sv6 = *sv5;
                    
                    if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                      HV *  hv6 = (HV *)SvRV(sv6);
                      SV ** sv7;
                      
                      if ( (sv7 = hv_fetch(hv6, "status", sizeof("status") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_status(sval);
                      }
                      if ( (sv7 = hv_fetch(hv6, "description", sizeof("description") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_description(sval);
                      }
                    }
                  }
                  if ( (sv5 = hv_fetch(hv4, "host", sizeof("host") - 1, 0)) != NULL ) {
                    ::HoneyClient::Message_Host * msg6 = msg4->mutable_host();
                    SV * sv6 = *sv5;
                    
                    if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                      HV *  hv6 = (HV *)SvRV(sv6);
                      SV ** sv7;
                      
                      if ( (sv7 = hv_fetch(hv6, "hostname", sizeof("hostname") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_hostname(sval);
                      }
                      if ( (sv7 = hv_fetch(hv6, "ip", sizeof("ip") - 1, 0)) != NULL ) {
                        STRLEN len;
                        char * str;
                        string sval;
                        
                        str = SvPV(*sv7, len);
                        sval.assign(str, len);
                        msg6->set_ip(sval);
                      }
                    }
                  }
                  if ( (sv5 = hv_fetch(hv4, "suspended_at", sizeof("suspended_at") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_suspended_at(sval);
                  }
                  if ( (sv5 = hv_fetch(hv4, "ip", sizeof("ip") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_ip(sval);
                  }
                  if ( (sv5 = hv_fetch(hv4, "mac", sizeof("mac") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_mac(sval);
                  }
                }
              }
              if ( (sv3 = hv_fetch(hv2, "ip", sizeof("ip") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_ip(sval);
              }
            }
          }
        }
      }
    }
  }

  return msg0;
}

static ::HoneyClient::Message_FileContent *
__HoneyClient__Message_FileContent_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_FileContent * msg0 = new ::HoneyClient::Message_FileContent;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "size", sizeof("size") - 1, 0)) != NULL ) {
      uint64_t uv0 = strtoull(SvPV_nolen(*sv1), NULL, 0);
      
      msg0->set_size(uv0);
    }
    if ( (sv1 = hv_fetch(hv0, "md5", sizeof("md5") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_md5(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_sha1(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_mime_type(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "data", sizeof("data") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_data(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_ProcessFile *
__HoneyClient__Message_ProcessFile_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_ProcessFile * msg0 = new ::HoneyClient::Message_ProcessFile;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
      msg0->set_time_at(SvNV(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "event", sizeof("event") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_event(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "file_content", sizeof("file_content") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_FileContent * msg2 = msg0->mutable_file_content();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "size", sizeof("size") - 1, 0)) != NULL ) {
          uint64_t uv2 = strtoull(SvPV_nolen(*sv3), NULL, 0);
          
          msg2->set_size(uv2);
        }
        if ( (sv3 = hv_fetch(hv2, "md5", sizeof("md5") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_md5(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_sha1(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_mime_type(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "data", sizeof("data") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_data(sval);
        }
      }
    }
  }

  return msg0;
}

static ::HoneyClient::Message_ProcessRegistry *
__HoneyClient__Message_ProcessRegistry_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_ProcessRegistry * msg0 = new ::HoneyClient::Message_ProcessRegistry;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
      msg0->set_time_at(SvNV(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "event", sizeof("event") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_event(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "value_name", sizeof("value_name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_value_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "value_type", sizeof("value_type") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_value_type(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "value", sizeof("value") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_value(sval);
    }
  }

  return msg0;
}

static ::HoneyClient::Message_OsProcess *
__HoneyClient__Message_OsProcess_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_OsProcess * msg0 = new ::HoneyClient::Message_OsProcess;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "pid", sizeof("pid") - 1, 0)) != NULL ) {
      uint64_t uv0 = strtoull(SvPV_nolen(*sv1), NULL, 0);
      
      msg0->set_pid(uv0);
    }
    if ( (sv1 = hv_fetch(hv0, "parent_name", sizeof("parent_name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_parent_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "parent_pid", sizeof("parent_pid") - 1, 0)) != NULL ) {
      uint64_t uv0 = strtoull(SvPV_nolen(*sv1), NULL, 0);
      
      msg0->set_parent_pid(uv0);
    }
    if ( (sv1 = hv_fetch(hv0, "process_files", sizeof("process_files") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          ::HoneyClient::Message_ProcessFile * msg2 = msg0->add_process_files();
          SV ** sv1;
          SV *  sv2;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            sv2 = *sv1;
            if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
              HV *  hv2 = (HV *)SvRV(sv2);
              SV ** sv3;
              
              if ( (sv3 = hv_fetch(hv2, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                msg2->set_time_at(SvNV(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_name(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "event", sizeof("event") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_event(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "file_content", sizeof("file_content") - 1, 0)) != NULL ) {
                ::HoneyClient::Message_FileContent * msg4 = msg2->mutable_file_content();
                SV * sv4 = *sv3;
                
                if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                  HV *  hv4 = (HV *)SvRV(sv4);
                  SV ** sv5;
                  
                  if ( (sv5 = hv_fetch(hv4, "size", sizeof("size") - 1, 0)) != NULL ) {
                    uint64_t uv4 = strtoull(SvPV_nolen(*sv5), NULL, 0);
                    
                    msg4->set_size(uv4);
                  }
                  if ( (sv5 = hv_fetch(hv4, "md5", sizeof("md5") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_md5(sval);
                  }
                  if ( (sv5 = hv_fetch(hv4, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_sha1(sval);
                  }
                  if ( (sv5 = hv_fetch(hv4, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_mime_type(sval);
                  }
                  if ( (sv5 = hv_fetch(hv4, "data", sizeof("data") - 1, 0)) != NULL ) {
                    STRLEN len;
                    char * str;
                    string sval;
                    
                    str = SvPV(*sv5, len);
                    sval.assign(str, len);
                    msg4->set_data(sval);
                  }
                }
              }
            }
          }
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "process_registries", sizeof("process_registries") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          ::HoneyClient::Message_ProcessRegistry * msg2 = msg0->add_process_registries();
          SV ** sv1;
          SV *  sv2;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            sv2 = *sv1;
            if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
              HV *  hv2 = (HV *)SvRV(sv2);
              SV ** sv3;
              
              if ( (sv3 = hv_fetch(hv2, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                msg2->set_time_at(SvNV(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_name(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "event", sizeof("event") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_event(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "value_name", sizeof("value_name") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_value_name(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "value_type", sizeof("value_type") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_value_type(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "value", sizeof("value") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_value(sval);
              }
            }
          }
        }
      }
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Fingerprint *
__HoneyClient__Message_Fingerprint_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Fingerprint * msg0 = new ::HoneyClient::Message_Fingerprint;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "checksum", sizeof("checksum") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_checksum(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "pcap", sizeof("pcap") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_pcap(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "url", sizeof("url") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_Url * msg2 = msg0->mutable_url();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "url", sizeof("url") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_url(sval);
        }
        if ( (sv3 = hv_fetch(hv2, "priority", sizeof("priority") - 1, 0)) != NULL ) {
          uint64_t uv2 = strtoull(SvPV_nolen(*sv3), NULL, 0);
          
          msg2->set_priority(uv2);
        }
        if ( (sv3 = hv_fetch(hv2, "url_status", sizeof("url_status") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_UrlStatus * msg4 = msg2->mutable_url_status();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "status", sizeof("status") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_status(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "description", sizeof("description") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_description(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
          msg2->set_time_at(SvNV(*sv3));
        }
        if ( (sv3 = hv_fetch(hv2, "client", sizeof("client") - 1, 0)) != NULL ) {
          ::HoneyClient::Message_Client * msg4 = msg2->mutable_client();
          SV * sv4 = *sv3;
          
          if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
            HV *  hv4 = (HV *)SvRV(sv4);
            SV ** sv5;
            
            if ( (sv5 = hv_fetch(hv4, "quick_clone_name", sizeof("quick_clone_name") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_quick_clone_name(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "snapshot_name", sizeof("snapshot_name") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_snapshot_name(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "created_at", sizeof("created_at") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_created_at(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "os", sizeof("os") - 1, 0)) != NULL ) {
              ::HoneyClient::Message_Os * msg6 = msg4->mutable_os();
              SV * sv6 = *sv5;
              
              if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                HV *  hv6 = (HV *)SvRV(sv6);
                SV ** sv7;
                
                if ( (sv7 = hv_fetch(hv6, "name", sizeof("name") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_name(sval);
                }
                if ( (sv7 = hv_fetch(hv6, "version", sizeof("version") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_version(sval);
                }
                if ( (sv7 = hv_fetch(hv6, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_short_name(sval);
                }
              }
            }
            if ( (sv5 = hv_fetch(hv4, "application", sizeof("application") - 1, 0)) != NULL ) {
              ::HoneyClient::Message_Application * msg6 = msg4->mutable_application();
              SV * sv6 = *sv5;
              
              if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                HV *  hv6 = (HV *)SvRV(sv6);
                SV ** sv7;
                
                if ( (sv7 = hv_fetch(hv6, "manufacturer", sizeof("manufacturer") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_manufacturer(sval);
                }
                if ( (sv7 = hv_fetch(hv6, "version", sizeof("version") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_version(sval);
                }
                if ( (sv7 = hv_fetch(hv6, "short_name", sizeof("short_name") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_short_name(sval);
                }
              }
            }
            if ( (sv5 = hv_fetch(hv4, "client_status", sizeof("client_status") - 1, 0)) != NULL ) {
              ::HoneyClient::Message_ClientStatus * msg6 = msg4->mutable_client_status();
              SV * sv6 = *sv5;
              
              if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                HV *  hv6 = (HV *)SvRV(sv6);
                SV ** sv7;
                
                if ( (sv7 = hv_fetch(hv6, "status", sizeof("status") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_status(sval);
                }
                if ( (sv7 = hv_fetch(hv6, "description", sizeof("description") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_description(sval);
                }
              }
            }
            if ( (sv5 = hv_fetch(hv4, "host", sizeof("host") - 1, 0)) != NULL ) {
              ::HoneyClient::Message_Host * msg6 = msg4->mutable_host();
              SV * sv6 = *sv5;
              
              if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                HV *  hv6 = (HV *)SvRV(sv6);
                SV ** sv7;
                
                if ( (sv7 = hv_fetch(hv6, "hostname", sizeof("hostname") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_hostname(sval);
                }
                if ( (sv7 = hv_fetch(hv6, "ip", sizeof("ip") - 1, 0)) != NULL ) {
                  STRLEN len;
                  char * str;
                  string sval;
                  
                  str = SvPV(*sv7, len);
                  sval.assign(str, len);
                  msg6->set_ip(sval);
                }
              }
            }
            if ( (sv5 = hv_fetch(hv4, "suspended_at", sizeof("suspended_at") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_suspended_at(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "ip", sizeof("ip") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_ip(sval);
            }
            if ( (sv5 = hv_fetch(hv4, "mac", sizeof("mac") - 1, 0)) != NULL ) {
              STRLEN len;
              char * str;
              string sval;
              
              str = SvPV(*sv5, len);
              sval.assign(str, len);
              msg4->set_mac(sval);
            }
          }
        }
        if ( (sv3 = hv_fetch(hv2, "ip", sizeof("ip") - 1, 0)) != NULL ) {
          STRLEN len;
          char * str;
          string sval;
          
          str = SvPV(*sv3, len);
          sval.assign(str, len);
          msg2->set_ip(sval);
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "os_processes", sizeof("os_processes") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          ::HoneyClient::Message_OsProcess * msg2 = msg0->add_os_processes();
          SV ** sv1;
          SV *  sv2;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            sv2 = *sv1;
            if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
              HV *  hv2 = (HV *)SvRV(sv2);
              SV ** sv3;
              
              if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_name(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "pid", sizeof("pid") - 1, 0)) != NULL ) {
                uint64_t uv2 = strtoull(SvPV_nolen(*sv3), NULL, 0);
                
                msg2->set_pid(uv2);
              }
              if ( (sv3 = hv_fetch(hv2, "parent_name", sizeof("parent_name") - 1, 0)) != NULL ) {
                STRLEN len;
                char * str;
                string sval;
                
                str = SvPV(*sv3, len);
                sval.assign(str, len);
                msg2->set_parent_name(sval);
              }
              if ( (sv3 = hv_fetch(hv2, "parent_pid", sizeof("parent_pid") - 1, 0)) != NULL ) {
                uint64_t uv2 = strtoull(SvPV_nolen(*sv3), NULL, 0);
                
                msg2->set_parent_pid(uv2);
              }
              if ( (sv3 = hv_fetch(hv2, "process_files", sizeof("process_files") - 1, 0)) != NULL ) {
                if ( SvROK(*sv3) && SvTYPE(SvRV(*sv3)) == SVt_PVAV ) {
                  AV * av3 = (AV *)SvRV(*sv3);
                  
                  for ( int i3 = 0; i3 <= av_len(av3); i3++ ) {
                    ::HoneyClient::Message_ProcessFile * msg4 = msg2->add_process_files();
                    SV ** sv3;
                    SV *  sv4;
                    
                    if ( (sv3 = av_fetch(av3, i3, 0)) != NULL ) {
                      sv4 = *sv3;
                      if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                        HV *  hv4 = (HV *)SvRV(sv4);
                        SV ** sv5;
                        
                        if ( (sv5 = hv_fetch(hv4, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                          msg4->set_time_at(SvNV(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "name", sizeof("name") - 1, 0)) != NULL ) {
                          STRLEN len;
                          char * str;
                          string sval;
                          
                          str = SvPV(*sv5, len);
                          sval.assign(str, len);
                          msg4->set_name(sval);
                        }
                        if ( (sv5 = hv_fetch(hv4, "event", sizeof("event") - 1, 0)) != NULL ) {
                          STRLEN len;
                          char * str;
                          string sval;
                          
                          str = SvPV(*sv5, len);
                          sval.assign(str, len);
                          msg4->set_event(sval);
                        }
                        if ( (sv5 = hv_fetch(hv4, "file_content", sizeof("file_content") - 1, 0)) != NULL ) {
                          ::HoneyClient::Message_FileContent * msg6 = msg4->mutable_file_content();
                          SV * sv6 = *sv5;
                          
                          if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                            HV *  hv6 = (HV *)SvRV(sv6);
                            SV ** sv7;
                            
                            if ( (sv7 = hv_fetch(hv6, "size", sizeof("size") - 1, 0)) != NULL ) {
                              uint64_t uv6 = strtoull(SvPV_nolen(*sv7), NULL, 0);
                              
                              msg6->set_size(uv6);
                            }
                            if ( (sv7 = hv_fetch(hv6, "md5", sizeof("md5") - 1, 0)) != NULL ) {
                              STRLEN len;
                              char * str;
                              string sval;
                              
                              str = SvPV(*sv7, len);
                              sval.assign(str, len);
                              msg6->set_md5(sval);
                            }
                            if ( (sv7 = hv_fetch(hv6, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
                              STRLEN len;
                              char * str;
                              string sval;
                              
                              str = SvPV(*sv7, len);
                              sval.assign(str, len);
                              msg6->set_sha1(sval);
                            }
                            if ( (sv7 = hv_fetch(hv6, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
                              STRLEN len;
                              char * str;
                              string sval;
                              
                              str = SvPV(*sv7, len);
                              sval.assign(str, len);
                              msg6->set_mime_type(sval);
                            }
                            if ( (sv7 = hv_fetch(hv6, "data", sizeof("data") - 1, 0)) != NULL ) {
                              STRLEN len;
                              char * str;
                              string sval;
                              
                              str = SvPV(*sv7, len);
                              sval.assign(str, len);
                              msg6->set_data(sval);
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              if ( (sv3 = hv_fetch(hv2, "process_registries", sizeof("process_registries") - 1, 0)) != NULL ) {
                if ( SvROK(*sv3) && SvTYPE(SvRV(*sv3)) == SVt_PVAV ) {
                  AV * av3 = (AV *)SvRV(*sv3);
                  
                  for ( int i3 = 0; i3 <= av_len(av3); i3++ ) {
                    ::HoneyClient::Message_ProcessRegistry * msg4 = msg2->add_process_registries();
                    SV ** sv3;
                    SV *  sv4;
                    
                    if ( (sv3 = av_fetch(av3, i3, 0)) != NULL ) {
                      sv4 = *sv3;
                      if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                        HV *  hv4 = (HV *)SvRV(sv4);
                        SV ** sv5;
                        
                        if ( (sv5 = hv_fetch(hv4, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                          msg4->set_time_at(SvNV(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "name", sizeof("name") - 1, 0)) != NULL ) {
                          STRLEN len;
                          char * str;
                          string sval;
                          
                          str = SvPV(*sv5, len);
                          sval.assign(str, len);
                          msg4->set_name(sval);
                        }
                        if ( (sv5 = hv_fetch(hv4, "event", sizeof("event") - 1, 0)) != NULL ) {
                          STRLEN len;
                          char * str;
                          string sval;
                          
                          str = SvPV(*sv5, len);
                          sval.assign(str, len);
                          msg4->set_event(sval);
                        }
                        if ( (sv5 = hv_fetch(hv4, "value_name", sizeof("value_name") - 1, 0)) != NULL ) {
                          STRLEN len;
                          char * str;
                          string sval;
                          
                          str = SvPV(*sv5, len);
                          sval.assign(str, len);
                          msg4->set_value_name(sval);
                        }
                        if ( (sv5 = hv_fetch(hv4, "value_type", sizeof("value_type") - 1, 0)) != NULL ) {
                          STRLEN len;
                          char * str;
                          string sval;
                          
                          str = SvPV(*sv5, len);
                          sval.assign(str, len);
                          msg4->set_value_type(sval);
                        }
                        if ( (sv5 = hv_fetch(hv4, "value", sizeof("value") - 1, 0)) != NULL ) {
                          STRLEN len;
                          char * str;
                          string sval;
                          
                          str = SvPV(*sv5, len);
                          sval.assign(str, len);
                          msg4->set_value(sval);
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Firewall_Command *
__HoneyClient__Message_Firewall_Command_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Firewall_Command * msg0 = new ::HoneyClient::Message_Firewall_Command;

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
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_err_message(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "chain_name", sizeof("chain_name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_chain_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "mac_address", sizeof("mac_address") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_mac_address(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "ip_address", sizeof("ip_address") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_ip_address(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "protocol", sizeof("protocol") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_protocol(sval);
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

static ::HoneyClient::Message_Firewall *
__HoneyClient__Message_Firewall_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Firewall * msg0 = new ::HoneyClient::Message_Firewall;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
  }

  return msg0;
}

static ::HoneyClient::Message_Pcap_Command *
__HoneyClient__Message_Pcap_Command_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Pcap_Command * msg0 = new ::HoneyClient::Message_Pcap_Command;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "action", sizeof("action") - 1, 0)) != NULL ) {
      msg0->set_action((HoneyClient::Message::Pcap::Command::ActionType)SvIV(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "response", sizeof("response") - 1, 0)) != NULL ) {
      msg0->set_response((HoneyClient::Message::Pcap::Command::ResponseType)SvIV(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "response_message", sizeof("response_message") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_response_message(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "err_message", sizeof("err_message") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_err_message(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "quick_clone_name", sizeof("quick_clone_name") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_quick_clone_name(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "mac_address", sizeof("mac_address") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_mac_address(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "src_ip_address", sizeof("src_ip_address") - 1, 0)) != NULL ) {
      STRLEN len;
      char * str;
      string sval;
      
      str = SvPV(*sv1, len);
      sval.assign(str, len);
      msg0->set_src_ip_address(sval);
    }
    if ( (sv1 = hv_fetch(hv0, "dst_tcp_port", sizeof("dst_tcp_port") - 1, 0)) != NULL ) {
      msg0->set_dst_tcp_port(SvUV(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "delete_pcap", sizeof("delete_pcap") - 1, 0)) != NULL ) {
      msg0->set_delete_pcap(SvIV(*sv1));
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Pcap *
__HoneyClient__Message_Pcap_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Pcap * msg0 = new ::HoneyClient::Message_Pcap;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
  }

  return msg0;
}

static ::HoneyClient::Message *
__HoneyClient__Message_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message * msg0 = new ::HoneyClient::Message;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
  }

  return msg0;
}



MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Application
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Application::new (...)
  PREINIT:
    ::HoneyClient::Message_Application * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Application") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Application_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Application;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Application;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Application", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Application") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Application * other = INT2PTR(__HoneyClient__Message_Application *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Application * other = __HoneyClient__Message_Application_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Application") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Application * other = INT2PTR(__HoneyClient__Message_Application *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Application * other = __HoneyClient__Message_Application_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 3);
    PUSHs(sv_2mortal(newSVpv("manufacturer",0)));
    PUSHs(sv_2mortal(newSVpv("version",0)));
    PUSHs(sv_2mortal(newSVpv("short_name",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Application * msg0 = THIS;

      if ( msg0->has_manufacturer() ) {
        SV * sv0 = newSVpv(msg0->manufacturer().c_str(), msg0->manufacturer().length());
        hv_store(hv0, "manufacturer", sizeof("manufacturer") - 1, sv0, 0);
      }
      if ( msg0->has_version() ) {
        SV * sv0 = newSVpv(msg0->version().c_str(), msg0->version().length());
        hv_store(hv0, "version", sizeof("version") - 1, sv0, 0);
      }
      if ( msg0->has_short_name() ) {
        SV * sv0 = newSVpv(msg0->short_name().c_str(), msg0->short_name().length());
        hv_store(hv0, "short_name", sizeof("short_name") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_manufacturer(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    RETVAL = THIS->has_manufacturer();

  OUTPUT:
    RETVAL


void
clear_manufacturer(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    THIS->clear_manufacturer();


void
manufacturer(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->manufacturer().c_str(),
                              THIS->manufacturer().length()));
      PUSHs(sv);
    }


void
set_manufacturer(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_manufacturer(sval);


I32
has_version(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    RETVAL = THIS->has_version();

  OUTPUT:
    RETVAL


void
clear_version(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    THIS->clear_version();


void
version(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->version().c_str(),
                              THIS->version().length()));
      PUSHs(sv);
    }


void
set_version(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_version(sval);


I32
has_short_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    RETVAL = THIS->has_short_name();

  OUTPUT:
    RETVAL


void
clear_short_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    THIS->clear_short_name();


void
short_name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->short_name().c_str(),
                              THIS->short_name().length()));
      PUSHs(sv);
    }


void
set_short_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Application * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Application");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_short_name(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Os
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Os::new (...)
  PREINIT:
    ::HoneyClient::Message_Os * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Os") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Os_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Os;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Os;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Os", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Os") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Os * other = INT2PTR(__HoneyClient__Message_Os *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Os * other = __HoneyClient__Message_Os_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Os") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Os * other = INT2PTR(__HoneyClient__Message_Os *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Os * other = __HoneyClient__Message_Os_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 3);
    PUSHs(sv_2mortal(newSVpv("name",0)));
    PUSHs(sv_2mortal(newSVpv("version",0)));
    PUSHs(sv_2mortal(newSVpv("short_name",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Os * msg0 = THIS;

      if ( msg0->has_name() ) {
        SV * sv0 = newSVpv(msg0->name().c_str(), msg0->name().length());
        hv_store(hv0, "name", sizeof("name") - 1, sv0, 0);
      }
      if ( msg0->has_version() ) {
        SV * sv0 = newSVpv(msg0->version().c_str(), msg0->version().length());
        hv_store(hv0, "version", sizeof("version") - 1, sv0, 0);
      }
      if ( msg0->has_short_name() ) {
        SV * sv0 = newSVpv(msg0->short_name().c_str(), msg0->short_name().length());
        hv_store(hv0, "short_name", sizeof("short_name") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
clear_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    THIS->clear_name();


void
name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
set_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_name(sval);


I32
has_version(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    RETVAL = THIS->has_version();

  OUTPUT:
    RETVAL


void
clear_version(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    THIS->clear_version();


void
version(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->version().c_str(),
                              THIS->version().length()));
      PUSHs(sv);
    }


void
set_version(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_version(sval);


I32
has_short_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    RETVAL = THIS->has_short_name();

  OUTPUT:
    RETVAL


void
clear_short_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    THIS->clear_short_name();


void
short_name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->short_name().c_str(),
                              THIS->short_name().length()));
      PUSHs(sv);
    }


void
set_short_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Os * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Os");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_short_name(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::ClientStatus
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_ClientStatus::new (...)
  PREINIT:
    ::HoneyClient::Message_ClientStatus * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::ClientStatus") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_ClientStatus_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_ClientStatus;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_ClientStatus;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::ClientStatus", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::ClientStatus") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_ClientStatus * other = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_ClientStatus * other = __HoneyClient__Message_ClientStatus_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::ClientStatus") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_ClientStatus * other = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_ClientStatus * other = __HoneyClient__Message_ClientStatus_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 2);
    PUSHs(sv_2mortal(newSVpv("status",0)));
    PUSHs(sv_2mortal(newSVpv("description",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_ClientStatus * msg0 = THIS;

      if ( msg0->has_status() ) {
        SV * sv0 = newSVpv(msg0->status().c_str(), msg0->status().length());
        hv_store(hv0, "status", sizeof("status") - 1, sv0, 0);
      }
      if ( msg0->has_description() ) {
        SV * sv0 = newSVpv(msg0->description().c_str(), msg0->description().length());
        hv_store(hv0, "description", sizeof("description") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_status(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    RETVAL = THIS->has_status();

  OUTPUT:
    RETVAL


void
clear_status(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    THIS->clear_status();


void
status(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->status().c_str(),
                              THIS->status().length()));
      PUSHs(sv);
    }


void
set_status(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_status(sval);


I32
has_description(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    RETVAL = THIS->has_description();

  OUTPUT:
    RETVAL


void
clear_description(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    THIS->clear_description();


void
description(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->description().c_str(),
                              THIS->description().length()));
      PUSHs(sv);
    }


void
set_description(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_ClientStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ClientStatus");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_description(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Host
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Host::new (...)
  PREINIT:
    ::HoneyClient::Message_Host * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Host") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Host_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Host;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Host;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Host", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Host") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Host * other = INT2PTR(__HoneyClient__Message_Host *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Host * other = __HoneyClient__Message_Host_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Host") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Host * other = INT2PTR(__HoneyClient__Message_Host *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Host * other = __HoneyClient__Message_Host_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 2);
    PUSHs(sv_2mortal(newSVpv("hostname",0)));
    PUSHs(sv_2mortal(newSVpv("ip",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Host * msg0 = THIS;

      if ( msg0->has_hostname() ) {
        SV * sv0 = newSVpv(msg0->hostname().c_str(), msg0->hostname().length());
        hv_store(hv0, "hostname", sizeof("hostname") - 1, sv0, 0);
      }
      if ( msg0->has_ip() ) {
        SV * sv0 = newSVpv(msg0->ip().c_str(), msg0->ip().length());
        hv_store(hv0, "ip", sizeof("ip") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_hostname(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    RETVAL = THIS->has_hostname();

  OUTPUT:
    RETVAL


void
clear_hostname(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    THIS->clear_hostname();


void
hostname(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->hostname().c_str(),
                              THIS->hostname().length()));
      PUSHs(sv);
    }


void
set_hostname(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_hostname(sval);


I32
has_ip(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    RETVAL = THIS->has_ip();

  OUTPUT:
    RETVAL


void
clear_ip(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    THIS->clear_ip();


void
ip(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->ip().c_str(),
                              THIS->ip().length()));
      PUSHs(sv);
    }


void
set_ip(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Host * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Host");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_ip(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Client
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Client::new (...)
  PREINIT:
    ::HoneyClient::Message_Client * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Client") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Client_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Client;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Client;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Client", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Client") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Client * other = INT2PTR(__HoneyClient__Message_Client *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Client * other = __HoneyClient__Message_Client_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Client") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Client * other = INT2PTR(__HoneyClient__Message_Client *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Client * other = __HoneyClient__Message_Client_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 10);
    PUSHs(sv_2mortal(newSVpv("quick_clone_name",0)));
    PUSHs(sv_2mortal(newSVpv("snapshot_name",0)));
    PUSHs(sv_2mortal(newSVpv("created_at",0)));
    PUSHs(sv_2mortal(newSVpv("os",0)));
    PUSHs(sv_2mortal(newSVpv("application",0)));
    PUSHs(sv_2mortal(newSVpv("client_status",0)));
    PUSHs(sv_2mortal(newSVpv("host",0)));
    PUSHs(sv_2mortal(newSVpv("suspended_at",0)));
    PUSHs(sv_2mortal(newSVpv("ip",0)));
    PUSHs(sv_2mortal(newSVpv("mac",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Client * msg0 = THIS;

      if ( msg0->has_quick_clone_name() ) {
        SV * sv0 = newSVpv(msg0->quick_clone_name().c_str(), msg0->quick_clone_name().length());
        hv_store(hv0, "quick_clone_name", sizeof("quick_clone_name") - 1, sv0, 0);
      }
      if ( msg0->has_snapshot_name() ) {
        SV * sv0 = newSVpv(msg0->snapshot_name().c_str(), msg0->snapshot_name().length());
        hv_store(hv0, "snapshot_name", sizeof("snapshot_name") - 1, sv0, 0);
      }
      if ( msg0->has_created_at() ) {
        SV * sv0 = newSVpv(msg0->created_at().c_str(), msg0->created_at().length());
        hv_store(hv0, "created_at", sizeof("created_at") - 1, sv0, 0);
      }
      if ( msg0->has_os() ) {
        ::HoneyClient::Message_Os * msg2 = msg0->mutable_os();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_name() ) {
          SV * sv2 = newSVpv(msg2->name().c_str(), msg2->name().length());
          hv_store(hv2, "name", sizeof("name") - 1, sv2, 0);
        }
        if ( msg2->has_version() ) {
          SV * sv2 = newSVpv(msg2->version().c_str(), msg2->version().length());
          hv_store(hv2, "version", sizeof("version") - 1, sv2, 0);
        }
        if ( msg2->has_short_name() ) {
          SV * sv2 = newSVpv(msg2->short_name().c_str(), msg2->short_name().length());
          hv_store(hv2, "short_name", sizeof("short_name") - 1, sv2, 0);
        }
        hv_store(hv0, "os", sizeof("os") - 1, sv1, 0);
      }
      if ( msg0->has_application() ) {
        ::HoneyClient::Message_Application * msg2 = msg0->mutable_application();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_manufacturer() ) {
          SV * sv2 = newSVpv(msg2->manufacturer().c_str(), msg2->manufacturer().length());
          hv_store(hv2, "manufacturer", sizeof("manufacturer") - 1, sv2, 0);
        }
        if ( msg2->has_version() ) {
          SV * sv2 = newSVpv(msg2->version().c_str(), msg2->version().length());
          hv_store(hv2, "version", sizeof("version") - 1, sv2, 0);
        }
        if ( msg2->has_short_name() ) {
          SV * sv2 = newSVpv(msg2->short_name().c_str(), msg2->short_name().length());
          hv_store(hv2, "short_name", sizeof("short_name") - 1, sv2, 0);
        }
        hv_store(hv0, "application", sizeof("application") - 1, sv1, 0);
      }
      if ( msg0->has_client_status() ) {
        ::HoneyClient::Message_ClientStatus * msg2 = msg0->mutable_client_status();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_status() ) {
          SV * sv2 = newSVpv(msg2->status().c_str(), msg2->status().length());
          hv_store(hv2, "status", sizeof("status") - 1, sv2, 0);
        }
        if ( msg2->has_description() ) {
          SV * sv2 = newSVpv(msg2->description().c_str(), msg2->description().length());
          hv_store(hv2, "description", sizeof("description") - 1, sv2, 0);
        }
        hv_store(hv0, "client_status", sizeof("client_status") - 1, sv1, 0);
      }
      if ( msg0->has_host() ) {
        ::HoneyClient::Message_Host * msg2 = msg0->mutable_host();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_hostname() ) {
          SV * sv2 = newSVpv(msg2->hostname().c_str(), msg2->hostname().length());
          hv_store(hv2, "hostname", sizeof("hostname") - 1, sv2, 0);
        }
        if ( msg2->has_ip() ) {
          SV * sv2 = newSVpv(msg2->ip().c_str(), msg2->ip().length());
          hv_store(hv2, "ip", sizeof("ip") - 1, sv2, 0);
        }
        hv_store(hv0, "host", sizeof("host") - 1, sv1, 0);
      }
      if ( msg0->has_suspended_at() ) {
        SV * sv0 = newSVpv(msg0->suspended_at().c_str(), msg0->suspended_at().length());
        hv_store(hv0, "suspended_at", sizeof("suspended_at") - 1, sv0, 0);
      }
      if ( msg0->has_ip() ) {
        SV * sv0 = newSVpv(msg0->ip().c_str(), msg0->ip().length());
        hv_store(hv0, "ip", sizeof("ip") - 1, sv0, 0);
      }
      if ( msg0->has_mac() ) {
        SV * sv0 = newSVpv(msg0->mac().c_str(), msg0->mac().length());
        hv_store(hv0, "mac", sizeof("mac") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_quick_clone_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_quick_clone_name();

  OUTPUT:
    RETVAL


void
clear_quick_clone_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_quick_clone_name();


void
quick_clone_name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->quick_clone_name().c_str(),
                              THIS->quick_clone_name().length()));
      PUSHs(sv);
    }


void
set_quick_clone_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_quick_clone_name(sval);


I32
has_snapshot_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_snapshot_name();

  OUTPUT:
    RETVAL


void
clear_snapshot_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_snapshot_name();


void
snapshot_name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->snapshot_name().c_str(),
                              THIS->snapshot_name().length()));
      PUSHs(sv);
    }


void
set_snapshot_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_snapshot_name(sval);


I32
has_created_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_created_at();

  OUTPUT:
    RETVAL


void
clear_created_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_created_at();


void
created_at(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->created_at().c_str(),
                              THIS->created_at().length()));
      PUSHs(sv);
    }


void
set_created_at(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_created_at(sval);


I32
has_os(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_os();

  OUTPUT:
    RETVAL


void
clear_os(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_os();


void
os(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_Os * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_Os;
      val->CopyFrom(THIS->os());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::Os", (void *)val);
      PUSHs(sv);
    }


void
set_os(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    ::HoneyClient::Message_Os * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::Os") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_Os *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::Os");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_Os * mval = THIS->mutable_os();
      mval->CopyFrom(*VAL);
    }


I32
has_application(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_application();

  OUTPUT:
    RETVAL


void
clear_application(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_application();


void
application(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_Application * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_Application;
      val->CopyFrom(THIS->application());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::Application", (void *)val);
      PUSHs(sv);
    }


void
set_application(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    ::HoneyClient::Message_Application * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::Application") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_Application *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::Application");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_Application * mval = THIS->mutable_application();
      mval->CopyFrom(*VAL);
    }


I32
has_client_status(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_client_status();

  OUTPUT:
    RETVAL


void
clear_client_status(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_client_status();


void
client_status(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_ClientStatus * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_ClientStatus;
      val->CopyFrom(THIS->client_status());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::ClientStatus", (void *)val);
      PUSHs(sv);
    }


void
set_client_status(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    ::HoneyClient::Message_ClientStatus * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::ClientStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_ClientStatus *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::ClientStatus");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_ClientStatus * mval = THIS->mutable_client_status();
      mval->CopyFrom(*VAL);
    }


I32
has_host(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_host();

  OUTPUT:
    RETVAL


void
clear_host(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_host();


void
host(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_Host * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_Host;
      val->CopyFrom(THIS->host());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::Host", (void *)val);
      PUSHs(sv);
    }


void
set_host(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    ::HoneyClient::Message_Host * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::Host") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_Host *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::Host");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_Host * mval = THIS->mutable_host();
      mval->CopyFrom(*VAL);
    }


I32
has_suspended_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_suspended_at();

  OUTPUT:
    RETVAL


void
clear_suspended_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_suspended_at();


void
suspended_at(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->suspended_at().c_str(),
                              THIS->suspended_at().length()));
      PUSHs(sv);
    }


void
set_suspended_at(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_suspended_at(sval);


I32
has_ip(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_ip();

  OUTPUT:
    RETVAL


void
clear_ip(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_ip();


void
ip(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->ip().c_str(),
                              THIS->ip().length()));
      PUSHs(sv);
    }


void
set_ip(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_ip(sval);


I32
has_mac(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    RETVAL = THIS->has_mac();

  OUTPUT:
    RETVAL


void
clear_mac(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    THIS->clear_mac();


void
mac(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->mac().c_str(),
                              THIS->mac().length()));
      PUSHs(sv);
    }


void
set_mac(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Client * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Client");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_mac(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Group
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Group::new (...)
  PREINIT:
    ::HoneyClient::Message_Group * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Group") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Group_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Group;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Group;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Group", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Group") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Group * other = INT2PTR(__HoneyClient__Message_Group *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Group * other = __HoneyClient__Message_Group_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Group") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Group * other = INT2PTR(__HoneyClient__Message_Group *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Group * other = __HoneyClient__Message_Group_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 1);
    PUSHs(sv_2mortal(newSVpv("name",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Group * msg0 = THIS;

      if ( msg0->has_name() ) {
        SV * sv0 = newSVpv(msg0->name().c_str(), msg0->name().length());
        hv_store(hv0, "name", sizeof("name") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
clear_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    THIS->clear_name();


void
name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
set_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Group * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Group");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_name(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::JobSource
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_JobSource::new (...)
  PREINIT:
    ::HoneyClient::Message_JobSource * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::JobSource") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_JobSource_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_JobSource;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_JobSource;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::JobSource", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::JobSource") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_JobSource * other = INT2PTR(__HoneyClient__Message_JobSource *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_JobSource * other = __HoneyClient__Message_JobSource_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::JobSource") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_JobSource * other = INT2PTR(__HoneyClient__Message_JobSource *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_JobSource * other = __HoneyClient__Message_JobSource_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 3);
    PUSHs(sv_2mortal(newSVpv("name",0)));
    PUSHs(sv_2mortal(newSVpv("protocol",0)));
    PUSHs(sv_2mortal(newSVpv("group",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_JobSource * msg0 = THIS;

      if ( msg0->has_name() ) {
        SV * sv0 = newSVpv(msg0->name().c_str(), msg0->name().length());
        hv_store(hv0, "name", sizeof("name") - 1, sv0, 0);
      }
      if ( msg0->has_protocol() ) {
        SV * sv0 = newSVpv(msg0->protocol().c_str(), msg0->protocol().length());
        hv_store(hv0, "protocol", sizeof("protocol") - 1, sv0, 0);
      }
      if ( msg0->has_group() ) {
        ::HoneyClient::Message_Group * msg2 = msg0->mutable_group();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_name() ) {
          SV * sv2 = newSVpv(msg2->name().c_str(), msg2->name().length());
          hv_store(hv2, "name", sizeof("name") - 1, sv2, 0);
        }
        hv_store(hv0, "group", sizeof("group") - 1, sv1, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
clear_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    THIS->clear_name();


void
name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
set_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_name(sval);


I32
has_protocol(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    RETVAL = THIS->has_protocol();

  OUTPUT:
    RETVAL


void
clear_protocol(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    THIS->clear_protocol();


void
protocol(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->protocol().c_str(),
                              THIS->protocol().length()));
      PUSHs(sv);
    }


void
set_protocol(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_protocol(sval);


I32
has_group(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    RETVAL = THIS->has_group();

  OUTPUT:
    RETVAL


void
clear_group(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    THIS->clear_group();


void
group(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_Group * val = NULL;

  PPCODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_Group;
      val->CopyFrom(THIS->group());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::Group", (void *)val);
      PUSHs(sv);
    }


void
set_group(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_JobSource * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobSource");
    }
    ::HoneyClient::Message_Group * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::Group") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_Group *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::Group");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_Group * mval = THIS->mutable_group();
      mval->CopyFrom(*VAL);
    }


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::JobAlert
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_JobAlert::new (...)
  PREINIT:
    ::HoneyClient::Message_JobAlert * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::JobAlert") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_JobAlert_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_JobAlert;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_JobAlert;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::JobAlert", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::JobAlert") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_JobAlert * other = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_JobAlert * other = __HoneyClient__Message_JobAlert_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::JobAlert") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_JobAlert * other = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_JobAlert * other = __HoneyClient__Message_JobAlert_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 2);
    PUSHs(sv_2mortal(newSVpv("protocol",0)));
    PUSHs(sv_2mortal(newSVpv("address",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_JobAlert * msg0 = THIS;

      if ( msg0->has_protocol() ) {
        SV * sv0 = newSVpv(msg0->protocol().c_str(), msg0->protocol().length());
        hv_store(hv0, "protocol", sizeof("protocol") - 1, sv0, 0);
      }
      if ( msg0->has_address() ) {
        SV * sv0 = newSVpv(msg0->address().c_str(), msg0->address().length());
        hv_store(hv0, "address", sizeof("address") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_protocol(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    RETVAL = THIS->has_protocol();

  OUTPUT:
    RETVAL


void
clear_protocol(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    THIS->clear_protocol();


void
protocol(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->protocol().c_str(),
                              THIS->protocol().length()));
      PUSHs(sv);
    }


void
set_protocol(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_protocol(sval);


I32
has_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    RETVAL = THIS->has_address();

  OUTPUT:
    RETVAL


void
clear_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    THIS->clear_address();


void
address(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->address().c_str(),
                              THIS->address().length()));
      PUSHs(sv);
    }


void
set_address(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_JobAlert * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::JobAlert");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_address(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::UrlStatus
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_UrlStatus::new (...)
  PREINIT:
    ::HoneyClient::Message_UrlStatus * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::UrlStatus") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_UrlStatus_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_UrlStatus;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_UrlStatus;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::UrlStatus", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::UrlStatus") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_UrlStatus * other = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_UrlStatus * other = __HoneyClient__Message_UrlStatus_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::UrlStatus") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_UrlStatus * other = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_UrlStatus * other = __HoneyClient__Message_UrlStatus_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 2);
    PUSHs(sv_2mortal(newSVpv("status",0)));
    PUSHs(sv_2mortal(newSVpv("description",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_UrlStatus * msg0 = THIS;

      if ( msg0->has_status() ) {
        SV * sv0 = newSVpv(msg0->status().c_str(), msg0->status().length());
        hv_store(hv0, "status", sizeof("status") - 1, sv0, 0);
      }
      if ( msg0->has_description() ) {
        SV * sv0 = newSVpv(msg0->description().c_str(), msg0->description().length());
        hv_store(hv0, "description", sizeof("description") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_status(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    RETVAL = THIS->has_status();

  OUTPUT:
    RETVAL


void
clear_status(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    THIS->clear_status();


void
status(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->status().c_str(),
                              THIS->status().length()));
      PUSHs(sv);
    }


void
set_status(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_status(sval);


I32
has_description(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    RETVAL = THIS->has_description();

  OUTPUT:
    RETVAL


void
clear_description(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    THIS->clear_description();


void
description(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->description().c_str(),
                              THIS->description().length()));
      PUSHs(sv);
    }


void
set_description(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_UrlStatus * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::UrlStatus");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_description(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Url
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Url::new (...)
  PREINIT:
    ::HoneyClient::Message_Url * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Url") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Url_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Url;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Url;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Url", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Url") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Url * other = INT2PTR(__HoneyClient__Message_Url *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Url * other = __HoneyClient__Message_Url_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Url") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Url * other = INT2PTR(__HoneyClient__Message_Url *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Url * other = __HoneyClient__Message_Url_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 6);
    PUSHs(sv_2mortal(newSVpv("url",0)));
    PUSHs(sv_2mortal(newSVpv("priority",0)));
    PUSHs(sv_2mortal(newSVpv("url_status",0)));
    PUSHs(sv_2mortal(newSVpv("time_at",0)));
    PUSHs(sv_2mortal(newSVpv("client",0)));
    PUSHs(sv_2mortal(newSVpv("ip",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Url * msg0 = THIS;

      if ( msg0->has_url() ) {
        SV * sv0 = newSVpv(msg0->url().c_str(), msg0->url().length());
        hv_store(hv0, "url", sizeof("url") - 1, sv0, 0);
      }
      if ( msg0->has_priority() ) {
        ostringstream ost0;
        
        ost0 << msg0->priority();
        SV * sv0 = newSVpv(ost0.str().c_str(), ost0.str().length());
        hv_store(hv0, "priority", sizeof("priority") - 1, sv0, 0);
      }
      if ( msg0->has_url_status() ) {
        ::HoneyClient::Message_UrlStatus * msg2 = msg0->mutable_url_status();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_status() ) {
          SV * sv2 = newSVpv(msg2->status().c_str(), msg2->status().length());
          hv_store(hv2, "status", sizeof("status") - 1, sv2, 0);
        }
        if ( msg2->has_description() ) {
          SV * sv2 = newSVpv(msg2->description().c_str(), msg2->description().length());
          hv_store(hv2, "description", sizeof("description") - 1, sv2, 0);
        }
        hv_store(hv0, "url_status", sizeof("url_status") - 1, sv1, 0);
      }
      if ( msg0->has_time_at() ) {
        SV * sv0 = newSVnv(msg0->time_at());
        hv_store(hv0, "time_at", sizeof("time_at") - 1, sv0, 0);
      }
      if ( msg0->has_client() ) {
        ::HoneyClient::Message_Client * msg2 = msg0->mutable_client();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_quick_clone_name() ) {
          SV * sv2 = newSVpv(msg2->quick_clone_name().c_str(), msg2->quick_clone_name().length());
          hv_store(hv2, "quick_clone_name", sizeof("quick_clone_name") - 1, sv2, 0);
        }
        if ( msg2->has_snapshot_name() ) {
          SV * sv2 = newSVpv(msg2->snapshot_name().c_str(), msg2->snapshot_name().length());
          hv_store(hv2, "snapshot_name", sizeof("snapshot_name") - 1, sv2, 0);
        }
        if ( msg2->has_created_at() ) {
          SV * sv2 = newSVpv(msg2->created_at().c_str(), msg2->created_at().length());
          hv_store(hv2, "created_at", sizeof("created_at") - 1, sv2, 0);
        }
        if ( msg2->has_os() ) {
          ::HoneyClient::Message_Os * msg4 = msg2->mutable_os();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_name() ) {
            SV * sv4 = newSVpv(msg4->name().c_str(), msg4->name().length());
            hv_store(hv4, "name", sizeof("name") - 1, sv4, 0);
          }
          if ( msg4->has_version() ) {
            SV * sv4 = newSVpv(msg4->version().c_str(), msg4->version().length());
            hv_store(hv4, "version", sizeof("version") - 1, sv4, 0);
          }
          if ( msg4->has_short_name() ) {
            SV * sv4 = newSVpv(msg4->short_name().c_str(), msg4->short_name().length());
            hv_store(hv4, "short_name", sizeof("short_name") - 1, sv4, 0);
          }
          hv_store(hv2, "os", sizeof("os") - 1, sv3, 0);
        }
        if ( msg2->has_application() ) {
          ::HoneyClient::Message_Application * msg4 = msg2->mutable_application();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_manufacturer() ) {
            SV * sv4 = newSVpv(msg4->manufacturer().c_str(), msg4->manufacturer().length());
            hv_store(hv4, "manufacturer", sizeof("manufacturer") - 1, sv4, 0);
          }
          if ( msg4->has_version() ) {
            SV * sv4 = newSVpv(msg4->version().c_str(), msg4->version().length());
            hv_store(hv4, "version", sizeof("version") - 1, sv4, 0);
          }
          if ( msg4->has_short_name() ) {
            SV * sv4 = newSVpv(msg4->short_name().c_str(), msg4->short_name().length());
            hv_store(hv4, "short_name", sizeof("short_name") - 1, sv4, 0);
          }
          hv_store(hv2, "application", sizeof("application") - 1, sv3, 0);
        }
        if ( msg2->has_client_status() ) {
          ::HoneyClient::Message_ClientStatus * msg4 = msg2->mutable_client_status();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_status() ) {
            SV * sv4 = newSVpv(msg4->status().c_str(), msg4->status().length());
            hv_store(hv4, "status", sizeof("status") - 1, sv4, 0);
          }
          if ( msg4->has_description() ) {
            SV * sv4 = newSVpv(msg4->description().c_str(), msg4->description().length());
            hv_store(hv4, "description", sizeof("description") - 1, sv4, 0);
          }
          hv_store(hv2, "client_status", sizeof("client_status") - 1, sv3, 0);
        }
        if ( msg2->has_host() ) {
          ::HoneyClient::Message_Host * msg4 = msg2->mutable_host();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_hostname() ) {
            SV * sv4 = newSVpv(msg4->hostname().c_str(), msg4->hostname().length());
            hv_store(hv4, "hostname", sizeof("hostname") - 1, sv4, 0);
          }
          if ( msg4->has_ip() ) {
            SV * sv4 = newSVpv(msg4->ip().c_str(), msg4->ip().length());
            hv_store(hv4, "ip", sizeof("ip") - 1, sv4, 0);
          }
          hv_store(hv2, "host", sizeof("host") - 1, sv3, 0);
        }
        if ( msg2->has_suspended_at() ) {
          SV * sv2 = newSVpv(msg2->suspended_at().c_str(), msg2->suspended_at().length());
          hv_store(hv2, "suspended_at", sizeof("suspended_at") - 1, sv2, 0);
        }
        if ( msg2->has_ip() ) {
          SV * sv2 = newSVpv(msg2->ip().c_str(), msg2->ip().length());
          hv_store(hv2, "ip", sizeof("ip") - 1, sv2, 0);
        }
        if ( msg2->has_mac() ) {
          SV * sv2 = newSVpv(msg2->mac().c_str(), msg2->mac().length());
          hv_store(hv2, "mac", sizeof("mac") - 1, sv2, 0);
        }
        hv_store(hv0, "client", sizeof("client") - 1, sv1, 0);
      }
      if ( msg0->has_ip() ) {
        SV * sv0 = newSVpv(msg0->ip().c_str(), msg0->ip().length());
        hv_store(hv0, "ip", sizeof("ip") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_url(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    RETVAL = THIS->has_url();

  OUTPUT:
    RETVAL


void
clear_url(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    THIS->clear_url();


void
url(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->url().c_str(),
                              THIS->url().length()));
      PUSHs(sv);
    }


void
set_url(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_url(sval);


I32
has_priority(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    RETVAL = THIS->has_priority();

  OUTPUT:
    RETVAL


void
clear_priority(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    THIS->clear_priority();


void
priority(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ostringstream ost;

  PPCODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      ost.str("");
      ost << THIS->priority();
      sv = sv_2mortal(newSVpv(ost.str().c_str(),
                              ost.str().length()));
      PUSHs(sv);
    }


void
set_priority(svTHIS, svVAL)
  SV * svTHIS
  char *svVAL

  PREINIT:
    unsigned long long lval;

  CODE:
    lval = strtoull((svVAL) ? svVAL : "", NULL, 0);
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    THIS->set_priority(lval);


I32
has_url_status(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    RETVAL = THIS->has_url_status();

  OUTPUT:
    RETVAL


void
clear_url_status(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    THIS->clear_url_status();


void
url_status(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_UrlStatus * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_UrlStatus;
      val->CopyFrom(THIS->url_status());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::UrlStatus", (void *)val);
      PUSHs(sv);
    }


void
set_url_status(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    ::HoneyClient::Message_UrlStatus * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::UrlStatus") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_UrlStatus *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::UrlStatus");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_UrlStatus * mval = THIS->mutable_url_status();
      mval->CopyFrom(*VAL);
    }


I32
has_time_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    RETVAL = THIS->has_time_at();

  OUTPUT:
    RETVAL


void
clear_time_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    THIS->clear_time_at();


void
time_at(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVnv(THIS->time_at()));
      PUSHs(sv);
    }


void
set_time_at(svTHIS, svVAL)
  SV * svTHIS
  NV svVAL

  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    THIS->set_time_at(svVAL);


I32
has_client(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    RETVAL = THIS->has_client();

  OUTPUT:
    RETVAL


void
clear_client(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    THIS->clear_client();


void
client(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_Client * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_Client;
      val->CopyFrom(THIS->client());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::Client", (void *)val);
      PUSHs(sv);
    }


void
set_client(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    ::HoneyClient::Message_Client * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::Client");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_Client * mval = THIS->mutable_client();
      mval->CopyFrom(*VAL);
    }


I32
has_ip(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    RETVAL = THIS->has_ip();

  OUTPUT:
    RETVAL


void
clear_ip(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    THIS->clear_ip();


void
ip(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->ip().c_str(),
                              THIS->ip().length()));
      PUSHs(sv);
    }


void
set_ip(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Url * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Url");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_ip(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Job
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Job::new (...)
  PREINIT:
    ::HoneyClient::Message_Job * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Job") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Job_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Job;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Job;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Job", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Job") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Job * other = INT2PTR(__HoneyClient__Message_Job *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Job * other = __HoneyClient__Message_Job_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Job") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Job * other = INT2PTR(__HoneyClient__Message_Job *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Job * other = __HoneyClient__Message_Job_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 7);
    PUSHs(sv_2mortal(newSVpv("uuid",0)));
    PUSHs(sv_2mortal(newSVpv("job_source",0)));
    PUSHs(sv_2mortal(newSVpv("created_at",0)));
    PUSHs(sv_2mortal(newSVpv("completed_at",0)));
    PUSHs(sv_2mortal(newSVpv("client",0)));
    PUSHs(sv_2mortal(newSVpv("job_alerts",0)));
    PUSHs(sv_2mortal(newSVpv("urls",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Job * msg0 = THIS;

      if ( msg0->has_uuid() ) {
        SV * sv0 = newSVpv(msg0->uuid().c_str(), msg0->uuid().length());
        hv_store(hv0, "uuid", sizeof("uuid") - 1, sv0, 0);
      }
      if ( msg0->has_job_source() ) {
        ::HoneyClient::Message_JobSource * msg2 = msg0->mutable_job_source();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_name() ) {
          SV * sv2 = newSVpv(msg2->name().c_str(), msg2->name().length());
          hv_store(hv2, "name", sizeof("name") - 1, sv2, 0);
        }
        if ( msg2->has_protocol() ) {
          SV * sv2 = newSVpv(msg2->protocol().c_str(), msg2->protocol().length());
          hv_store(hv2, "protocol", sizeof("protocol") - 1, sv2, 0);
        }
        if ( msg2->has_group() ) {
          ::HoneyClient::Message_Group * msg4 = msg2->mutable_group();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_name() ) {
            SV * sv4 = newSVpv(msg4->name().c_str(), msg4->name().length());
            hv_store(hv4, "name", sizeof("name") - 1, sv4, 0);
          }
          hv_store(hv2, "group", sizeof("group") - 1, sv3, 0);
        }
        hv_store(hv0, "job_source", sizeof("job_source") - 1, sv1, 0);
      }
      if ( msg0->has_created_at() ) {
        SV * sv0 = newSVpv(msg0->created_at().c_str(), msg0->created_at().length());
        hv_store(hv0, "created_at", sizeof("created_at") - 1, sv0, 0);
      }
      if ( msg0->has_completed_at() ) {
        SV * sv0 = newSVpv(msg0->completed_at().c_str(), msg0->completed_at().length());
        hv_store(hv0, "completed_at", sizeof("completed_at") - 1, sv0, 0);
      }
      if ( msg0->has_client() ) {
        ::HoneyClient::Message_Client * msg2 = msg0->mutable_client();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_quick_clone_name() ) {
          SV * sv2 = newSVpv(msg2->quick_clone_name().c_str(), msg2->quick_clone_name().length());
          hv_store(hv2, "quick_clone_name", sizeof("quick_clone_name") - 1, sv2, 0);
        }
        if ( msg2->has_snapshot_name() ) {
          SV * sv2 = newSVpv(msg2->snapshot_name().c_str(), msg2->snapshot_name().length());
          hv_store(hv2, "snapshot_name", sizeof("snapshot_name") - 1, sv2, 0);
        }
        if ( msg2->has_created_at() ) {
          SV * sv2 = newSVpv(msg2->created_at().c_str(), msg2->created_at().length());
          hv_store(hv2, "created_at", sizeof("created_at") - 1, sv2, 0);
        }
        if ( msg2->has_os() ) {
          ::HoneyClient::Message_Os * msg4 = msg2->mutable_os();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_name() ) {
            SV * sv4 = newSVpv(msg4->name().c_str(), msg4->name().length());
            hv_store(hv4, "name", sizeof("name") - 1, sv4, 0);
          }
          if ( msg4->has_version() ) {
            SV * sv4 = newSVpv(msg4->version().c_str(), msg4->version().length());
            hv_store(hv4, "version", sizeof("version") - 1, sv4, 0);
          }
          if ( msg4->has_short_name() ) {
            SV * sv4 = newSVpv(msg4->short_name().c_str(), msg4->short_name().length());
            hv_store(hv4, "short_name", sizeof("short_name") - 1, sv4, 0);
          }
          hv_store(hv2, "os", sizeof("os") - 1, sv3, 0);
        }
        if ( msg2->has_application() ) {
          ::HoneyClient::Message_Application * msg4 = msg2->mutable_application();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_manufacturer() ) {
            SV * sv4 = newSVpv(msg4->manufacturer().c_str(), msg4->manufacturer().length());
            hv_store(hv4, "manufacturer", sizeof("manufacturer") - 1, sv4, 0);
          }
          if ( msg4->has_version() ) {
            SV * sv4 = newSVpv(msg4->version().c_str(), msg4->version().length());
            hv_store(hv4, "version", sizeof("version") - 1, sv4, 0);
          }
          if ( msg4->has_short_name() ) {
            SV * sv4 = newSVpv(msg4->short_name().c_str(), msg4->short_name().length());
            hv_store(hv4, "short_name", sizeof("short_name") - 1, sv4, 0);
          }
          hv_store(hv2, "application", sizeof("application") - 1, sv3, 0);
        }
        if ( msg2->has_client_status() ) {
          ::HoneyClient::Message_ClientStatus * msg4 = msg2->mutable_client_status();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_status() ) {
            SV * sv4 = newSVpv(msg4->status().c_str(), msg4->status().length());
            hv_store(hv4, "status", sizeof("status") - 1, sv4, 0);
          }
          if ( msg4->has_description() ) {
            SV * sv4 = newSVpv(msg4->description().c_str(), msg4->description().length());
            hv_store(hv4, "description", sizeof("description") - 1, sv4, 0);
          }
          hv_store(hv2, "client_status", sizeof("client_status") - 1, sv3, 0);
        }
        if ( msg2->has_host() ) {
          ::HoneyClient::Message_Host * msg4 = msg2->mutable_host();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_hostname() ) {
            SV * sv4 = newSVpv(msg4->hostname().c_str(), msg4->hostname().length());
            hv_store(hv4, "hostname", sizeof("hostname") - 1, sv4, 0);
          }
          if ( msg4->has_ip() ) {
            SV * sv4 = newSVpv(msg4->ip().c_str(), msg4->ip().length());
            hv_store(hv4, "ip", sizeof("ip") - 1, sv4, 0);
          }
          hv_store(hv2, "host", sizeof("host") - 1, sv3, 0);
        }
        if ( msg2->has_suspended_at() ) {
          SV * sv2 = newSVpv(msg2->suspended_at().c_str(), msg2->suspended_at().length());
          hv_store(hv2, "suspended_at", sizeof("suspended_at") - 1, sv2, 0);
        }
        if ( msg2->has_ip() ) {
          SV * sv2 = newSVpv(msg2->ip().c_str(), msg2->ip().length());
          hv_store(hv2, "ip", sizeof("ip") - 1, sv2, 0);
        }
        if ( msg2->has_mac() ) {
          SV * sv2 = newSVpv(msg2->mac().c_str(), msg2->mac().length());
          hv_store(hv2, "mac", sizeof("mac") - 1, sv2, 0);
        }
        hv_store(hv0, "client", sizeof("client") - 1, sv1, 0);
      }
      if ( msg0->job_alerts_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->job_alerts_size(); i0++ ) {
          ::HoneyClient::Message_JobAlert * msg2 = msg0->mutable_job_alerts(i0);
          HV * hv2 = newHV();
          SV * sv1 = newRV_noinc((SV *)hv2);
          
          if ( msg2->has_protocol() ) {
            SV * sv2 = newSVpv(msg2->protocol().c_str(), msg2->protocol().length());
            hv_store(hv2, "protocol", sizeof("protocol") - 1, sv2, 0);
          }
          if ( msg2->has_address() ) {
            SV * sv2 = newSVpv(msg2->address().c_str(), msg2->address().length());
            hv_store(hv2, "address", sizeof("address") - 1, sv2, 0);
          }
          av_push(av0, sv1);
        }
        hv_store(hv0, "job_alerts", sizeof("job_alerts") - 1, sv0, 0);
      }
      if ( msg0->urls_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->urls_size(); i0++ ) {
          ::HoneyClient::Message_Url * msg2 = msg0->mutable_urls(i0);
          HV * hv2 = newHV();
          SV * sv1 = newRV_noinc((SV *)hv2);
          
          if ( msg2->has_url() ) {
            SV * sv2 = newSVpv(msg2->url().c_str(), msg2->url().length());
            hv_store(hv2, "url", sizeof("url") - 1, sv2, 0);
          }
          if ( msg2->has_priority() ) {
            ostringstream ost2;
            
            ost2 << msg2->priority();
            SV * sv2 = newSVpv(ost2.str().c_str(), ost2.str().length());
            hv_store(hv2, "priority", sizeof("priority") - 1, sv2, 0);
          }
          if ( msg2->has_url_status() ) {
            ::HoneyClient::Message_UrlStatus * msg4 = msg2->mutable_url_status();
            HV * hv4 = newHV();
            SV * sv3 = newRV_noinc((SV *)hv4);
            
            if ( msg4->has_status() ) {
              SV * sv4 = newSVpv(msg4->status().c_str(), msg4->status().length());
              hv_store(hv4, "status", sizeof("status") - 1, sv4, 0);
            }
            if ( msg4->has_description() ) {
              SV * sv4 = newSVpv(msg4->description().c_str(), msg4->description().length());
              hv_store(hv4, "description", sizeof("description") - 1, sv4, 0);
            }
            hv_store(hv2, "url_status", sizeof("url_status") - 1, sv3, 0);
          }
          if ( msg2->has_time_at() ) {
            SV * sv2 = newSVnv(msg2->time_at());
            hv_store(hv2, "time_at", sizeof("time_at") - 1, sv2, 0);
          }
          if ( msg2->has_client() ) {
            ::HoneyClient::Message_Client * msg4 = msg2->mutable_client();
            HV * hv4 = newHV();
            SV * sv3 = newRV_noinc((SV *)hv4);
            
            if ( msg4->has_quick_clone_name() ) {
              SV * sv4 = newSVpv(msg4->quick_clone_name().c_str(), msg4->quick_clone_name().length());
              hv_store(hv4, "quick_clone_name", sizeof("quick_clone_name") - 1, sv4, 0);
            }
            if ( msg4->has_snapshot_name() ) {
              SV * sv4 = newSVpv(msg4->snapshot_name().c_str(), msg4->snapshot_name().length());
              hv_store(hv4, "snapshot_name", sizeof("snapshot_name") - 1, sv4, 0);
            }
            if ( msg4->has_created_at() ) {
              SV * sv4 = newSVpv(msg4->created_at().c_str(), msg4->created_at().length());
              hv_store(hv4, "created_at", sizeof("created_at") - 1, sv4, 0);
            }
            if ( msg4->has_os() ) {
              ::HoneyClient::Message_Os * msg6 = msg4->mutable_os();
              HV * hv6 = newHV();
              SV * sv5 = newRV_noinc((SV *)hv6);
              
              if ( msg6->has_name() ) {
                SV * sv6 = newSVpv(msg6->name().c_str(), msg6->name().length());
                hv_store(hv6, "name", sizeof("name") - 1, sv6, 0);
              }
              if ( msg6->has_version() ) {
                SV * sv6 = newSVpv(msg6->version().c_str(), msg6->version().length());
                hv_store(hv6, "version", sizeof("version") - 1, sv6, 0);
              }
              if ( msg6->has_short_name() ) {
                SV * sv6 = newSVpv(msg6->short_name().c_str(), msg6->short_name().length());
                hv_store(hv6, "short_name", sizeof("short_name") - 1, sv6, 0);
              }
              hv_store(hv4, "os", sizeof("os") - 1, sv5, 0);
            }
            if ( msg4->has_application() ) {
              ::HoneyClient::Message_Application * msg6 = msg4->mutable_application();
              HV * hv6 = newHV();
              SV * sv5 = newRV_noinc((SV *)hv6);
              
              if ( msg6->has_manufacturer() ) {
                SV * sv6 = newSVpv(msg6->manufacturer().c_str(), msg6->manufacturer().length());
                hv_store(hv6, "manufacturer", sizeof("manufacturer") - 1, sv6, 0);
              }
              if ( msg6->has_version() ) {
                SV * sv6 = newSVpv(msg6->version().c_str(), msg6->version().length());
                hv_store(hv6, "version", sizeof("version") - 1, sv6, 0);
              }
              if ( msg6->has_short_name() ) {
                SV * sv6 = newSVpv(msg6->short_name().c_str(), msg6->short_name().length());
                hv_store(hv6, "short_name", sizeof("short_name") - 1, sv6, 0);
              }
              hv_store(hv4, "application", sizeof("application") - 1, sv5, 0);
            }
            if ( msg4->has_client_status() ) {
              ::HoneyClient::Message_ClientStatus * msg6 = msg4->mutable_client_status();
              HV * hv6 = newHV();
              SV * sv5 = newRV_noinc((SV *)hv6);
              
              if ( msg6->has_status() ) {
                SV * sv6 = newSVpv(msg6->status().c_str(), msg6->status().length());
                hv_store(hv6, "status", sizeof("status") - 1, sv6, 0);
              }
              if ( msg6->has_description() ) {
                SV * sv6 = newSVpv(msg6->description().c_str(), msg6->description().length());
                hv_store(hv6, "description", sizeof("description") - 1, sv6, 0);
              }
              hv_store(hv4, "client_status", sizeof("client_status") - 1, sv5, 0);
            }
            if ( msg4->has_host() ) {
              ::HoneyClient::Message_Host * msg6 = msg4->mutable_host();
              HV * hv6 = newHV();
              SV * sv5 = newRV_noinc((SV *)hv6);
              
              if ( msg6->has_hostname() ) {
                SV * sv6 = newSVpv(msg6->hostname().c_str(), msg6->hostname().length());
                hv_store(hv6, "hostname", sizeof("hostname") - 1, sv6, 0);
              }
              if ( msg6->has_ip() ) {
                SV * sv6 = newSVpv(msg6->ip().c_str(), msg6->ip().length());
                hv_store(hv6, "ip", sizeof("ip") - 1, sv6, 0);
              }
              hv_store(hv4, "host", sizeof("host") - 1, sv5, 0);
            }
            if ( msg4->has_suspended_at() ) {
              SV * sv4 = newSVpv(msg4->suspended_at().c_str(), msg4->suspended_at().length());
              hv_store(hv4, "suspended_at", sizeof("suspended_at") - 1, sv4, 0);
            }
            if ( msg4->has_ip() ) {
              SV * sv4 = newSVpv(msg4->ip().c_str(), msg4->ip().length());
              hv_store(hv4, "ip", sizeof("ip") - 1, sv4, 0);
            }
            if ( msg4->has_mac() ) {
              SV * sv4 = newSVpv(msg4->mac().c_str(), msg4->mac().length());
              hv_store(hv4, "mac", sizeof("mac") - 1, sv4, 0);
            }
            hv_store(hv2, "client", sizeof("client") - 1, sv3, 0);
          }
          if ( msg2->has_ip() ) {
            SV * sv2 = newSVpv(msg2->ip().c_str(), msg2->ip().length());
            hv_store(hv2, "ip", sizeof("ip") - 1, sv2, 0);
          }
          av_push(av0, sv1);
        }
        hv_store(hv0, "urls", sizeof("urls") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_uuid(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    RETVAL = THIS->has_uuid();

  OUTPUT:
    RETVAL


void
clear_uuid(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    THIS->clear_uuid();


void
uuid(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->uuid().c_str(),
                              THIS->uuid().length()));
      PUSHs(sv);
    }


void
set_uuid(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_uuid(sval);


I32
has_job_source(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    RETVAL = THIS->has_job_source();

  OUTPUT:
    RETVAL


void
clear_job_source(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    THIS->clear_job_source();


void
job_source(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_JobSource * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_JobSource;
      val->CopyFrom(THIS->job_source());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::JobSource", (void *)val);
      PUSHs(sv);
    }


void
set_job_source(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    ::HoneyClient::Message_JobSource * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::JobSource") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_JobSource *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::JobSource");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_JobSource * mval = THIS->mutable_job_source();
      mval->CopyFrom(*VAL);
    }


I32
has_created_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    RETVAL = THIS->has_created_at();

  OUTPUT:
    RETVAL


void
clear_created_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    THIS->clear_created_at();


void
created_at(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->created_at().c_str(),
                              THIS->created_at().length()));
      PUSHs(sv);
    }


void
set_created_at(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_created_at(sval);


I32
has_completed_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    RETVAL = THIS->has_completed_at();

  OUTPUT:
    RETVAL


void
clear_completed_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    THIS->clear_completed_at();


void
completed_at(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->completed_at().c_str(),
                              THIS->completed_at().length()));
      PUSHs(sv);
    }


void
set_completed_at(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_completed_at(sval);


I32
has_client(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    RETVAL = THIS->has_client();

  OUTPUT:
    RETVAL


void
clear_client(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    THIS->clear_client();


void
client(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_Client * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_Client;
      val->CopyFrom(THIS->client());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::Client", (void *)val);
      PUSHs(sv);
    }


void
set_client(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    ::HoneyClient::Message_Client * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::Client") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_Client *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::Client");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_Client * mval = THIS->mutable_client();
      mval->CopyFrom(*VAL);
    }


I32
job_alerts_size(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    RETVAL = THIS->job_alerts_size();

  OUTPUT:
    RETVAL


void
clear_job_alerts(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    THIS->clear_job_alerts();


void
job_alerts(svTHIS, ...)
  SV * svTHIS;
PREINIT:
    SV * sv;
    int index = 0;
    ::HoneyClient::Message_JobAlert * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::Job::job_alerts(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->job_alerts_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          val = new ::HoneyClient::Message_JobAlert;
          val->CopyFrom(THIS->job_alerts(index));
          sv = sv_newmortal();
          sv_setref_pv(sv, "HoneyClient::Message::JobAlert", (void *)val);
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->job_alerts_size() ) {
        EXTEND(SP,1);
        val = new ::HoneyClient::Message_JobAlert;
        val->CopyFrom(THIS->job_alerts(index));
        sv = sv_newmortal();
        sv_setref_pv(sv, "HoneyClient::Message::JobAlert", (void *)val);
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
add_job_alerts(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    ::HoneyClient::Message_JobAlert * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::JobAlert") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_JobAlert *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::JobAlert");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_JobAlert * mval = THIS->add_job_alerts();
      mval->CopyFrom(*VAL);
    }


I32
urls_size(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    RETVAL = THIS->urls_size();

  OUTPUT:
    RETVAL


void
clear_urls(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    THIS->clear_urls();


void
urls(svTHIS, ...)
  SV * svTHIS;
PREINIT:
    SV * sv;
    int index = 0;
    ::HoneyClient::Message_Url * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::Job::urls(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->urls_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          val = new ::HoneyClient::Message_Url;
          val->CopyFrom(THIS->urls(index));
          sv = sv_newmortal();
          sv_setref_pv(sv, "HoneyClient::Message::Url", (void *)val);
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->urls_size() ) {
        EXTEND(SP,1);
        val = new ::HoneyClient::Message_Url;
        val->CopyFrom(THIS->urls(index));
        sv = sv_newmortal();
        sv_setref_pv(sv, "HoneyClient::Message::Url", (void *)val);
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
add_urls(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Job * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Job") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Job *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Job");
    }
    ::HoneyClient::Message_Url * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::Url");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_Url * mval = THIS->add_urls();
      mval->CopyFrom(*VAL);
    }


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::FileContent
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_FileContent::new (...)
  PREINIT:
    ::HoneyClient::Message_FileContent * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::FileContent") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_FileContent_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_FileContent;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_FileContent;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::FileContent", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::FileContent") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_FileContent * other = INT2PTR(__HoneyClient__Message_FileContent *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_FileContent * other = __HoneyClient__Message_FileContent_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::FileContent") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_FileContent * other = INT2PTR(__HoneyClient__Message_FileContent *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_FileContent * other = __HoneyClient__Message_FileContent_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 5);
    PUSHs(sv_2mortal(newSVpv("size",0)));
    PUSHs(sv_2mortal(newSVpv("md5",0)));
    PUSHs(sv_2mortal(newSVpv("sha1",0)));
    PUSHs(sv_2mortal(newSVpv("mime_type",0)));
    PUSHs(sv_2mortal(newSVpv("data",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_FileContent * msg0 = THIS;

      if ( msg0->has_size() ) {
        ostringstream ost0;
        
        ost0 << msg0->size();
        SV * sv0 = newSVpv(ost0.str().c_str(), ost0.str().length());
        hv_store(hv0, "size", sizeof("size") - 1, sv0, 0);
      }
      if ( msg0->has_md5() ) {
        SV * sv0 = newSVpv(msg0->md5().c_str(), msg0->md5().length());
        hv_store(hv0, "md5", sizeof("md5") - 1, sv0, 0);
      }
      if ( msg0->has_sha1() ) {
        SV * sv0 = newSVpv(msg0->sha1().c_str(), msg0->sha1().length());
        hv_store(hv0, "sha1", sizeof("sha1") - 1, sv0, 0);
      }
      if ( msg0->has_mime_type() ) {
        SV * sv0 = newSVpv(msg0->mime_type().c_str(), msg0->mime_type().length());
        hv_store(hv0, "mime_type", sizeof("mime_type") - 1, sv0, 0);
      }
      if ( msg0->has_data() ) {
        SV * sv0 = newSVpv(msg0->data().c_str(), msg0->data().length());
        hv_store(hv0, "data", sizeof("data") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_size(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    RETVAL = THIS->has_size();

  OUTPUT:
    RETVAL


void
clear_size(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    THIS->clear_size();


void
size(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ostringstream ost;

  PPCODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      ost.str("");
      ost << THIS->size();
      sv = sv_2mortal(newSVpv(ost.str().c_str(),
                              ost.str().length()));
      PUSHs(sv);
    }


void
set_size(svTHIS, svVAL)
  SV * svTHIS
  char *svVAL

  PREINIT:
    unsigned long long lval;

  CODE:
    lval = strtoull((svVAL) ? svVAL : "", NULL, 0);
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    THIS->set_size(lval);


I32
has_md5(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    RETVAL = THIS->has_md5();

  OUTPUT:
    RETVAL


void
clear_md5(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    THIS->clear_md5();


void
md5(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->md5().c_str(),
                              THIS->md5().length()));
      PUSHs(sv);
    }


void
set_md5(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_md5(sval);


I32
has_sha1(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    RETVAL = THIS->has_sha1();

  OUTPUT:
    RETVAL


void
clear_sha1(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    THIS->clear_sha1();


void
sha1(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->sha1().c_str(),
                              THIS->sha1().length()));
      PUSHs(sv);
    }


void
set_sha1(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_sha1(sval);


I32
has_mime_type(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    RETVAL = THIS->has_mime_type();

  OUTPUT:
    RETVAL


void
clear_mime_type(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    THIS->clear_mime_type();


void
mime_type(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->mime_type().c_str(),
                              THIS->mime_type().length()));
      PUSHs(sv);
    }


void
set_mime_type(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_mime_type(sval);


I32
has_data(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    RETVAL = THIS->has_data();

  OUTPUT:
    RETVAL


void
clear_data(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    THIS->clear_data();


void
data(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->data().c_str(),
                              THIS->data().length()));
      PUSHs(sv);
    }


void
set_data(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_FileContent * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::FileContent");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_data(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::ProcessFile
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_ProcessFile::new (...)
  PREINIT:
    ::HoneyClient::Message_ProcessFile * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::ProcessFile") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_ProcessFile_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_ProcessFile;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_ProcessFile;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::ProcessFile", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::ProcessFile") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_ProcessFile * other = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_ProcessFile * other = __HoneyClient__Message_ProcessFile_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::ProcessFile") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_ProcessFile * other = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_ProcessFile * other = __HoneyClient__Message_ProcessFile_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 4);
    PUSHs(sv_2mortal(newSVpv("time_at",0)));
    PUSHs(sv_2mortal(newSVpv("name",0)));
    PUSHs(sv_2mortal(newSVpv("event",0)));
    PUSHs(sv_2mortal(newSVpv("file_content",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_ProcessFile * msg0 = THIS;

      if ( msg0->has_time_at() ) {
        SV * sv0 = newSVnv(msg0->time_at());
        hv_store(hv0, "time_at", sizeof("time_at") - 1, sv0, 0);
      }
      if ( msg0->has_name() ) {
        SV * sv0 = newSVpv(msg0->name().c_str(), msg0->name().length());
        hv_store(hv0, "name", sizeof("name") - 1, sv0, 0);
      }
      if ( msg0->has_event() ) {
        SV * sv0 = newSVpv(msg0->event().c_str(), msg0->event().length());
        hv_store(hv0, "event", sizeof("event") - 1, sv0, 0);
      }
      if ( msg0->has_file_content() ) {
        ::HoneyClient::Message_FileContent * msg2 = msg0->mutable_file_content();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_size() ) {
          ostringstream ost2;
          
          ost2 << msg2->size();
          SV * sv2 = newSVpv(ost2.str().c_str(), ost2.str().length());
          hv_store(hv2, "size", sizeof("size") - 1, sv2, 0);
        }
        if ( msg2->has_md5() ) {
          SV * sv2 = newSVpv(msg2->md5().c_str(), msg2->md5().length());
          hv_store(hv2, "md5", sizeof("md5") - 1, sv2, 0);
        }
        if ( msg2->has_sha1() ) {
          SV * sv2 = newSVpv(msg2->sha1().c_str(), msg2->sha1().length());
          hv_store(hv2, "sha1", sizeof("sha1") - 1, sv2, 0);
        }
        if ( msg2->has_mime_type() ) {
          SV * sv2 = newSVpv(msg2->mime_type().c_str(), msg2->mime_type().length());
          hv_store(hv2, "mime_type", sizeof("mime_type") - 1, sv2, 0);
        }
        if ( msg2->has_data() ) {
          SV * sv2 = newSVpv(msg2->data().c_str(), msg2->data().length());
          hv_store(hv2, "data", sizeof("data") - 1, sv2, 0);
        }
        hv_store(hv0, "file_content", sizeof("file_content") - 1, sv1, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_time_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    RETVAL = THIS->has_time_at();

  OUTPUT:
    RETVAL


void
clear_time_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    THIS->clear_time_at();


void
time_at(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVnv(THIS->time_at()));
      PUSHs(sv);
    }


void
set_time_at(svTHIS, svVAL)
  SV * svTHIS
  NV svVAL

  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    THIS->set_time_at(svVAL);


I32
has_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
clear_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    THIS->clear_name();


void
name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
set_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_name(sval);


I32
has_event(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    RETVAL = THIS->has_event();

  OUTPUT:
    RETVAL


void
clear_event(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    THIS->clear_event();


void
event(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->event().c_str(),
                              THIS->event().length()));
      PUSHs(sv);
    }


void
set_event(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_event(sval);


I32
has_file_content(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    RETVAL = THIS->has_file_content();

  OUTPUT:
    RETVAL


void
clear_file_content(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    THIS->clear_file_content();


void
file_content(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_FileContent * val = NULL;

  PPCODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_FileContent;
      val->CopyFrom(THIS->file_content());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::FileContent", (void *)val);
      PUSHs(sv);
    }


void
set_file_content(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_ProcessFile * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessFile");
    }
    ::HoneyClient::Message_FileContent * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::FileContent") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_FileContent *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::FileContent");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_FileContent * mval = THIS->mutable_file_content();
      mval->CopyFrom(*VAL);
    }


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::ProcessRegistry
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_ProcessRegistry::new (...)
  PREINIT:
    ::HoneyClient::Message_ProcessRegistry * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::ProcessRegistry") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_ProcessRegistry_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_ProcessRegistry;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_ProcessRegistry;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::ProcessRegistry", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::ProcessRegistry") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_ProcessRegistry * other = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_ProcessRegistry * other = __HoneyClient__Message_ProcessRegistry_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::ProcessRegistry") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_ProcessRegistry * other = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_ProcessRegistry * other = __HoneyClient__Message_ProcessRegistry_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 6);
    PUSHs(sv_2mortal(newSVpv("time_at",0)));
    PUSHs(sv_2mortal(newSVpv("name",0)));
    PUSHs(sv_2mortal(newSVpv("event",0)));
    PUSHs(sv_2mortal(newSVpv("value_name",0)));
    PUSHs(sv_2mortal(newSVpv("value_type",0)));
    PUSHs(sv_2mortal(newSVpv("value",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_ProcessRegistry * msg0 = THIS;

      if ( msg0->has_time_at() ) {
        SV * sv0 = newSVnv(msg0->time_at());
        hv_store(hv0, "time_at", sizeof("time_at") - 1, sv0, 0);
      }
      if ( msg0->has_name() ) {
        SV * sv0 = newSVpv(msg0->name().c_str(), msg0->name().length());
        hv_store(hv0, "name", sizeof("name") - 1, sv0, 0);
      }
      if ( msg0->has_event() ) {
        SV * sv0 = newSVpv(msg0->event().c_str(), msg0->event().length());
        hv_store(hv0, "event", sizeof("event") - 1, sv0, 0);
      }
      if ( msg0->has_value_name() ) {
        SV * sv0 = newSVpv(msg0->value_name().c_str(), msg0->value_name().length());
        hv_store(hv0, "value_name", sizeof("value_name") - 1, sv0, 0);
      }
      if ( msg0->has_value_type() ) {
        SV * sv0 = newSVpv(msg0->value_type().c_str(), msg0->value_type().length());
        hv_store(hv0, "value_type", sizeof("value_type") - 1, sv0, 0);
      }
      if ( msg0->has_value() ) {
        SV * sv0 = newSVpv(msg0->value().c_str(), msg0->value().length());
        hv_store(hv0, "value", sizeof("value") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_time_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    RETVAL = THIS->has_time_at();

  OUTPUT:
    RETVAL


void
clear_time_at(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    THIS->clear_time_at();


void
time_at(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVnv(THIS->time_at()));
      PUSHs(sv);
    }


void
set_time_at(svTHIS, svVAL)
  SV * svTHIS
  NV svVAL

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    THIS->set_time_at(svVAL);


I32
has_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
clear_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    THIS->clear_name();


void
name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
set_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_name(sval);


I32
has_event(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    RETVAL = THIS->has_event();

  OUTPUT:
    RETVAL


void
clear_event(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    THIS->clear_event();


void
event(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->event().c_str(),
                              THIS->event().length()));
      PUSHs(sv);
    }


void
set_event(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_event(sval);


I32
has_value_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    RETVAL = THIS->has_value_name();

  OUTPUT:
    RETVAL


void
clear_value_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    THIS->clear_value_name();


void
value_name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->value_name().c_str(),
                              THIS->value_name().length()));
      PUSHs(sv);
    }


void
set_value_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_value_name(sval);


I32
has_value_type(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    RETVAL = THIS->has_value_type();

  OUTPUT:
    RETVAL


void
clear_value_type(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    THIS->clear_value_type();


void
value_type(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->value_type().c_str(),
                              THIS->value_type().length()));
      PUSHs(sv);
    }


void
set_value_type(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_value_type(sval);


I32
has_value(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    RETVAL = THIS->has_value();

  OUTPUT:
    RETVAL


void
clear_value(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    THIS->clear_value();


void
value(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->value().c_str(),
                              THIS->value().length()));
      PUSHs(sv);
    }


void
set_value(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_ProcessRegistry * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::ProcessRegistry");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_value(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::OsProcess
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_OsProcess::new (...)
  PREINIT:
    ::HoneyClient::Message_OsProcess * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::OsProcess") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_OsProcess_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_OsProcess;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_OsProcess;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::OsProcess", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::OsProcess") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_OsProcess * other = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_OsProcess * other = __HoneyClient__Message_OsProcess_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::OsProcess") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_OsProcess * other = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_OsProcess * other = __HoneyClient__Message_OsProcess_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 6);
    PUSHs(sv_2mortal(newSVpv("name",0)));
    PUSHs(sv_2mortal(newSVpv("pid",0)));
    PUSHs(sv_2mortal(newSVpv("parent_name",0)));
    PUSHs(sv_2mortal(newSVpv("parent_pid",0)));
    PUSHs(sv_2mortal(newSVpv("process_files",0)));
    PUSHs(sv_2mortal(newSVpv("process_registries",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_OsProcess * msg0 = THIS;

      if ( msg0->has_name() ) {
        SV * sv0 = newSVpv(msg0->name().c_str(), msg0->name().length());
        hv_store(hv0, "name", sizeof("name") - 1, sv0, 0);
      }
      if ( msg0->has_pid() ) {
        ostringstream ost0;
        
        ost0 << msg0->pid();
        SV * sv0 = newSVpv(ost0.str().c_str(), ost0.str().length());
        hv_store(hv0, "pid", sizeof("pid") - 1, sv0, 0);
      }
      if ( msg0->has_parent_name() ) {
        SV * sv0 = newSVpv(msg0->parent_name().c_str(), msg0->parent_name().length());
        hv_store(hv0, "parent_name", sizeof("parent_name") - 1, sv0, 0);
      }
      if ( msg0->has_parent_pid() ) {
        ostringstream ost0;
        
        ost0 << msg0->parent_pid();
        SV * sv0 = newSVpv(ost0.str().c_str(), ost0.str().length());
        hv_store(hv0, "parent_pid", sizeof("parent_pid") - 1, sv0, 0);
      }
      if ( msg0->process_files_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->process_files_size(); i0++ ) {
          ::HoneyClient::Message_ProcessFile * msg2 = msg0->mutable_process_files(i0);
          HV * hv2 = newHV();
          SV * sv1 = newRV_noinc((SV *)hv2);
          
          if ( msg2->has_time_at() ) {
            SV * sv2 = newSVnv(msg2->time_at());
            hv_store(hv2, "time_at", sizeof("time_at") - 1, sv2, 0);
          }
          if ( msg2->has_name() ) {
            SV * sv2 = newSVpv(msg2->name().c_str(), msg2->name().length());
            hv_store(hv2, "name", sizeof("name") - 1, sv2, 0);
          }
          if ( msg2->has_event() ) {
            SV * sv2 = newSVpv(msg2->event().c_str(), msg2->event().length());
            hv_store(hv2, "event", sizeof("event") - 1, sv2, 0);
          }
          if ( msg2->has_file_content() ) {
            ::HoneyClient::Message_FileContent * msg4 = msg2->mutable_file_content();
            HV * hv4 = newHV();
            SV * sv3 = newRV_noinc((SV *)hv4);
            
            if ( msg4->has_size() ) {
              ostringstream ost4;
              
              ost4 << msg4->size();
              SV * sv4 = newSVpv(ost4.str().c_str(), ost4.str().length());
              hv_store(hv4, "size", sizeof("size") - 1, sv4, 0);
            }
            if ( msg4->has_md5() ) {
              SV * sv4 = newSVpv(msg4->md5().c_str(), msg4->md5().length());
              hv_store(hv4, "md5", sizeof("md5") - 1, sv4, 0);
            }
            if ( msg4->has_sha1() ) {
              SV * sv4 = newSVpv(msg4->sha1().c_str(), msg4->sha1().length());
              hv_store(hv4, "sha1", sizeof("sha1") - 1, sv4, 0);
            }
            if ( msg4->has_mime_type() ) {
              SV * sv4 = newSVpv(msg4->mime_type().c_str(), msg4->mime_type().length());
              hv_store(hv4, "mime_type", sizeof("mime_type") - 1, sv4, 0);
            }
            if ( msg4->has_data() ) {
              SV * sv4 = newSVpv(msg4->data().c_str(), msg4->data().length());
              hv_store(hv4, "data", sizeof("data") - 1, sv4, 0);
            }
            hv_store(hv2, "file_content", sizeof("file_content") - 1, sv3, 0);
          }
          av_push(av0, sv1);
        }
        hv_store(hv0, "process_files", sizeof("process_files") - 1, sv0, 0);
      }
      if ( msg0->process_registries_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->process_registries_size(); i0++ ) {
          ::HoneyClient::Message_ProcessRegistry * msg2 = msg0->mutable_process_registries(i0);
          HV * hv2 = newHV();
          SV * sv1 = newRV_noinc((SV *)hv2);
          
          if ( msg2->has_time_at() ) {
            SV * sv2 = newSVnv(msg2->time_at());
            hv_store(hv2, "time_at", sizeof("time_at") - 1, sv2, 0);
          }
          if ( msg2->has_name() ) {
            SV * sv2 = newSVpv(msg2->name().c_str(), msg2->name().length());
            hv_store(hv2, "name", sizeof("name") - 1, sv2, 0);
          }
          if ( msg2->has_event() ) {
            SV * sv2 = newSVpv(msg2->event().c_str(), msg2->event().length());
            hv_store(hv2, "event", sizeof("event") - 1, sv2, 0);
          }
          if ( msg2->has_value_name() ) {
            SV * sv2 = newSVpv(msg2->value_name().c_str(), msg2->value_name().length());
            hv_store(hv2, "value_name", sizeof("value_name") - 1, sv2, 0);
          }
          if ( msg2->has_value_type() ) {
            SV * sv2 = newSVpv(msg2->value_type().c_str(), msg2->value_type().length());
            hv_store(hv2, "value_type", sizeof("value_type") - 1, sv2, 0);
          }
          if ( msg2->has_value() ) {
            SV * sv2 = newSVpv(msg2->value().c_str(), msg2->value().length());
            hv_store(hv2, "value", sizeof("value") - 1, sv2, 0);
          }
          av_push(av0, sv1);
        }
        hv_store(hv0, "process_registries", sizeof("process_registries") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
clear_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    THIS->clear_name();


void
name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
set_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_name(sval);


I32
has_pid(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    RETVAL = THIS->has_pid();

  OUTPUT:
    RETVAL


void
clear_pid(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    THIS->clear_pid();


void
pid(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ostringstream ost;

  PPCODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      ost.str("");
      ost << THIS->pid();
      sv = sv_2mortal(newSVpv(ost.str().c_str(),
                              ost.str().length()));
      PUSHs(sv);
    }


void
set_pid(svTHIS, svVAL)
  SV * svTHIS
  char *svVAL

  PREINIT:
    unsigned long long lval;

  CODE:
    lval = strtoull((svVAL) ? svVAL : "", NULL, 0);
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    THIS->set_pid(lval);


I32
has_parent_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    RETVAL = THIS->has_parent_name();

  OUTPUT:
    RETVAL


void
clear_parent_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    THIS->clear_parent_name();


void
parent_name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->parent_name().c_str(),
                              THIS->parent_name().length()));
      PUSHs(sv);
    }


void
set_parent_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_parent_name(sval);


I32
has_parent_pid(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    RETVAL = THIS->has_parent_pid();

  OUTPUT:
    RETVAL


void
clear_parent_pid(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    THIS->clear_parent_pid();


void
parent_pid(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ostringstream ost;

  PPCODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      ost.str("");
      ost << THIS->parent_pid();
      sv = sv_2mortal(newSVpv(ost.str().c_str(),
                              ost.str().length()));
      PUSHs(sv);
    }


void
set_parent_pid(svTHIS, svVAL)
  SV * svTHIS
  char *svVAL

  PREINIT:
    unsigned long long lval;

  CODE:
    lval = strtoull((svVAL) ? svVAL : "", NULL, 0);
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    THIS->set_parent_pid(lval);


I32
process_files_size(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    RETVAL = THIS->process_files_size();

  OUTPUT:
    RETVAL


void
clear_process_files(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    THIS->clear_process_files();


void
process_files(svTHIS, ...)
  SV * svTHIS;
PREINIT:
    SV * sv;
    int index = 0;
    ::HoneyClient::Message_ProcessFile * val = NULL;

  PPCODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::OsProcess::process_files(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->process_files_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          val = new ::HoneyClient::Message_ProcessFile;
          val->CopyFrom(THIS->process_files(index));
          sv = sv_newmortal();
          sv_setref_pv(sv, "HoneyClient::Message::ProcessFile", (void *)val);
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->process_files_size() ) {
        EXTEND(SP,1);
        val = new ::HoneyClient::Message_ProcessFile;
        val->CopyFrom(THIS->process_files(index));
        sv = sv_newmortal();
        sv_setref_pv(sv, "HoneyClient::Message::ProcessFile", (void *)val);
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
add_process_files(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    ::HoneyClient::Message_ProcessFile * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::ProcessFile") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_ProcessFile *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::ProcessFile");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_ProcessFile * mval = THIS->add_process_files();
      mval->CopyFrom(*VAL);
    }


I32
process_registries_size(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    RETVAL = THIS->process_registries_size();

  OUTPUT:
    RETVAL


void
clear_process_registries(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    THIS->clear_process_registries();


void
process_registries(svTHIS, ...)
  SV * svTHIS;
PREINIT:
    SV * sv;
    int index = 0;
    ::HoneyClient::Message_ProcessRegistry * val = NULL;

  PPCODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::OsProcess::process_registries(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->process_registries_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          val = new ::HoneyClient::Message_ProcessRegistry;
          val->CopyFrom(THIS->process_registries(index));
          sv = sv_newmortal();
          sv_setref_pv(sv, "HoneyClient::Message::ProcessRegistry", (void *)val);
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->process_registries_size() ) {
        EXTEND(SP,1);
        val = new ::HoneyClient::Message_ProcessRegistry;
        val->CopyFrom(THIS->process_registries(index));
        sv = sv_newmortal();
        sv_setref_pv(sv, "HoneyClient::Message::ProcessRegistry", (void *)val);
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
add_process_registries(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_OsProcess * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::OsProcess");
    }
    ::HoneyClient::Message_ProcessRegistry * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::ProcessRegistry") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_ProcessRegistry *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::ProcessRegistry");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_ProcessRegistry * mval = THIS->add_process_registries();
      mval->CopyFrom(*VAL);
    }


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Fingerprint
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Fingerprint::new (...)
  PREINIT:
    ::HoneyClient::Message_Fingerprint * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Fingerprint") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Fingerprint_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Fingerprint;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Fingerprint;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Fingerprint", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Fingerprint") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Fingerprint * other = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Fingerprint * other = __HoneyClient__Message_Fingerprint_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Fingerprint") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Fingerprint * other = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Fingerprint * other = __HoneyClient__Message_Fingerprint_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 4);
    PUSHs(sv_2mortal(newSVpv("checksum",0)));
    PUSHs(sv_2mortal(newSVpv("pcap",0)));
    PUSHs(sv_2mortal(newSVpv("url",0)));
    PUSHs(sv_2mortal(newSVpv("os_processes",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Fingerprint * msg0 = THIS;

      if ( msg0->has_checksum() ) {
        SV * sv0 = newSVpv(msg0->checksum().c_str(), msg0->checksum().length());
        hv_store(hv0, "checksum", sizeof("checksum") - 1, sv0, 0);
      }
      if ( msg0->has_pcap() ) {
        SV * sv0 = newSVpv(msg0->pcap().c_str(), msg0->pcap().length());
        hv_store(hv0, "pcap", sizeof("pcap") - 1, sv0, 0);
      }
      if ( msg0->has_url() ) {
        ::HoneyClient::Message_Url * msg2 = msg0->mutable_url();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_url() ) {
          SV * sv2 = newSVpv(msg2->url().c_str(), msg2->url().length());
          hv_store(hv2, "url", sizeof("url") - 1, sv2, 0);
        }
        if ( msg2->has_priority() ) {
          ostringstream ost2;
          
          ost2 << msg2->priority();
          SV * sv2 = newSVpv(ost2.str().c_str(), ost2.str().length());
          hv_store(hv2, "priority", sizeof("priority") - 1, sv2, 0);
        }
        if ( msg2->has_url_status() ) {
          ::HoneyClient::Message_UrlStatus * msg4 = msg2->mutable_url_status();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_status() ) {
            SV * sv4 = newSVpv(msg4->status().c_str(), msg4->status().length());
            hv_store(hv4, "status", sizeof("status") - 1, sv4, 0);
          }
          if ( msg4->has_description() ) {
            SV * sv4 = newSVpv(msg4->description().c_str(), msg4->description().length());
            hv_store(hv4, "description", sizeof("description") - 1, sv4, 0);
          }
          hv_store(hv2, "url_status", sizeof("url_status") - 1, sv3, 0);
        }
        if ( msg2->has_time_at() ) {
          SV * sv2 = newSVnv(msg2->time_at());
          hv_store(hv2, "time_at", sizeof("time_at") - 1, sv2, 0);
        }
        if ( msg2->has_client() ) {
          ::HoneyClient::Message_Client * msg4 = msg2->mutable_client();
          HV * hv4 = newHV();
          SV * sv3 = newRV_noinc((SV *)hv4);
          
          if ( msg4->has_quick_clone_name() ) {
            SV * sv4 = newSVpv(msg4->quick_clone_name().c_str(), msg4->quick_clone_name().length());
            hv_store(hv4, "quick_clone_name", sizeof("quick_clone_name") - 1, sv4, 0);
          }
          if ( msg4->has_snapshot_name() ) {
            SV * sv4 = newSVpv(msg4->snapshot_name().c_str(), msg4->snapshot_name().length());
            hv_store(hv4, "snapshot_name", sizeof("snapshot_name") - 1, sv4, 0);
          }
          if ( msg4->has_created_at() ) {
            SV * sv4 = newSVpv(msg4->created_at().c_str(), msg4->created_at().length());
            hv_store(hv4, "created_at", sizeof("created_at") - 1, sv4, 0);
          }
          if ( msg4->has_os() ) {
            ::HoneyClient::Message_Os * msg6 = msg4->mutable_os();
            HV * hv6 = newHV();
            SV * sv5 = newRV_noinc((SV *)hv6);
            
            if ( msg6->has_name() ) {
              SV * sv6 = newSVpv(msg6->name().c_str(), msg6->name().length());
              hv_store(hv6, "name", sizeof("name") - 1, sv6, 0);
            }
            if ( msg6->has_version() ) {
              SV * sv6 = newSVpv(msg6->version().c_str(), msg6->version().length());
              hv_store(hv6, "version", sizeof("version") - 1, sv6, 0);
            }
            if ( msg6->has_short_name() ) {
              SV * sv6 = newSVpv(msg6->short_name().c_str(), msg6->short_name().length());
              hv_store(hv6, "short_name", sizeof("short_name") - 1, sv6, 0);
            }
            hv_store(hv4, "os", sizeof("os") - 1, sv5, 0);
          }
          if ( msg4->has_application() ) {
            ::HoneyClient::Message_Application * msg6 = msg4->mutable_application();
            HV * hv6 = newHV();
            SV * sv5 = newRV_noinc((SV *)hv6);
            
            if ( msg6->has_manufacturer() ) {
              SV * sv6 = newSVpv(msg6->manufacturer().c_str(), msg6->manufacturer().length());
              hv_store(hv6, "manufacturer", sizeof("manufacturer") - 1, sv6, 0);
            }
            if ( msg6->has_version() ) {
              SV * sv6 = newSVpv(msg6->version().c_str(), msg6->version().length());
              hv_store(hv6, "version", sizeof("version") - 1, sv6, 0);
            }
            if ( msg6->has_short_name() ) {
              SV * sv6 = newSVpv(msg6->short_name().c_str(), msg6->short_name().length());
              hv_store(hv6, "short_name", sizeof("short_name") - 1, sv6, 0);
            }
            hv_store(hv4, "application", sizeof("application") - 1, sv5, 0);
          }
          if ( msg4->has_client_status() ) {
            ::HoneyClient::Message_ClientStatus * msg6 = msg4->mutable_client_status();
            HV * hv6 = newHV();
            SV * sv5 = newRV_noinc((SV *)hv6);
            
            if ( msg6->has_status() ) {
              SV * sv6 = newSVpv(msg6->status().c_str(), msg6->status().length());
              hv_store(hv6, "status", sizeof("status") - 1, sv6, 0);
            }
            if ( msg6->has_description() ) {
              SV * sv6 = newSVpv(msg6->description().c_str(), msg6->description().length());
              hv_store(hv6, "description", sizeof("description") - 1, sv6, 0);
            }
            hv_store(hv4, "client_status", sizeof("client_status") - 1, sv5, 0);
          }
          if ( msg4->has_host() ) {
            ::HoneyClient::Message_Host * msg6 = msg4->mutable_host();
            HV * hv6 = newHV();
            SV * sv5 = newRV_noinc((SV *)hv6);
            
            if ( msg6->has_hostname() ) {
              SV * sv6 = newSVpv(msg6->hostname().c_str(), msg6->hostname().length());
              hv_store(hv6, "hostname", sizeof("hostname") - 1, sv6, 0);
            }
            if ( msg6->has_ip() ) {
              SV * sv6 = newSVpv(msg6->ip().c_str(), msg6->ip().length());
              hv_store(hv6, "ip", sizeof("ip") - 1, sv6, 0);
            }
            hv_store(hv4, "host", sizeof("host") - 1, sv5, 0);
          }
          if ( msg4->has_suspended_at() ) {
            SV * sv4 = newSVpv(msg4->suspended_at().c_str(), msg4->suspended_at().length());
            hv_store(hv4, "suspended_at", sizeof("suspended_at") - 1, sv4, 0);
          }
          if ( msg4->has_ip() ) {
            SV * sv4 = newSVpv(msg4->ip().c_str(), msg4->ip().length());
            hv_store(hv4, "ip", sizeof("ip") - 1, sv4, 0);
          }
          if ( msg4->has_mac() ) {
            SV * sv4 = newSVpv(msg4->mac().c_str(), msg4->mac().length());
            hv_store(hv4, "mac", sizeof("mac") - 1, sv4, 0);
          }
          hv_store(hv2, "client", sizeof("client") - 1, sv3, 0);
        }
        if ( msg2->has_ip() ) {
          SV * sv2 = newSVpv(msg2->ip().c_str(), msg2->ip().length());
          hv_store(hv2, "ip", sizeof("ip") - 1, sv2, 0);
        }
        hv_store(hv0, "url", sizeof("url") - 1, sv1, 0);
      }
      if ( msg0->os_processes_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->os_processes_size(); i0++ ) {
          ::HoneyClient::Message_OsProcess * msg2 = msg0->mutable_os_processes(i0);
          HV * hv2 = newHV();
          SV * sv1 = newRV_noinc((SV *)hv2);
          
          if ( msg2->has_name() ) {
            SV * sv2 = newSVpv(msg2->name().c_str(), msg2->name().length());
            hv_store(hv2, "name", sizeof("name") - 1, sv2, 0);
          }
          if ( msg2->has_pid() ) {
            ostringstream ost2;
            
            ost2 << msg2->pid();
            SV * sv2 = newSVpv(ost2.str().c_str(), ost2.str().length());
            hv_store(hv2, "pid", sizeof("pid") - 1, sv2, 0);
          }
          if ( msg2->has_parent_name() ) {
            SV * sv2 = newSVpv(msg2->parent_name().c_str(), msg2->parent_name().length());
            hv_store(hv2, "parent_name", sizeof("parent_name") - 1, sv2, 0);
          }
          if ( msg2->has_parent_pid() ) {
            ostringstream ost2;
            
            ost2 << msg2->parent_pid();
            SV * sv2 = newSVpv(ost2.str().c_str(), ost2.str().length());
            hv_store(hv2, "parent_pid", sizeof("parent_pid") - 1, sv2, 0);
          }
          if ( msg2->process_files_size() > 0 ) {
            AV * av2 = newAV();
            SV * sv2 = newRV_noinc((SV *)av2);
            
            for ( int i2 = 0; i2 < msg2->process_files_size(); i2++ ) {
              ::HoneyClient::Message_ProcessFile * msg4 = msg2->mutable_process_files(i2);
              HV * hv4 = newHV();
              SV * sv3 = newRV_noinc((SV *)hv4);
              
              if ( msg4->has_time_at() ) {
                SV * sv4 = newSVnv(msg4->time_at());
                hv_store(hv4, "time_at", sizeof("time_at") - 1, sv4, 0);
              }
              if ( msg4->has_name() ) {
                SV * sv4 = newSVpv(msg4->name().c_str(), msg4->name().length());
                hv_store(hv4, "name", sizeof("name") - 1, sv4, 0);
              }
              if ( msg4->has_event() ) {
                SV * sv4 = newSVpv(msg4->event().c_str(), msg4->event().length());
                hv_store(hv4, "event", sizeof("event") - 1, sv4, 0);
              }
              if ( msg4->has_file_content() ) {
                ::HoneyClient::Message_FileContent * msg6 = msg4->mutable_file_content();
                HV * hv6 = newHV();
                SV * sv5 = newRV_noinc((SV *)hv6);
                
                if ( msg6->has_size() ) {
                  ostringstream ost6;
                  
                  ost6 << msg6->size();
                  SV * sv6 = newSVpv(ost6.str().c_str(), ost6.str().length());
                  hv_store(hv6, "size", sizeof("size") - 1, sv6, 0);
                }
                if ( msg6->has_md5() ) {
                  SV * sv6 = newSVpv(msg6->md5().c_str(), msg6->md5().length());
                  hv_store(hv6, "md5", sizeof("md5") - 1, sv6, 0);
                }
                if ( msg6->has_sha1() ) {
                  SV * sv6 = newSVpv(msg6->sha1().c_str(), msg6->sha1().length());
                  hv_store(hv6, "sha1", sizeof("sha1") - 1, sv6, 0);
                }
                if ( msg6->has_mime_type() ) {
                  SV * sv6 = newSVpv(msg6->mime_type().c_str(), msg6->mime_type().length());
                  hv_store(hv6, "mime_type", sizeof("mime_type") - 1, sv6, 0);
                }
                if ( msg6->has_data() ) {
                  SV * sv6 = newSVpv(msg6->data().c_str(), msg6->data().length());
                  hv_store(hv6, "data", sizeof("data") - 1, sv6, 0);
                }
                hv_store(hv4, "file_content", sizeof("file_content") - 1, sv5, 0);
              }
              av_push(av2, sv3);
            }
            hv_store(hv2, "process_files", sizeof("process_files") - 1, sv2, 0);
          }
          if ( msg2->process_registries_size() > 0 ) {
            AV * av2 = newAV();
            SV * sv2 = newRV_noinc((SV *)av2);
            
            for ( int i2 = 0; i2 < msg2->process_registries_size(); i2++ ) {
              ::HoneyClient::Message_ProcessRegistry * msg4 = msg2->mutable_process_registries(i2);
              HV * hv4 = newHV();
              SV * sv3 = newRV_noinc((SV *)hv4);
              
              if ( msg4->has_time_at() ) {
                SV * sv4 = newSVnv(msg4->time_at());
                hv_store(hv4, "time_at", sizeof("time_at") - 1, sv4, 0);
              }
              if ( msg4->has_name() ) {
                SV * sv4 = newSVpv(msg4->name().c_str(), msg4->name().length());
                hv_store(hv4, "name", sizeof("name") - 1, sv4, 0);
              }
              if ( msg4->has_event() ) {
                SV * sv4 = newSVpv(msg4->event().c_str(), msg4->event().length());
                hv_store(hv4, "event", sizeof("event") - 1, sv4, 0);
              }
              if ( msg4->has_value_name() ) {
                SV * sv4 = newSVpv(msg4->value_name().c_str(), msg4->value_name().length());
                hv_store(hv4, "value_name", sizeof("value_name") - 1, sv4, 0);
              }
              if ( msg4->has_value_type() ) {
                SV * sv4 = newSVpv(msg4->value_type().c_str(), msg4->value_type().length());
                hv_store(hv4, "value_type", sizeof("value_type") - 1, sv4, 0);
              }
              if ( msg4->has_value() ) {
                SV * sv4 = newSVpv(msg4->value().c_str(), msg4->value().length());
                hv_store(hv4, "value", sizeof("value") - 1, sv4, 0);
              }
              av_push(av2, sv3);
            }
            hv_store(hv2, "process_registries", sizeof("process_registries") - 1, sv2, 0);
          }
          av_push(av0, sv1);
        }
        hv_store(hv0, "os_processes", sizeof("os_processes") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_checksum(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    RETVAL = THIS->has_checksum();

  OUTPUT:
    RETVAL


void
clear_checksum(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    THIS->clear_checksum();


void
checksum(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->checksum().c_str(),
                              THIS->checksum().length()));
      PUSHs(sv);
    }


void
set_checksum(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_checksum(sval);


I32
has_pcap(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    RETVAL = THIS->has_pcap();

  OUTPUT:
    RETVAL


void
clear_pcap(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    THIS->clear_pcap();


void
pcap(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->pcap().c_str(),
                              THIS->pcap().length()));
      PUSHs(sv);
    }


void
set_pcap(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_pcap(sval);


I32
has_url(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    RETVAL = THIS->has_url();

  OUTPUT:
    RETVAL


void
clear_url(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    THIS->clear_url();


void
url(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;
    ::HoneyClient::Message_Url * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_Url;
      val->CopyFrom(THIS->url());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::Url", (void *)val);
      PUSHs(sv);
    }


void
set_url(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    ::HoneyClient::Message_Url * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::Url") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_Url *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::Url");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_Url * mval = THIS->mutable_url();
      mval->CopyFrom(*VAL);
    }


I32
os_processes_size(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    RETVAL = THIS->os_processes_size();

  OUTPUT:
    RETVAL


void
clear_os_processes(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    THIS->clear_os_processes();


void
os_processes(svTHIS, ...)
  SV * svTHIS;
PREINIT:
    SV * sv;
    int index = 0;
    ::HoneyClient::Message_OsProcess * val = NULL;

  PPCODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::Fingerprint::os_processes(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->os_processes_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          val = new ::HoneyClient::Message_OsProcess;
          val->CopyFrom(THIS->os_processes(index));
          sv = sv_newmortal();
          sv_setref_pv(sv, "HoneyClient::Message::OsProcess", (void *)val);
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->os_processes_size() ) {
        EXTEND(SP,1);
        val = new ::HoneyClient::Message_OsProcess;
        val->CopyFrom(THIS->os_processes(index));
        sv = sv_newmortal();
        sv_setref_pv(sv, "HoneyClient::Message::OsProcess", (void *)val);
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
add_os_processes(svTHIS, svVAL)
  SV * svTHIS
  SV * svVAL
  CODE:
    ::HoneyClient::Message_Fingerprint * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Fingerprint") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Fingerprint *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Fingerprint");
    }
    ::HoneyClient::Message_OsProcess * VAL;
    if ( sv_derived_from(svVAL, "HoneyClient::Message::OsProcess") ) {
      IV tmp = SvIV((SV *)SvRV(svVAL));
      VAL = INT2PTR(__HoneyClient__Message_OsProcess *, tmp);
    } else {
      croak("VAL is not of type HoneyClient::Message::OsProcess");
    }
    if ( VAL != NULL ) {
      ::HoneyClient::Message_OsProcess * mval = THIS->add_os_processes();
      mval->CopyFrom(*VAL);
    }


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Firewall::Command
PROTOTYPES: ENABLE


BOOT:
  {
    HV * stash;

    stash = gv_stashpv("HoneyClient::Message::Firewall::Command::ActionType", TRUE);
    newCONSTSUB(stash, "UNKNOWN", newSViv(::HoneyClient::Message_Firewall_Command::UNKNOWN));
    newCONSTSUB(stash, "DENY_ALL", newSViv(::HoneyClient::Message_Firewall_Command::DENY_ALL));
    newCONSTSUB(stash, "DENY_VM", newSViv(::HoneyClient::Message_Firewall_Command::DENY_VM));
    newCONSTSUB(stash, "ALLOW_VM", newSViv(::HoneyClient::Message_Firewall_Command::ALLOW_VM));
    newCONSTSUB(stash, "ALLOW_ALL", newSViv(::HoneyClient::Message_Firewall_Command::ALLOW_ALL));
    stash = gv_stashpv("HoneyClient::Message::Firewall::Command::ResponseType", TRUE);
    newCONSTSUB(stash, "ERROR", newSViv(::HoneyClient::Message_Firewall_Command::ERROR));
    newCONSTSUB(stash, "OK", newSViv(::HoneyClient::Message_Firewall_Command::OK));
  }


SV *
::HoneyClient::Message_Firewall_Command::new (...)
  PREINIT:
    ::HoneyClient::Message_Firewall_Command * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Firewall::Command") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Firewall_Command_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Firewall_Command;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Firewall_Command;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Firewall::Command", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Firewall::Command") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Firewall_Command * other = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Firewall_Command * other = __HoneyClient__Message_Firewall_Command_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Firewall::Command") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Firewall_Command * other = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Firewall_Command * other = __HoneyClient__Message_Firewall_Command_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
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
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Firewall_Command * msg0 = THIS;

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
has_action(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    RETVAL = THIS->has_action();

  OUTPUT:
    RETVAL


void
clear_action(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    THIS->clear_action();


void
action(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->action()));
      PUSHs(sv);
    }


void
set_action(svTHIS, svVAL)
  SV * svTHIS
  IV svVAL

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( ::HoneyClient::Message_Firewall_Command_ActionType_IsValid(svVAL) ) {
      THIS->set_action((::HoneyClient::Message_Firewall_Command_ActionType)svVAL);
    }


I32
has_response(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    RETVAL = THIS->has_response();

  OUTPUT:
    RETVAL


void
clear_response(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    THIS->clear_response();


void
response(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->response()));
      PUSHs(sv);
    }


void
set_response(svTHIS, svVAL)
  SV * svTHIS
  IV svVAL

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( ::HoneyClient::Message_Firewall_Command_ResponseType_IsValid(svVAL) ) {
      THIS->set_response((::HoneyClient::Message_Firewall_Command_ResponseType)svVAL);
    }


I32
has_err_message(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    RETVAL = THIS->has_err_message();

  OUTPUT:
    RETVAL


void
clear_err_message(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    THIS->clear_err_message();


void
err_message(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->err_message().c_str(),
                              THIS->err_message().length()));
      PUSHs(sv);
    }


void
set_err_message(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_err_message(sval);


I32
has_chain_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    RETVAL = THIS->has_chain_name();

  OUTPUT:
    RETVAL


void
clear_chain_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    THIS->clear_chain_name();


void
chain_name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->chain_name().c_str(),
                              THIS->chain_name().length()));
      PUSHs(sv);
    }


void
set_chain_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_chain_name(sval);


I32
has_mac_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    RETVAL = THIS->has_mac_address();

  OUTPUT:
    RETVAL


void
clear_mac_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    THIS->clear_mac_address();


void
mac_address(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->mac_address().c_str(),
                              THIS->mac_address().length()));
      PUSHs(sv);
    }


void
set_mac_address(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_mac_address(sval);


I32
has_ip_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    RETVAL = THIS->has_ip_address();

  OUTPUT:
    RETVAL


void
clear_ip_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    THIS->clear_ip_address();


void
ip_address(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->ip_address().c_str(),
                              THIS->ip_address().length()));
      PUSHs(sv);
    }


void
set_ip_address(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_ip_address(sval);


I32
has_protocol(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    RETVAL = THIS->has_protocol();

  OUTPUT:
    RETVAL


void
clear_protocol(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    THIS->clear_protocol();


void
protocol(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->protocol().c_str(),
                              THIS->protocol().length()));
      PUSHs(sv);
    }


void
set_protocol(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_protocol(sval);


I32
port_size(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    RETVAL = THIS->port_size();

  OUTPUT:
    RETVAL


void
clear_port(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    THIS->clear_port();


void
port(svTHIS, ...)
  SV * svTHIS;
PREINIT:
    SV * sv;
    int index = 0;

  PPCODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
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
add_port(svTHIS, svVAL)
  SV * svTHIS
  UV svVAL

  CODE:
    ::HoneyClient::Message_Firewall_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall::Command");
    }
    THIS->add_port(svVAL);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Firewall
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Firewall::new (...)
  PREINIT:
    ::HoneyClient::Message_Firewall * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Firewall") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Firewall_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Firewall;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Firewall;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Firewall", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Firewall") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Firewall * other = INT2PTR(__HoneyClient__Message_Firewall *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Firewall * other = __HoneyClient__Message_Firewall_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Firewall") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Firewall * other = INT2PTR(__HoneyClient__Message_Firewall *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Firewall * other = __HoneyClient__Message_Firewall_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 0);


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Firewall * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Firewall") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Firewall *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Firewall");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Firewall * msg0 = THIS;

      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Pcap::Command
PROTOTYPES: ENABLE


BOOT:
  {
    HV * stash;

    stash = gv_stashpv("HoneyClient::Message::Pcap::Command::ActionType", TRUE);
    newCONSTSUB(stash, "UNKNOWN", newSViv(::HoneyClient::Message_Pcap_Command::UNKNOWN));
    newCONSTSUB(stash, "STOP_ALL", newSViv(::HoneyClient::Message_Pcap_Command::STOP_ALL));
    newCONSTSUB(stash, "STOP_VM", newSViv(::HoneyClient::Message_Pcap_Command::STOP_VM));
    newCONSTSUB(stash, "START_VM", newSViv(::HoneyClient::Message_Pcap_Command::START_VM));
    newCONSTSUB(stash, "GET_IP", newSViv(::HoneyClient::Message_Pcap_Command::GET_IP));
    newCONSTSUB(stash, "GET_FILE", newSViv(::HoneyClient::Message_Pcap_Command::GET_FILE));
    stash = gv_stashpv("HoneyClient::Message::Pcap::Command::ResponseType", TRUE);
    newCONSTSUB(stash, "ERROR", newSViv(::HoneyClient::Message_Pcap_Command::ERROR));
    newCONSTSUB(stash, "OK", newSViv(::HoneyClient::Message_Pcap_Command::OK));
  }


SV *
::HoneyClient::Message_Pcap_Command::new (...)
  PREINIT:
    ::HoneyClient::Message_Pcap_Command * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Pcap::Command") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Pcap_Command_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Pcap_Command;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Pcap_Command;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Pcap::Command", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Pcap::Command") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Pcap_Command * other = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Pcap_Command * other = __HoneyClient__Message_Pcap_Command_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Pcap::Command") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Pcap_Command * other = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Pcap_Command * other = __HoneyClient__Message_Pcap_Command_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 9);
    PUSHs(sv_2mortal(newSVpv("action",0)));
    PUSHs(sv_2mortal(newSVpv("response",0)));
    PUSHs(sv_2mortal(newSVpv("response_message",0)));
    PUSHs(sv_2mortal(newSVpv("err_message",0)));
    PUSHs(sv_2mortal(newSVpv("quick_clone_name",0)));
    PUSHs(sv_2mortal(newSVpv("mac_address",0)));
    PUSHs(sv_2mortal(newSVpv("src_ip_address",0)));
    PUSHs(sv_2mortal(newSVpv("dst_tcp_port",0)));
    PUSHs(sv_2mortal(newSVpv("delete_pcap",0)));


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Pcap_Command * msg0 = THIS;

      if ( msg0->has_action() ) {
        SV * sv0 = newSViv(msg0->action());
        hv_store(hv0, "action", sizeof("action") - 1, sv0, 0);
      }
      if ( msg0->has_response() ) {
        SV * sv0 = newSViv(msg0->response());
        hv_store(hv0, "response", sizeof("response") - 1, sv0, 0);
      }
      if ( msg0->has_response_message() ) {
        SV * sv0 = newSVpv(msg0->response_message().c_str(), msg0->response_message().length());
        hv_store(hv0, "response_message", sizeof("response_message") - 1, sv0, 0);
      }
      if ( msg0->has_err_message() ) {
        SV * sv0 = newSVpv(msg0->err_message().c_str(), msg0->err_message().length());
        hv_store(hv0, "err_message", sizeof("err_message") - 1, sv0, 0);
      }
      if ( msg0->has_quick_clone_name() ) {
        SV * sv0 = newSVpv(msg0->quick_clone_name().c_str(), msg0->quick_clone_name().length());
        hv_store(hv0, "quick_clone_name", sizeof("quick_clone_name") - 1, sv0, 0);
      }
      if ( msg0->has_mac_address() ) {
        SV * sv0 = newSVpv(msg0->mac_address().c_str(), msg0->mac_address().length());
        hv_store(hv0, "mac_address", sizeof("mac_address") - 1, sv0, 0);
      }
      if ( msg0->has_src_ip_address() ) {
        SV * sv0 = newSVpv(msg0->src_ip_address().c_str(), msg0->src_ip_address().length());
        hv_store(hv0, "src_ip_address", sizeof("src_ip_address") - 1, sv0, 0);
      }
      if ( msg0->has_dst_tcp_port() ) {
        SV * sv0 = newSVuv(msg0->dst_tcp_port());
        hv_store(hv0, "dst_tcp_port", sizeof("dst_tcp_port") - 1, sv0, 0);
      }
      if ( msg0->has_delete_pcap() ) {
        SV * sv0 = newSViv(msg0->delete_pcap());
        hv_store(hv0, "delete_pcap", sizeof("delete_pcap") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
has_action(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    RETVAL = THIS->has_action();

  OUTPUT:
    RETVAL


void
clear_action(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->clear_action();


void
action(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->action()));
      PUSHs(sv);
    }


void
set_action(svTHIS, svVAL)
  SV * svTHIS
  IV svVAL

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( ::HoneyClient::Message_Pcap_Command_ActionType_IsValid(svVAL) ) {
      THIS->set_action((::HoneyClient::Message_Pcap_Command_ActionType)svVAL);
    }


I32
has_response(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    RETVAL = THIS->has_response();

  OUTPUT:
    RETVAL


void
clear_response(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->clear_response();


void
response(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->response()));
      PUSHs(sv);
    }


void
set_response(svTHIS, svVAL)
  SV * svTHIS
  IV svVAL

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( ::HoneyClient::Message_Pcap_Command_ResponseType_IsValid(svVAL) ) {
      THIS->set_response((::HoneyClient::Message_Pcap_Command_ResponseType)svVAL);
    }


I32
has_response_message(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    RETVAL = THIS->has_response_message();

  OUTPUT:
    RETVAL


void
clear_response_message(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->clear_response_message();


void
response_message(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->response_message().c_str(),
                              THIS->response_message().length()));
      PUSHs(sv);
    }


void
set_response_message(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_response_message(sval);


I32
has_err_message(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    RETVAL = THIS->has_err_message();

  OUTPUT:
    RETVAL


void
clear_err_message(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->clear_err_message();


void
err_message(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->err_message().c_str(),
                              THIS->err_message().length()));
      PUSHs(sv);
    }


void
set_err_message(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_err_message(sval);


I32
has_quick_clone_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    RETVAL = THIS->has_quick_clone_name();

  OUTPUT:
    RETVAL


void
clear_quick_clone_name(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->clear_quick_clone_name();


void
quick_clone_name(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->quick_clone_name().c_str(),
                              THIS->quick_clone_name().length()));
      PUSHs(sv);
    }


void
set_quick_clone_name(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_quick_clone_name(sval);


I32
has_mac_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    RETVAL = THIS->has_mac_address();

  OUTPUT:
    RETVAL


void
clear_mac_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->clear_mac_address();


void
mac_address(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->mac_address().c_str(),
                              THIS->mac_address().length()));
      PUSHs(sv);
    }


void
set_mac_address(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_mac_address(sval);


I32
has_src_ip_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    RETVAL = THIS->has_src_ip_address();

  OUTPUT:
    RETVAL


void
clear_src_ip_address(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->clear_src_ip_address();


void
src_ip_address(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->src_ip_address().c_str(),
                              THIS->src_ip_address().length()));
      PUSHs(sv);
    }


void
set_src_ip_address(svTHIS, svVAL)
  SV * svTHIS
  SV *svVAL

  PREINIT:
    char * str;
    STRLEN len;
    string sval;

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    str = SvPV(svVAL, len);
    sval.assign(str, len);
    THIS->set_src_ip_address(sval);


I32
has_dst_tcp_port(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    RETVAL = THIS->has_dst_tcp_port();

  OUTPUT:
    RETVAL


void
clear_dst_tcp_port(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->clear_dst_tcp_port();


void
dst_tcp_port(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVuv(THIS->dst_tcp_port()));
      PUSHs(sv);
    }


void
set_dst_tcp_port(svTHIS, svVAL)
  SV * svTHIS
  UV svVAL

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->set_dst_tcp_port(svVAL);


I32
has_delete_pcap(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    RETVAL = THIS->has_delete_pcap();

  OUTPUT:
    RETVAL


void
clear_delete_pcap(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->clear_delete_pcap();


void
delete_pcap(svTHIS)
  SV * svTHIS;
PREINIT:
    SV * sv;

  PPCODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->delete_pcap()));
      PUSHs(sv);
    }


void
set_delete_pcap(svTHIS, svVAL)
  SV * svTHIS
  IV svVAL

  CODE:
    ::HoneyClient::Message_Pcap_Command * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap::Command") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap_Command *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap::Command");
    }
    THIS->set_delete_pcap(svVAL);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Pcap
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message_Pcap::new (...)
  PREINIT:
    ::HoneyClient::Message_Pcap * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Pcap") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_Pcap_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message_Pcap;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message_Pcap;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message::Pcap", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Pcap") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Pcap * other = INT2PTR(__HoneyClient__Message_Pcap *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Pcap * other = __HoneyClient__Message_Pcap_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Pcap") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Pcap * other = INT2PTR(__HoneyClient__Message_Pcap *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Pcap * other = __HoneyClient__Message_Pcap_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 0);


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message_Pcap * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message::Pcap") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message_Pcap *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message::Pcap");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Pcap * msg0 = THIS;

      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message
PROTOTYPES: ENABLE


SV *
::HoneyClient::Message::new (...)
  PREINIT:
    ::HoneyClient::Message * rv = NULL;

  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 && ST(1) != Nullsv ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        rv = __HoneyClient__Message_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        rv = new ::HoneyClient::Message;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          rv->ParseFromArray(str, len);
        }
      }
    } else {
      rv = new ::HoneyClient::Message;
    }
    RETVAL = newSV(0);
    sv_setref_pv(RETVAL, "HoneyClient::Message", (void *)rv);

  OUTPUT:
    RETVAL


void
DESTROY(svTHIS)
  SV * svTHIS;
  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      delete THIS;
    }


void
copy_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message * other = INT2PTR(__HoneyClient__Message *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message * other = __HoneyClient__Message_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
merge_from(svTHIS, sv)
  SV * svTHIS
  SV * sv
  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message * other = INT2PTR(__HoneyClient__Message *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message * other = __HoneyClient__Message_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
clear(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
is_initialized(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
error_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string estr;

  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      estr = THIS->InitializationErrorString();
    }
    RETVAL = newSVpv(estr.c_str(), estr.length());

  OUTPUT:
    RETVAL


void
discard_unkown_fields(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      dstr = THIS->DebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


SV *
short_debug_string(svTHIS)
  SV * svTHIS
  PREINIT:
    string dstr;

  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      dstr = THIS->ShortDebugString();
    }
    RETVAL = newSVpv(dstr.c_str(), dstr.length());

  OUTPUT:
    RETVAL


int
unpack(svTHIS, arg)
  SV * svTHIS
  SV * arg
  PREINIT:
    STRLEN len;
    char * str;

  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
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
pack(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      RETVAL = newSVpvn("", 0);
      message_OutputStream os(RETVAL);
      if ( THIS->SerializeToZeroCopyStream(&os) != true ) {
        SvREFCNT_dec(RETVAL);
        RETVAL = Nullsv;
      } else {
        os.Sync();
      }
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


int
length(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
fields(svTHIS)
  SV * svTHIS
  PPCODE:
    (void)svTHIS;
    EXTEND(SP, 0);


SV *
to_hashref(svTHIS)
  SV * svTHIS
  CODE:
    ::HoneyClient::Message * THIS;
    if ( sv_derived_from(svTHIS, "HoneyClient::Message") ) {
      IV tmp = SvIV((SV *)SvRV(svTHIS));
      THIS = INT2PTR(__HoneyClient__Message *, tmp);
    } else {
      croak("THIS is not of type HoneyClient::Message");
    }
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message * msg0 = THIS;

      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


