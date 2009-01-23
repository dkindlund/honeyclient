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
#include "message.pb.h"

using namespace std;

typedef ::HoneyClient::Message_Client __HoneyClient__Message_Client;
typedef ::HoneyClient::Message_File_Content __HoneyClient__Message_File_Content;
typedef ::HoneyClient::Message_File __HoneyClient__Message_File;
typedef ::HoneyClient::Message_Registry __HoneyClient__Message_Registry;
typedef ::HoneyClient::Message_Process __HoneyClient__Message_Process;
typedef ::HoneyClient::Message_Fingerprint __HoneyClient__Message_Fingerprint;
typedef ::HoneyClient::Message_Url __HoneyClient__Message_Url;
typedef ::HoneyClient::Message_Job __HoneyClient__Message_Job;
typedef ::HoneyClient::Message_Firewall_Command __HoneyClient__Message_Firewall_Command;
typedef ::HoneyClient::Message_Firewall __HoneyClient__Message_Firewall;
typedef ::HoneyClient::Message __HoneyClient__Message;


static ::HoneyClient::Message_Client *
__HoneyClient__Message_Client_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Client * msg0 = new ::HoneyClient::Message_Client;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "vm_name", sizeof("vm_name") - 1, 0)) != NULL ) {
      msg0->set_vm_name(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "snapshot_name", sizeof("snapshot_name") - 1, 0)) != NULL ) {
      msg0->set_snapshot_name(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "status", sizeof("status") - 1, 0)) != NULL ) {
      msg0->set_status(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "start_at", sizeof("start_at") - 1, 0)) != NULL ) {
      msg0->set_start_at(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "compromise_at", sizeof("compromise_at") - 1, 0)) != NULL ) {
      msg0->set_compromise_at(SvPV_nolen(*sv1));
    }
  }

  return msg0;
}

static ::HoneyClient::Message_File_Content *
__HoneyClient__Message_File_Content_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_File_Content * msg0 = new ::HoneyClient::Message_File_Content;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "size", sizeof("size") - 1, 0)) != NULL ) {
      uint64_t uv0 = strtoull(SvPV_nolen(*sv1), NULL, 0);
      
      msg0->set_size(uv0);
    }
    if ( (sv1 = hv_fetch(hv0, "md5", sizeof("md5") - 1, 0)) != NULL ) {
      msg0->set_md5(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
      msg0->set_sha1(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
      msg0->set_mime_type(SvPV_nolen(*sv1));
    }
  }

  return msg0;
}

static ::HoneyClient::Message_File *
__HoneyClient__Message_File_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_File * msg0 = new ::HoneyClient::Message_File;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
      msg0->set_time_at(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      msg0->set_name(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "event", sizeof("event") - 1, 0)) != NULL ) {
      msg0->set_event(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "content", sizeof("content") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_File_Content * msg2 = msg0->mutable_content();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "size", sizeof("size") - 1, 0)) != NULL ) {
          uint64_t uv2 = strtoull(SvPV_nolen(*sv3), NULL, 0);
          
          msg2->set_size(uv2);
        }
        if ( (sv3 = hv_fetch(hv2, "md5", sizeof("md5") - 1, 0)) != NULL ) {
          msg2->set_md5(SvPV_nolen(*sv3));
        }
        if ( (sv3 = hv_fetch(hv2, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
          msg2->set_sha1(SvPV_nolen(*sv3));
        }
        if ( (sv3 = hv_fetch(hv2, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
          msg2->set_mime_type(SvPV_nolen(*sv3));
        }
      }
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Registry *
__HoneyClient__Message_Registry_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Registry * msg0 = new ::HoneyClient::Message_Registry;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
      msg0->set_time_at(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      msg0->set_name(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "event", sizeof("event") - 1, 0)) != NULL ) {
      msg0->set_event(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "value", sizeof("value") - 1, 0)) != NULL ) {
      msg0->set_value(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "value_name", sizeof("value_name") - 1, 0)) != NULL ) {
      msg0->set_value_name(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "value_type", sizeof("value_type") - 1, 0)) != NULL ) {
      msg0->set_value_type(SvPV_nolen(*sv1));
    }
  }

  return msg0;
}

static ::HoneyClient::Message_Process *
__HoneyClient__Message_Process_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Process * msg0 = new ::HoneyClient::Message_Process;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      msg0->set_name(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "pid", sizeof("pid") - 1, 0)) != NULL ) {
      uint64_t uv0 = strtoull(SvPV_nolen(*sv1), NULL, 0);
      
      msg0->set_pid(uv0);
    }
    if ( (sv1 = hv_fetch(hv0, "file", sizeof("file") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          ::HoneyClient::Message_File * msg2 = msg0->add_file();
          SV ** sv1;
          SV *  sv2;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            sv2 = *sv1;
            if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
              HV *  hv2 = (HV *)SvRV(sv2);
              SV ** sv3;
              
              if ( (sv3 = hv_fetch(hv2, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                msg2->set_time_at(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
                msg2->set_name(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "event", sizeof("event") - 1, 0)) != NULL ) {
                msg2->set_event(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "content", sizeof("content") - 1, 0)) != NULL ) {
                ::HoneyClient::Message_File_Content * msg4 = msg2->mutable_content();
                SV * sv4 = *sv3;
                
                if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                  HV *  hv4 = (HV *)SvRV(sv4);
                  SV ** sv5;
                  
                  if ( (sv5 = hv_fetch(hv4, "size", sizeof("size") - 1, 0)) != NULL ) {
                    uint64_t uv4 = strtoull(SvPV_nolen(*sv5), NULL, 0);
                    
                    msg4->set_size(uv4);
                  }
                  if ( (sv5 = hv_fetch(hv4, "md5", sizeof("md5") - 1, 0)) != NULL ) {
                    msg4->set_md5(SvPV_nolen(*sv5));
                  }
                  if ( (sv5 = hv_fetch(hv4, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
                    msg4->set_sha1(SvPV_nolen(*sv5));
                  }
                  if ( (sv5 = hv_fetch(hv4, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
                    msg4->set_mime_type(SvPV_nolen(*sv5));
                  }
                }
              }
            }
          }
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "registry", sizeof("registry") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          ::HoneyClient::Message_Registry * msg2 = msg0->add_registry();
          SV ** sv1;
          SV *  sv2;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            sv2 = *sv1;
            if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
              HV *  hv2 = (HV *)SvRV(sv2);
              SV ** sv3;
              
              if ( (sv3 = hv_fetch(hv2, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                msg2->set_time_at(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
                msg2->set_name(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "event", sizeof("event") - 1, 0)) != NULL ) {
                msg2->set_event(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "value", sizeof("value") - 1, 0)) != NULL ) {
                msg2->set_value(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "value_name", sizeof("value_name") - 1, 0)) != NULL ) {
                msg2->set_value_name(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "value_type", sizeof("value_type") - 1, 0)) != NULL ) {
                msg2->set_value_type(SvPV_nolen(*sv3));
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
    
    if ( (sv1 = hv_fetch(hv0, "process", sizeof("process") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          ::HoneyClient::Message_Process * msg2 = msg0->add_process();
          SV ** sv1;
          SV *  sv2;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            sv2 = *sv1;
            if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
              HV *  hv2 = (HV *)SvRV(sv2);
              SV ** sv3;
              
              if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
                msg2->set_name(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "pid", sizeof("pid") - 1, 0)) != NULL ) {
                uint64_t uv2 = strtoull(SvPV_nolen(*sv3), NULL, 0);
                
                msg2->set_pid(uv2);
              }
              if ( (sv3 = hv_fetch(hv2, "file", sizeof("file") - 1, 0)) != NULL ) {
                if ( SvROK(*sv3) && SvTYPE(SvRV(*sv3)) == SVt_PVAV ) {
                  AV * av3 = (AV *)SvRV(*sv3);
                  
                  for ( int i3 = 0; i3 <= av_len(av3); i3++ ) {
                    ::HoneyClient::Message_File * msg4 = msg2->add_file();
                    SV ** sv3;
                    SV *  sv4;
                    
                    if ( (sv3 = av_fetch(av3, i3, 0)) != NULL ) {
                      sv4 = *sv3;
                      if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                        HV *  hv4 = (HV *)SvRV(sv4);
                        SV ** sv5;
                        
                        if ( (sv5 = hv_fetch(hv4, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                          msg4->set_time_at(SvPV_nolen(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "name", sizeof("name") - 1, 0)) != NULL ) {
                          msg4->set_name(SvPV_nolen(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "event", sizeof("event") - 1, 0)) != NULL ) {
                          msg4->set_event(SvPV_nolen(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "content", sizeof("content") - 1, 0)) != NULL ) {
                          ::HoneyClient::Message_File_Content * msg6 = msg4->mutable_content();
                          SV * sv6 = *sv5;
                          
                          if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                            HV *  hv6 = (HV *)SvRV(sv6);
                            SV ** sv7;
                            
                            if ( (sv7 = hv_fetch(hv6, "size", sizeof("size") - 1, 0)) != NULL ) {
                              uint64_t uv6 = strtoull(SvPV_nolen(*sv7), NULL, 0);
                              
                              msg6->set_size(uv6);
                            }
                            if ( (sv7 = hv_fetch(hv6, "md5", sizeof("md5") - 1, 0)) != NULL ) {
                              msg6->set_md5(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
                              msg6->set_sha1(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
                              msg6->set_mime_type(SvPV_nolen(*sv7));
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              if ( (sv3 = hv_fetch(hv2, "registry", sizeof("registry") - 1, 0)) != NULL ) {
                if ( SvROK(*sv3) && SvTYPE(SvRV(*sv3)) == SVt_PVAV ) {
                  AV * av3 = (AV *)SvRV(*sv3);
                  
                  for ( int i3 = 0; i3 <= av_len(av3); i3++ ) {
                    ::HoneyClient::Message_Registry * msg4 = msg2->add_registry();
                    SV ** sv3;
                    SV *  sv4;
                    
                    if ( (sv3 = av_fetch(av3, i3, 0)) != NULL ) {
                      sv4 = *sv3;
                      if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                        HV *  hv4 = (HV *)SvRV(sv4);
                        SV ** sv5;
                        
                        if ( (sv5 = hv_fetch(hv4, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                          msg4->set_time_at(SvPV_nolen(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "name", sizeof("name") - 1, 0)) != NULL ) {
                          msg4->set_name(SvPV_nolen(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "event", sizeof("event") - 1, 0)) != NULL ) {
                          msg4->set_event(SvPV_nolen(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "value", sizeof("value") - 1, 0)) != NULL ) {
                          msg4->set_value(SvPV_nolen(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "value_name", sizeof("value_name") - 1, 0)) != NULL ) {
                          msg4->set_value_name(SvPV_nolen(*sv5));
                        }
                        if ( (sv5 = hv_fetch(hv4, "value_type", sizeof("value_type") - 1, 0)) != NULL ) {
                          msg4->set_value_type(SvPV_nolen(*sv5));
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

static ::HoneyClient::Message_Url *
__HoneyClient__Message_Url_from_hashref ( SV * sv0 )
{
  ::HoneyClient::Message_Url * msg0 = new ::HoneyClient::Message_Url;

  if ( SvROK(sv0) && SvTYPE(SvRV(sv0)) == SVt_PVHV ) {
    HV *  hv0 = (HV *)SvRV(sv0);
    SV ** sv1;
    
    if ( (sv1 = hv_fetch(hv0, "name", sizeof("name") - 1, 0)) != NULL ) {
      msg0->set_name(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "status", sizeof("status") - 1, 0)) != NULL ) {
      msg0->set_status((HoneyClient::Message::Url::Status)SvIV(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "client", sizeof("client") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_Client * msg2 = msg0->mutable_client();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "vm_name", sizeof("vm_name") - 1, 0)) != NULL ) {
          msg2->set_vm_name(SvPV_nolen(*sv3));
        }
        if ( (sv3 = hv_fetch(hv2, "snapshot_name", sizeof("snapshot_name") - 1, 0)) != NULL ) {
          msg2->set_snapshot_name(SvPV_nolen(*sv3));
        }
        if ( (sv3 = hv_fetch(hv2, "status", sizeof("status") - 1, 0)) != NULL ) {
          msg2->set_status(SvPV_nolen(*sv3));
        }
        if ( (sv3 = hv_fetch(hv2, "start_at", sizeof("start_at") - 1, 0)) != NULL ) {
          msg2->set_start_at(SvPV_nolen(*sv3));
        }
        if ( (sv3 = hv_fetch(hv2, "compromise_at", sizeof("compromise_at") - 1, 0)) != NULL ) {
          msg2->set_compromise_at(SvPV_nolen(*sv3));
        }
      }
    }
    if ( (sv1 = hv_fetch(hv0, "fingerprint", sizeof("fingerprint") - 1, 0)) != NULL ) {
      ::HoneyClient::Message_Fingerprint * msg2 = msg0->mutable_fingerprint();
      SV * sv2 = *sv1;
      
      if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
        HV *  hv2 = (HV *)SvRV(sv2);
        SV ** sv3;
        
        if ( (sv3 = hv_fetch(hv2, "process", sizeof("process") - 1, 0)) != NULL ) {
          if ( SvROK(*sv3) && SvTYPE(SvRV(*sv3)) == SVt_PVAV ) {
            AV * av3 = (AV *)SvRV(*sv3);
            
            for ( int i3 = 0; i3 <= av_len(av3); i3++ ) {
              ::HoneyClient::Message_Process * msg4 = msg2->add_process();
              SV ** sv3;
              SV *  sv4;
              
              if ( (sv3 = av_fetch(av3, i3, 0)) != NULL ) {
                sv4 = *sv3;
                if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                  HV *  hv4 = (HV *)SvRV(sv4);
                  SV ** sv5;
                  
                  if ( (sv5 = hv_fetch(hv4, "name", sizeof("name") - 1, 0)) != NULL ) {
                    msg4->set_name(SvPV_nolen(*sv5));
                  }
                  if ( (sv5 = hv_fetch(hv4, "pid", sizeof("pid") - 1, 0)) != NULL ) {
                    uint64_t uv4 = strtoull(SvPV_nolen(*sv5), NULL, 0);
                    
                    msg4->set_pid(uv4);
                  }
                  if ( (sv5 = hv_fetch(hv4, "file", sizeof("file") - 1, 0)) != NULL ) {
                    if ( SvROK(*sv5) && SvTYPE(SvRV(*sv5)) == SVt_PVAV ) {
                      AV * av5 = (AV *)SvRV(*sv5);
                      
                      for ( int i5 = 0; i5 <= av_len(av5); i5++ ) {
                        ::HoneyClient::Message_File * msg6 = msg4->add_file();
                        SV ** sv5;
                        SV *  sv6;
                        
                        if ( (sv5 = av_fetch(av5, i5, 0)) != NULL ) {
                          sv6 = *sv5;
                          if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                            HV *  hv6 = (HV *)SvRV(sv6);
                            SV ** sv7;
                            
                            if ( (sv7 = hv_fetch(hv6, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                              msg6->set_time_at(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "name", sizeof("name") - 1, 0)) != NULL ) {
                              msg6->set_name(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "event", sizeof("event") - 1, 0)) != NULL ) {
                              msg6->set_event(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "content", sizeof("content") - 1, 0)) != NULL ) {
                              ::HoneyClient::Message_File_Content * msg8 = msg6->mutable_content();
                              SV * sv8 = *sv7;
                              
                              if ( SvROK(sv8) && SvTYPE(SvRV(sv8)) == SVt_PVHV ) {
                                HV *  hv8 = (HV *)SvRV(sv8);
                                SV ** sv9;
                                
                                if ( (sv9 = hv_fetch(hv8, "size", sizeof("size") - 1, 0)) != NULL ) {
                                  uint64_t uv8 = strtoull(SvPV_nolen(*sv9), NULL, 0);
                                  
                                  msg8->set_size(uv8);
                                }
                                if ( (sv9 = hv_fetch(hv8, "md5", sizeof("md5") - 1, 0)) != NULL ) {
                                  msg8->set_md5(SvPV_nolen(*sv9));
                                }
                                if ( (sv9 = hv_fetch(hv8, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
                                  msg8->set_sha1(SvPV_nolen(*sv9));
                                }
                                if ( (sv9 = hv_fetch(hv8, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
                                  msg8->set_mime_type(SvPV_nolen(*sv9));
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                  if ( (sv5 = hv_fetch(hv4, "registry", sizeof("registry") - 1, 0)) != NULL ) {
                    if ( SvROK(*sv5) && SvTYPE(SvRV(*sv5)) == SVt_PVAV ) {
                      AV * av5 = (AV *)SvRV(*sv5);
                      
                      for ( int i5 = 0; i5 <= av_len(av5); i5++ ) {
                        ::HoneyClient::Message_Registry * msg6 = msg4->add_registry();
                        SV ** sv5;
                        SV *  sv6;
                        
                        if ( (sv5 = av_fetch(av5, i5, 0)) != NULL ) {
                          sv6 = *sv5;
                          if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                            HV *  hv6 = (HV *)SvRV(sv6);
                            SV ** sv7;
                            
                            if ( (sv7 = hv_fetch(hv6, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                              msg6->set_time_at(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "name", sizeof("name") - 1, 0)) != NULL ) {
                              msg6->set_name(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "event", sizeof("event") - 1, 0)) != NULL ) {
                              msg6->set_event(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "value", sizeof("value") - 1, 0)) != NULL ) {
                              msg6->set_value(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "value_name", sizeof("value_name") - 1, 0)) != NULL ) {
                              msg6->set_value_name(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "value_type", sizeof("value_type") - 1, 0)) != NULL ) {
                              msg6->set_value_type(SvPV_nolen(*sv7));
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
      msg0->set_uuid(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "created_at", sizeof("created_at") - 1, 0)) != NULL ) {
      msg0->set_created_at(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "completed_at", sizeof("completed_at") - 1, 0)) != NULL ) {
      msg0->set_completed_at(SvPV_nolen(*sv1));
    }
    if ( (sv1 = hv_fetch(hv0, "total_num_urls", sizeof("total_num_urls") - 1, 0)) != NULL ) {
      uint64_t uv0 = strtoull(SvPV_nolen(*sv1), NULL, 0);
      
      msg0->set_total_num_urls(uv0);
    }
    if ( (sv1 = hv_fetch(hv0, "url", sizeof("url") - 1, 0)) != NULL ) {
      if ( SvROK(*sv1) && SvTYPE(SvRV(*sv1)) == SVt_PVAV ) {
        AV * av1 = (AV *)SvRV(*sv1);
        
        for ( int i1 = 0; i1 <= av_len(av1); i1++ ) {
          ::HoneyClient::Message_Url * msg2 = msg0->add_url();
          SV ** sv1;
          SV *  sv2;
          
          if ( (sv1 = av_fetch(av1, i1, 0)) != NULL ) {
            sv2 = *sv1;
            if ( SvROK(sv2) && SvTYPE(SvRV(sv2)) == SVt_PVHV ) {
              HV *  hv2 = (HV *)SvRV(sv2);
              SV ** sv3;
              
              if ( (sv3 = hv_fetch(hv2, "name", sizeof("name") - 1, 0)) != NULL ) {
                msg2->set_name(SvPV_nolen(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "status", sizeof("status") - 1, 0)) != NULL ) {
                msg2->set_status((HoneyClient::Message::Url::Status)SvIV(*sv3));
              }
              if ( (sv3 = hv_fetch(hv2, "client", sizeof("client") - 1, 0)) != NULL ) {
                ::HoneyClient::Message_Client * msg4 = msg2->mutable_client();
                SV * sv4 = *sv3;
                
                if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                  HV *  hv4 = (HV *)SvRV(sv4);
                  SV ** sv5;
                  
                  if ( (sv5 = hv_fetch(hv4, "vm_name", sizeof("vm_name") - 1, 0)) != NULL ) {
                    msg4->set_vm_name(SvPV_nolen(*sv5));
                  }
                  if ( (sv5 = hv_fetch(hv4, "snapshot_name", sizeof("snapshot_name") - 1, 0)) != NULL ) {
                    msg4->set_snapshot_name(SvPV_nolen(*sv5));
                  }
                  if ( (sv5 = hv_fetch(hv4, "status", sizeof("status") - 1, 0)) != NULL ) {
                    msg4->set_status(SvPV_nolen(*sv5));
                  }
                  if ( (sv5 = hv_fetch(hv4, "start_at", sizeof("start_at") - 1, 0)) != NULL ) {
                    msg4->set_start_at(SvPV_nolen(*sv5));
                  }
                  if ( (sv5 = hv_fetch(hv4, "compromise_at", sizeof("compromise_at") - 1, 0)) != NULL ) {
                    msg4->set_compromise_at(SvPV_nolen(*sv5));
                  }
                }
              }
              if ( (sv3 = hv_fetch(hv2, "fingerprint", sizeof("fingerprint") - 1, 0)) != NULL ) {
                ::HoneyClient::Message_Fingerprint * msg4 = msg2->mutable_fingerprint();
                SV * sv4 = *sv3;
                
                if ( SvROK(sv4) && SvTYPE(SvRV(sv4)) == SVt_PVHV ) {
                  HV *  hv4 = (HV *)SvRV(sv4);
                  SV ** sv5;
                  
                  if ( (sv5 = hv_fetch(hv4, "process", sizeof("process") - 1, 0)) != NULL ) {
                    if ( SvROK(*sv5) && SvTYPE(SvRV(*sv5)) == SVt_PVAV ) {
                      AV * av5 = (AV *)SvRV(*sv5);
                      
                      for ( int i5 = 0; i5 <= av_len(av5); i5++ ) {
                        ::HoneyClient::Message_Process * msg6 = msg4->add_process();
                        SV ** sv5;
                        SV *  sv6;
                        
                        if ( (sv5 = av_fetch(av5, i5, 0)) != NULL ) {
                          sv6 = *sv5;
                          if ( SvROK(sv6) && SvTYPE(SvRV(sv6)) == SVt_PVHV ) {
                            HV *  hv6 = (HV *)SvRV(sv6);
                            SV ** sv7;
                            
                            if ( (sv7 = hv_fetch(hv6, "name", sizeof("name") - 1, 0)) != NULL ) {
                              msg6->set_name(SvPV_nolen(*sv7));
                            }
                            if ( (sv7 = hv_fetch(hv6, "pid", sizeof("pid") - 1, 0)) != NULL ) {
                              uint64_t uv6 = strtoull(SvPV_nolen(*sv7), NULL, 0);
                              
                              msg6->set_pid(uv6);
                            }
                            if ( (sv7 = hv_fetch(hv6, "file", sizeof("file") - 1, 0)) != NULL ) {
                              if ( SvROK(*sv7) && SvTYPE(SvRV(*sv7)) == SVt_PVAV ) {
                                AV * av7 = (AV *)SvRV(*sv7);
                                
                                for ( int i7 = 0; i7 <= av_len(av7); i7++ ) {
                                  ::HoneyClient::Message_File * msg8 = msg6->add_file();
                                  SV ** sv7;
                                  SV *  sv8;
                                  
                                  if ( (sv7 = av_fetch(av7, i7, 0)) != NULL ) {
                                    sv8 = *sv7;
                                    if ( SvROK(sv8) && SvTYPE(SvRV(sv8)) == SVt_PVHV ) {
                                      HV *  hv8 = (HV *)SvRV(sv8);
                                      SV ** sv9;
                                      
                                      if ( (sv9 = hv_fetch(hv8, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                                        msg8->set_time_at(SvPV_nolen(*sv9));
                                      }
                                      if ( (sv9 = hv_fetch(hv8, "name", sizeof("name") - 1, 0)) != NULL ) {
                                        msg8->set_name(SvPV_nolen(*sv9));
                                      }
                                      if ( (sv9 = hv_fetch(hv8, "event", sizeof("event") - 1, 0)) != NULL ) {
                                        msg8->set_event(SvPV_nolen(*sv9));
                                      }
                                      if ( (sv9 = hv_fetch(hv8, "content", sizeof("content") - 1, 0)) != NULL ) {
                                        ::HoneyClient::Message_File_Content * msg10 = msg8->mutable_content();
                                        SV * sv10 = *sv9;
                                        
                                        if ( SvROK(sv10) && SvTYPE(SvRV(sv10)) == SVt_PVHV ) {
                                          HV *  hv10 = (HV *)SvRV(sv10);
                                          SV ** sv11;
                                          
                                          if ( (sv11 = hv_fetch(hv10, "size", sizeof("size") - 1, 0)) != NULL ) {
                                            uint64_t uv10 = strtoull(SvPV_nolen(*sv11), NULL, 0);
                                            
                                            msg10->set_size(uv10);
                                          }
                                          if ( (sv11 = hv_fetch(hv10, "md5", sizeof("md5") - 1, 0)) != NULL ) {
                                            msg10->set_md5(SvPV_nolen(*sv11));
                                          }
                                          if ( (sv11 = hv_fetch(hv10, "sha1", sizeof("sha1") - 1, 0)) != NULL ) {
                                            msg10->set_sha1(SvPV_nolen(*sv11));
                                          }
                                          if ( (sv11 = hv_fetch(hv10, "mime_type", sizeof("mime_type") - 1, 0)) != NULL ) {
                                            msg10->set_mime_type(SvPV_nolen(*sv11));
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                            if ( (sv7 = hv_fetch(hv6, "registry", sizeof("registry") - 1, 0)) != NULL ) {
                              if ( SvROK(*sv7) && SvTYPE(SvRV(*sv7)) == SVt_PVAV ) {
                                AV * av7 = (AV *)SvRV(*sv7);
                                
                                for ( int i7 = 0; i7 <= av_len(av7); i7++ ) {
                                  ::HoneyClient::Message_Registry * msg8 = msg6->add_registry();
                                  SV ** sv7;
                                  SV *  sv8;
                                  
                                  if ( (sv7 = av_fetch(av7, i7, 0)) != NULL ) {
                                    sv8 = *sv7;
                                    if ( SvROK(sv8) && SvTYPE(SvRV(sv8)) == SVt_PVHV ) {
                                      HV *  hv8 = (HV *)SvRV(sv8);
                                      SV ** sv9;
                                      
                                      if ( (sv9 = hv_fetch(hv8, "time_at", sizeof("time_at") - 1, 0)) != NULL ) {
                                        msg8->set_time_at(SvPV_nolen(*sv9));
                                      }
                                      if ( (sv9 = hv_fetch(hv8, "name", sizeof("name") - 1, 0)) != NULL ) {
                                        msg8->set_name(SvPV_nolen(*sv9));
                                      }
                                      if ( (sv9 = hv_fetch(hv8, "event", sizeof("event") - 1, 0)) != NULL ) {
                                        msg8->set_event(SvPV_nolen(*sv9));
                                      }
                                      if ( (sv9 = hv_fetch(hv8, "value", sizeof("value") - 1, 0)) != NULL ) {
                                        msg8->set_value(SvPV_nolen(*sv9));
                                      }
                                      if ( (sv9 = hv_fetch(hv8, "value_name", sizeof("value_name") - 1, 0)) != NULL ) {
                                        msg8->set_value_name(SvPV_nolen(*sv9));
                                      }
                                      if ( (sv9 = hv_fetch(hv8, "value_type", sizeof("value_type") - 1, 0)) != NULL ) {
                                        msg8->set_value_type(SvPV_nolen(*sv9));
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



MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Client
PROTOTYPES: ENABLE


::HoneyClient::Message_Client *
::HoneyClient::Message_Client::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Client") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_Client_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_Client;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_Client;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Client::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_Client::copy_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Client::merge_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Client::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_Client::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_Client::error_string()
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
::HoneyClient::Message_Client::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_Client::debug_string()
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
::HoneyClient::Message_Client::short_debug_string()
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
::HoneyClient::Message_Client::unpack(arg)
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
::HoneyClient::Message_Client::pack()
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
::HoneyClient::Message_Client::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Client::fields()
  PPCODE:
    EXTEND(SP, 5);
    PUSHs(sv_2mortal(newSVpv("vm_name",0)));
    PUSHs(sv_2mortal(newSVpv("snapshot_name",0)));
    PUSHs(sv_2mortal(newSVpv("status",0)));
    PUSHs(sv_2mortal(newSVpv("start_at",0)));
    PUSHs(sv_2mortal(newSVpv("compromise_at",0)));


SV *
::HoneyClient::Message_Client::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Client * msg0 = THIS;

      if ( msg0->has_vm_name() ) {
        SV * sv0 = newSVpv(msg0->vm_name().c_str(), msg0->vm_name().length());
        hv_store(hv0, "vm_name", sizeof("vm_name") - 1, sv0, 0);
      }
      if ( msg0->has_snapshot_name() ) {
        SV * sv0 = newSVpv(msg0->snapshot_name().c_str(), msg0->snapshot_name().length());
        hv_store(hv0, "snapshot_name", sizeof("snapshot_name") - 1, sv0, 0);
      }
      if ( msg0->has_status() ) {
        SV * sv0 = newSVpv(msg0->status().c_str(), msg0->status().length());
        hv_store(hv0, "status", sizeof("status") - 1, sv0, 0);
      }
      if ( msg0->has_start_at() ) {
        SV * sv0 = newSVpv(msg0->start_at().c_str(), msg0->start_at().length());
        hv_store(hv0, "start_at", sizeof("start_at") - 1, sv0, 0);
      }
      if ( msg0->has_compromise_at() ) {
        SV * sv0 = newSVpv(msg0->compromise_at().c_str(), msg0->compromise_at().length());
        hv_store(hv0, "compromise_at", sizeof("compromise_at") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
::HoneyClient::Message_Client::has_vm_name()
  CODE:
    RETVAL = THIS->has_vm_name();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Client::clear_vm_name()
  CODE:
    THIS->clear_vm_name();


void
::HoneyClient::Message_Client::vm_name()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->vm_name().c_str(),
                              THIS->vm_name().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Client::set_vm_name(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_vm_name(sval);


I32
::HoneyClient::Message_Client::has_snapshot_name()
  CODE:
    RETVAL = THIS->has_snapshot_name();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Client::clear_snapshot_name()
  CODE:
    THIS->clear_snapshot_name();


void
::HoneyClient::Message_Client::snapshot_name()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->snapshot_name().c_str(),
                              THIS->snapshot_name().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Client::set_snapshot_name(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_snapshot_name(sval);


I32
::HoneyClient::Message_Client::has_status()
  CODE:
    RETVAL = THIS->has_status();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Client::clear_status()
  CODE:
    THIS->clear_status();


void
::HoneyClient::Message_Client::status()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->status().c_str(),
                              THIS->status().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Client::set_status(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_status(sval);


I32
::HoneyClient::Message_Client::has_start_at()
  CODE:
    RETVAL = THIS->has_start_at();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Client::clear_start_at()
  CODE:
    THIS->clear_start_at();


void
::HoneyClient::Message_Client::start_at()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->start_at().c_str(),
                              THIS->start_at().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Client::set_start_at(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_start_at(sval);


I32
::HoneyClient::Message_Client::has_compromise_at()
  CODE:
    RETVAL = THIS->has_compromise_at();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Client::clear_compromise_at()
  CODE:
    THIS->clear_compromise_at();


void
::HoneyClient::Message_Client::compromise_at()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->compromise_at().c_str(),
                              THIS->compromise_at().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Client::set_compromise_at(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_compromise_at(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::File::Content
PROTOTYPES: ENABLE


::HoneyClient::Message_File_Content *
::HoneyClient::Message_File_Content::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::File::Content") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_File_Content_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_File_Content;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_File_Content;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File_Content::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_File_Content::copy_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::File::Content") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_File_Content * other = INT2PTR(__HoneyClient__Message_File_Content *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_File_Content * other = __HoneyClient__Message_File_Content_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message_File_Content::merge_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::File::Content") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_File_Content * other = INT2PTR(__HoneyClient__Message_File_Content *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_File_Content * other = __HoneyClient__Message_File_Content_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message_File_Content::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_File_Content::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_File_Content::error_string()
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
::HoneyClient::Message_File_Content::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_File_Content::debug_string()
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
::HoneyClient::Message_File_Content::short_debug_string()
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
::HoneyClient::Message_File_Content::unpack(arg)
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
::HoneyClient::Message_File_Content::pack()
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
::HoneyClient::Message_File_Content::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File_Content::fields()
  PPCODE:
    EXTEND(SP, 4);
    PUSHs(sv_2mortal(newSVpv("size",0)));
    PUSHs(sv_2mortal(newSVpv("md5",0)));
    PUSHs(sv_2mortal(newSVpv("sha1",0)));
    PUSHs(sv_2mortal(newSVpv("mime_type",0)));


SV *
::HoneyClient::Message_File_Content::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_File_Content * msg0 = THIS;

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
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
::HoneyClient::Message_File_Content::has_size()
  CODE:
    RETVAL = THIS->has_size();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File_Content::clear_size()
  CODE:
    THIS->clear_size();


void
::HoneyClient::Message_File_Content::size()
  PREINIT:
    SV * sv;
    ostringstream ost;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      ost.str("");
      ost << THIS->size();
      sv = sv_2mortal(newSVpv(ost.str().c_str(),
                              ost.str().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_File_Content::set_size(val)
  char *val

  PREINIT:
    unsigned long long lval;

  CODE:
    lval = strtoull((val) ? val : "", NULL, 0);
    THIS->set_size(lval);


I32
::HoneyClient::Message_File_Content::has_md5()
  CODE:
    RETVAL = THIS->has_md5();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File_Content::clear_md5()
  CODE:
    THIS->clear_md5();


void
::HoneyClient::Message_File_Content::md5()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->md5().c_str(),
                              THIS->md5().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_File_Content::set_md5(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_md5(sval);


I32
::HoneyClient::Message_File_Content::has_sha1()
  CODE:
    RETVAL = THIS->has_sha1();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File_Content::clear_sha1()
  CODE:
    THIS->clear_sha1();


void
::HoneyClient::Message_File_Content::sha1()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->sha1().c_str(),
                              THIS->sha1().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_File_Content::set_sha1(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_sha1(sval);


I32
::HoneyClient::Message_File_Content::has_mime_type()
  CODE:
    RETVAL = THIS->has_mime_type();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File_Content::clear_mime_type()
  CODE:
    THIS->clear_mime_type();


void
::HoneyClient::Message_File_Content::mime_type()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->mime_type().c_str(),
                              THIS->mime_type().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_File_Content::set_mime_type(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_mime_type(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::File
PROTOTYPES: ENABLE


::HoneyClient::Message_File *
::HoneyClient::Message_File::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::File") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_File_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_File;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_File;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_File::copy_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::File") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_File * other = INT2PTR(__HoneyClient__Message_File *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_File * other = __HoneyClient__Message_File_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message_File::merge_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::File") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_File * other = INT2PTR(__HoneyClient__Message_File *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_File * other = __HoneyClient__Message_File_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message_File::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_File::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_File::error_string()
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
::HoneyClient::Message_File::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_File::debug_string()
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
::HoneyClient::Message_File::short_debug_string()
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
::HoneyClient::Message_File::unpack(arg)
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
::HoneyClient::Message_File::pack()
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
::HoneyClient::Message_File::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File::fields()
  PPCODE:
    EXTEND(SP, 4);
    PUSHs(sv_2mortal(newSVpv("time_at",0)));
    PUSHs(sv_2mortal(newSVpv("name",0)));
    PUSHs(sv_2mortal(newSVpv("event",0)));
    PUSHs(sv_2mortal(newSVpv("content",0)));


SV *
::HoneyClient::Message_File::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_File * msg0 = THIS;

      if ( msg0->has_time_at() ) {
        SV * sv0 = newSVpv(msg0->time_at().c_str(), msg0->time_at().length());
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
      if ( msg0->has_content() ) {
        ::HoneyClient::Message_File_Content * msg2 = msg0->mutable_content();
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
        hv_store(hv0, "content", sizeof("content") - 1, sv1, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
::HoneyClient::Message_File::has_time_at()
  CODE:
    RETVAL = THIS->has_time_at();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File::clear_time_at()
  CODE:
    THIS->clear_time_at();


void
::HoneyClient::Message_File::time_at()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->time_at().c_str(),
                              THIS->time_at().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_File::set_time_at(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_time_at(sval);


I32
::HoneyClient::Message_File::has_name()
  CODE:
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File::clear_name()
  CODE:
    THIS->clear_name();


void
::HoneyClient::Message_File::name()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_File::set_name(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_name(sval);


I32
::HoneyClient::Message_File::has_event()
  CODE:
    RETVAL = THIS->has_event();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File::clear_event()
  CODE:
    THIS->clear_event();


void
::HoneyClient::Message_File::event()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->event().c_str(),
                              THIS->event().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_File::set_event(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_event(sval);


I32
::HoneyClient::Message_File::has_content()
  CODE:
    RETVAL = THIS->has_content();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_File::clear_content()
  CODE:
    THIS->clear_content();


void
::HoneyClient::Message_File::content()
  PREINIT:
    SV * sv;
    ::HoneyClient::Message_File_Content * val = NULL;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_File_Content;
      val->CopyFrom(THIS->content());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::File::Content", (void *)val);
      PUSHs(sv);
    }


void
::HoneyClient::Message_File::set_content(val)
  ::HoneyClient::Message_File_Content * val

  PREINIT:
    ::HoneyClient::Message_File_Content * mval;

  CODE:
    if ( val != NULL ) {
      mval = THIS->mutable_content();
      mval->CopyFrom(*val);
    }


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Registry
PROTOTYPES: ENABLE


::HoneyClient::Message_Registry *
::HoneyClient::Message_Registry::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Registry") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_Registry_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_Registry;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_Registry;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Registry::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_Registry::copy_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Registry") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Registry * other = INT2PTR(__HoneyClient__Message_Registry *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Registry * other = __HoneyClient__Message_Registry_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message_Registry::merge_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Registry") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Registry * other = INT2PTR(__HoneyClient__Message_Registry *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Registry * other = __HoneyClient__Message_Registry_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message_Registry::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_Registry::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_Registry::error_string()
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
::HoneyClient::Message_Registry::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_Registry::debug_string()
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
::HoneyClient::Message_Registry::short_debug_string()
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
::HoneyClient::Message_Registry::unpack(arg)
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
::HoneyClient::Message_Registry::pack()
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
::HoneyClient::Message_Registry::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Registry::fields()
  PPCODE:
    EXTEND(SP, 6);
    PUSHs(sv_2mortal(newSVpv("time_at",0)));
    PUSHs(sv_2mortal(newSVpv("name",0)));
    PUSHs(sv_2mortal(newSVpv("event",0)));
    PUSHs(sv_2mortal(newSVpv("value",0)));
    PUSHs(sv_2mortal(newSVpv("value_name",0)));
    PUSHs(sv_2mortal(newSVpv("value_type",0)));


SV *
::HoneyClient::Message_Registry::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Registry * msg0 = THIS;

      if ( msg0->has_time_at() ) {
        SV * sv0 = newSVpv(msg0->time_at().c_str(), msg0->time_at().length());
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
      if ( msg0->has_value() ) {
        SV * sv0 = newSVpv(msg0->value().c_str(), msg0->value().length());
        hv_store(hv0, "value", sizeof("value") - 1, sv0, 0);
      }
      if ( msg0->has_value_name() ) {
        SV * sv0 = newSVpv(msg0->value_name().c_str(), msg0->value_name().length());
        hv_store(hv0, "value_name", sizeof("value_name") - 1, sv0, 0);
      }
      if ( msg0->has_value_type() ) {
        SV * sv0 = newSVpv(msg0->value_type().c_str(), msg0->value_type().length());
        hv_store(hv0, "value_type", sizeof("value_type") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
::HoneyClient::Message_Registry::has_time_at()
  CODE:
    RETVAL = THIS->has_time_at();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Registry::clear_time_at()
  CODE:
    THIS->clear_time_at();


void
::HoneyClient::Message_Registry::time_at()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->time_at().c_str(),
                              THIS->time_at().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Registry::set_time_at(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_time_at(sval);


I32
::HoneyClient::Message_Registry::has_name()
  CODE:
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Registry::clear_name()
  CODE:
    THIS->clear_name();


void
::HoneyClient::Message_Registry::name()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Registry::set_name(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_name(sval);


I32
::HoneyClient::Message_Registry::has_event()
  CODE:
    RETVAL = THIS->has_event();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Registry::clear_event()
  CODE:
    THIS->clear_event();


void
::HoneyClient::Message_Registry::event()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->event().c_str(),
                              THIS->event().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Registry::set_event(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_event(sval);


I32
::HoneyClient::Message_Registry::has_value()
  CODE:
    RETVAL = THIS->has_value();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Registry::clear_value()
  CODE:
    THIS->clear_value();


void
::HoneyClient::Message_Registry::value()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->value().c_str(),
                              THIS->value().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Registry::set_value(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_value(sval);


I32
::HoneyClient::Message_Registry::has_value_name()
  CODE:
    RETVAL = THIS->has_value_name();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Registry::clear_value_name()
  CODE:
    THIS->clear_value_name();


void
::HoneyClient::Message_Registry::value_name()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->value_name().c_str(),
                              THIS->value_name().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Registry::set_value_name(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_value_name(sval);


I32
::HoneyClient::Message_Registry::has_value_type()
  CODE:
    RETVAL = THIS->has_value_type();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Registry::clear_value_type()
  CODE:
    THIS->clear_value_type();


void
::HoneyClient::Message_Registry::value_type()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->value_type().c_str(),
                              THIS->value_type().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Registry::set_value_type(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_value_type(sval);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Process
PROTOTYPES: ENABLE


::HoneyClient::Message_Process *
::HoneyClient::Message_Process::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Process") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_Process_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_Process;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_Process;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Process::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_Process::copy_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Process") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Process * other = INT2PTR(__HoneyClient__Message_Process *, tmp);

        THIS->CopyFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Process * other = __HoneyClient__Message_Process_from_hashref(sv);
        THIS->CopyFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message_Process::merge_from(sv)
  SV * sv
  CODE:
    if ( THIS != NULL && sv != NULL ) {
      if ( sv_derived_from(sv, "HoneyClient::Message::Process") ) {
        IV tmp = SvIV((SV *)SvRV(sv));
        ::HoneyClient::Message_Process * other = INT2PTR(__HoneyClient__Message_Process *, tmp);

        THIS->MergeFrom(*other);
      } else if ( SvROK(sv) &&
                  SvTYPE(SvRV(sv)) == SVt_PVHV ) {
        ::HoneyClient::Message_Process * other = __HoneyClient__Message_Process_from_hashref(sv);
        THIS->MergeFrom(*other);
        delete other;
      }
    }


void
::HoneyClient::Message_Process::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_Process::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_Process::error_string()
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
::HoneyClient::Message_Process::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_Process::debug_string()
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
::HoneyClient::Message_Process::short_debug_string()
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
::HoneyClient::Message_Process::unpack(arg)
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
::HoneyClient::Message_Process::pack()
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
::HoneyClient::Message_Process::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Process::fields()
  PPCODE:
    EXTEND(SP, 4);
    PUSHs(sv_2mortal(newSVpv("name",0)));
    PUSHs(sv_2mortal(newSVpv("pid",0)));
    PUSHs(sv_2mortal(newSVpv("file",0)));
    PUSHs(sv_2mortal(newSVpv("registry",0)));


SV *
::HoneyClient::Message_Process::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Process * msg0 = THIS;

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
      if ( msg0->file_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->file_size(); i0++ ) {
          ::HoneyClient::Message_File * msg2 = msg0->mutable_file(i0);
          HV * hv2 = newHV();
          SV * sv1 = newRV_noinc((SV *)hv2);
          
          if ( msg2->has_time_at() ) {
            SV * sv2 = newSVpv(msg2->time_at().c_str(), msg2->time_at().length());
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
          if ( msg2->has_content() ) {
            ::HoneyClient::Message_File_Content * msg4 = msg2->mutable_content();
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
            hv_store(hv2, "content", sizeof("content") - 1, sv3, 0);
          }
          av_push(av0, sv1);
        }
        hv_store(hv0, "file", sizeof("file") - 1, sv0, 0);
      }
      if ( msg0->registry_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->registry_size(); i0++ ) {
          ::HoneyClient::Message_Registry * msg2 = msg0->mutable_registry(i0);
          HV * hv2 = newHV();
          SV * sv1 = newRV_noinc((SV *)hv2);
          
          if ( msg2->has_time_at() ) {
            SV * sv2 = newSVpv(msg2->time_at().c_str(), msg2->time_at().length());
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
          if ( msg2->has_value() ) {
            SV * sv2 = newSVpv(msg2->value().c_str(), msg2->value().length());
            hv_store(hv2, "value", sizeof("value") - 1, sv2, 0);
          }
          if ( msg2->has_value_name() ) {
            SV * sv2 = newSVpv(msg2->value_name().c_str(), msg2->value_name().length());
            hv_store(hv2, "value_name", sizeof("value_name") - 1, sv2, 0);
          }
          if ( msg2->has_value_type() ) {
            SV * sv2 = newSVpv(msg2->value_type().c_str(), msg2->value_type().length());
            hv_store(hv2, "value_type", sizeof("value_type") - 1, sv2, 0);
          }
          av_push(av0, sv1);
        }
        hv_store(hv0, "registry", sizeof("registry") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
::HoneyClient::Message_Process::has_name()
  CODE:
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Process::clear_name()
  CODE:
    THIS->clear_name();


void
::HoneyClient::Message_Process::name()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Process::set_name(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_name(sval);


I32
::HoneyClient::Message_Process::has_pid()
  CODE:
    RETVAL = THIS->has_pid();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Process::clear_pid()
  CODE:
    THIS->clear_pid();


void
::HoneyClient::Message_Process::pid()
  PREINIT:
    SV * sv;
    ostringstream ost;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      ost.str("");
      ost << THIS->pid();
      sv = sv_2mortal(newSVpv(ost.str().c_str(),
                              ost.str().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Process::set_pid(val)
  char *val

  PREINIT:
    unsigned long long lval;

  CODE:
    lval = strtoull((val) ? val : "", NULL, 0);
    THIS->set_pid(lval);


I32
::HoneyClient::Message_Process::file_size()
  CODE:
    RETVAL = THIS->file_size();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Process::clear_file()
  CODE:
    THIS->clear_file();


void
::HoneyClient::Message_Process::file(...)
  PREINIT:
    SV * sv;
    int index = 0;
    ::HoneyClient::Message_File * val = NULL;

  PPCODE:
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::Process::file(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->file_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          val = new ::HoneyClient::Message_File;
          val->CopyFrom(THIS->file(index));
          sv = sv_newmortal();
          sv_setref_pv(sv, "HoneyClient::Message::File", (void *)val);
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->file_size() ) {
        EXTEND(SP,1);
        val = new ::HoneyClient::Message_File;
        val->CopyFrom(THIS->file(index));
        sv = sv_newmortal();
        sv_setref_pv(sv, "HoneyClient::Message::File", (void *)val);
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
::HoneyClient::Message_Process::add_file(val)
  ::HoneyClient::Message_File * val

  PREINIT:
    ::HoneyClient::Message_File * mval;

  CODE:
    if ( val != NULL ) {
      mval = THIS->add_file();
      mval->CopyFrom(*val);
    }


I32
::HoneyClient::Message_Process::registry_size()
  CODE:
    RETVAL = THIS->registry_size();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Process::clear_registry()
  CODE:
    THIS->clear_registry();


void
::HoneyClient::Message_Process::registry(...)
  PREINIT:
    SV * sv;
    int index = 0;
    ::HoneyClient::Message_Registry * val = NULL;

  PPCODE:
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::Process::registry(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->registry_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          val = new ::HoneyClient::Message_Registry;
          val->CopyFrom(THIS->registry(index));
          sv = sv_newmortal();
          sv_setref_pv(sv, "HoneyClient::Message::Registry", (void *)val);
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->registry_size() ) {
        EXTEND(SP,1);
        val = new ::HoneyClient::Message_Registry;
        val->CopyFrom(THIS->registry(index));
        sv = sv_newmortal();
        sv_setref_pv(sv, "HoneyClient::Message::Registry", (void *)val);
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
::HoneyClient::Message_Process::add_registry(val)
  ::HoneyClient::Message_Registry * val

  PREINIT:
    ::HoneyClient::Message_Registry * mval;

  CODE:
    if ( val != NULL ) {
      mval = THIS->add_registry();
      mval->CopyFrom(*val);
    }


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Fingerprint
PROTOTYPES: ENABLE


::HoneyClient::Message_Fingerprint *
::HoneyClient::Message_Fingerprint::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Fingerprint") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_Fingerprint_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_Fingerprint;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_Fingerprint;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Fingerprint::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_Fingerprint::copy_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Fingerprint::merge_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Fingerprint::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_Fingerprint::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_Fingerprint::error_string()
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
::HoneyClient::Message_Fingerprint::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_Fingerprint::debug_string()
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
::HoneyClient::Message_Fingerprint::short_debug_string()
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
::HoneyClient::Message_Fingerprint::unpack(arg)
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
::HoneyClient::Message_Fingerprint::pack()
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
::HoneyClient::Message_Fingerprint::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Fingerprint::fields()
  PPCODE:
    EXTEND(SP, 1);
    PUSHs(sv_2mortal(newSVpv("process",0)));


SV *
::HoneyClient::Message_Fingerprint::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Fingerprint * msg0 = THIS;

      if ( msg0->process_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->process_size(); i0++ ) {
          ::HoneyClient::Message_Process * msg2 = msg0->mutable_process(i0);
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
          if ( msg2->file_size() > 0 ) {
            AV * av2 = newAV();
            SV * sv2 = newRV_noinc((SV *)av2);
            
            for ( int i2 = 0; i2 < msg2->file_size(); i2++ ) {
              ::HoneyClient::Message_File * msg4 = msg2->mutable_file(i2);
              HV * hv4 = newHV();
              SV * sv3 = newRV_noinc((SV *)hv4);
              
              if ( msg4->has_time_at() ) {
                SV * sv4 = newSVpv(msg4->time_at().c_str(), msg4->time_at().length());
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
              if ( msg4->has_content() ) {
                ::HoneyClient::Message_File_Content * msg6 = msg4->mutable_content();
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
                hv_store(hv4, "content", sizeof("content") - 1, sv5, 0);
              }
              av_push(av2, sv3);
            }
            hv_store(hv2, "file", sizeof("file") - 1, sv2, 0);
          }
          if ( msg2->registry_size() > 0 ) {
            AV * av2 = newAV();
            SV * sv2 = newRV_noinc((SV *)av2);
            
            for ( int i2 = 0; i2 < msg2->registry_size(); i2++ ) {
              ::HoneyClient::Message_Registry * msg4 = msg2->mutable_registry(i2);
              HV * hv4 = newHV();
              SV * sv3 = newRV_noinc((SV *)hv4);
              
              if ( msg4->has_time_at() ) {
                SV * sv4 = newSVpv(msg4->time_at().c_str(), msg4->time_at().length());
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
              if ( msg4->has_value() ) {
                SV * sv4 = newSVpv(msg4->value().c_str(), msg4->value().length());
                hv_store(hv4, "value", sizeof("value") - 1, sv4, 0);
              }
              if ( msg4->has_value_name() ) {
                SV * sv4 = newSVpv(msg4->value_name().c_str(), msg4->value_name().length());
                hv_store(hv4, "value_name", sizeof("value_name") - 1, sv4, 0);
              }
              if ( msg4->has_value_type() ) {
                SV * sv4 = newSVpv(msg4->value_type().c_str(), msg4->value_type().length());
                hv_store(hv4, "value_type", sizeof("value_type") - 1, sv4, 0);
              }
              av_push(av2, sv3);
            }
            hv_store(hv2, "registry", sizeof("registry") - 1, sv2, 0);
          }
          av_push(av0, sv1);
        }
        hv_store(hv0, "process", sizeof("process") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
::HoneyClient::Message_Fingerprint::process_size()
  CODE:
    RETVAL = THIS->process_size();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Fingerprint::clear_process()
  CODE:
    THIS->clear_process();


void
::HoneyClient::Message_Fingerprint::process(...)
  PREINIT:
    SV * sv;
    int index = 0;
    ::HoneyClient::Message_Process * val = NULL;

  PPCODE:
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::Fingerprint::process(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->process_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          val = new ::HoneyClient::Message_Process;
          val->CopyFrom(THIS->process(index));
          sv = sv_newmortal();
          sv_setref_pv(sv, "HoneyClient::Message::Process", (void *)val);
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->process_size() ) {
        EXTEND(SP,1);
        val = new ::HoneyClient::Message_Process;
        val->CopyFrom(THIS->process(index));
        sv = sv_newmortal();
        sv_setref_pv(sv, "HoneyClient::Message::Process", (void *)val);
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
::HoneyClient::Message_Fingerprint::add_process(val)
  ::HoneyClient::Message_Process * val

  PREINIT:
    ::HoneyClient::Message_Process * mval;

  CODE:
    if ( val != NULL ) {
      mval = THIS->add_process();
      mval->CopyFrom(*val);
    }


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Url
PROTOTYPES: ENABLE


BOOT:
  {
    HV * stash;

    stash = gv_stashpv("HoneyClient::Message::Url::Status", TRUE);
    newCONSTSUB(stash, "NOT_VISITED", newSViv(::HoneyClient::Message_Url::NOT_VISITED));
    newCONSTSUB(stash, "VISITED", newSViv(::HoneyClient::Message_Url::VISITED));
    newCONSTSUB(stash, "IGNORED", newSViv(::HoneyClient::Message_Url::IGNORED));
    newCONSTSUB(stash, "TIMED_OUT", newSViv(::HoneyClient::Message_Url::TIMED_OUT));
    newCONSTSUB(stash, "ERROR", newSViv(::HoneyClient::Message_Url::ERROR));
    newCONSTSUB(stash, "SUSPICIOUS", newSViv(::HoneyClient::Message_Url::SUSPICIOUS));
  }


::HoneyClient::Message_Url *
::HoneyClient::Message_Url::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Url") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_Url_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_Url;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_Url;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Url::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_Url::copy_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Url::merge_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Url::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_Url::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_Url::error_string()
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
::HoneyClient::Message_Url::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_Url::debug_string()
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
::HoneyClient::Message_Url::short_debug_string()
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
::HoneyClient::Message_Url::unpack(arg)
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
::HoneyClient::Message_Url::pack()
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
::HoneyClient::Message_Url::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Url::fields()
  PPCODE:
    EXTEND(SP, 4);
    PUSHs(sv_2mortal(newSVpv("name",0)));
    PUSHs(sv_2mortal(newSVpv("status",0)));
    PUSHs(sv_2mortal(newSVpv("client",0)));
    PUSHs(sv_2mortal(newSVpv("fingerprint",0)));


SV *
::HoneyClient::Message_Url::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Url * msg0 = THIS;

      if ( msg0->has_name() ) {
        SV * sv0 = newSVpv(msg0->name().c_str(), msg0->name().length());
        hv_store(hv0, "name", sizeof("name") - 1, sv0, 0);
      }
      if ( msg0->has_status() ) {
        SV * sv0 = newSViv(msg0->status());
        hv_store(hv0, "status", sizeof("status") - 1, sv0, 0);
      }
      if ( msg0->has_client() ) {
        ::HoneyClient::Message_Client * msg2 = msg0->mutable_client();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->has_vm_name() ) {
          SV * sv2 = newSVpv(msg2->vm_name().c_str(), msg2->vm_name().length());
          hv_store(hv2, "vm_name", sizeof("vm_name") - 1, sv2, 0);
        }
        if ( msg2->has_snapshot_name() ) {
          SV * sv2 = newSVpv(msg2->snapshot_name().c_str(), msg2->snapshot_name().length());
          hv_store(hv2, "snapshot_name", sizeof("snapshot_name") - 1, sv2, 0);
        }
        if ( msg2->has_status() ) {
          SV * sv2 = newSVpv(msg2->status().c_str(), msg2->status().length());
          hv_store(hv2, "status", sizeof("status") - 1, sv2, 0);
        }
        if ( msg2->has_start_at() ) {
          SV * sv2 = newSVpv(msg2->start_at().c_str(), msg2->start_at().length());
          hv_store(hv2, "start_at", sizeof("start_at") - 1, sv2, 0);
        }
        if ( msg2->has_compromise_at() ) {
          SV * sv2 = newSVpv(msg2->compromise_at().c_str(), msg2->compromise_at().length());
          hv_store(hv2, "compromise_at", sizeof("compromise_at") - 1, sv2, 0);
        }
        hv_store(hv0, "client", sizeof("client") - 1, sv1, 0);
      }
      if ( msg0->has_fingerprint() ) {
        ::HoneyClient::Message_Fingerprint * msg2 = msg0->mutable_fingerprint();
        HV * hv2 = newHV();
        SV * sv1 = newRV_noinc((SV *)hv2);
        
        if ( msg2->process_size() > 0 ) {
          AV * av2 = newAV();
          SV * sv2 = newRV_noinc((SV *)av2);
          
          for ( int i2 = 0; i2 < msg2->process_size(); i2++ ) {
            ::HoneyClient::Message_Process * msg4 = msg2->mutable_process(i2);
            HV * hv4 = newHV();
            SV * sv3 = newRV_noinc((SV *)hv4);
            
            if ( msg4->has_name() ) {
              SV * sv4 = newSVpv(msg4->name().c_str(), msg4->name().length());
              hv_store(hv4, "name", sizeof("name") - 1, sv4, 0);
            }
            if ( msg4->has_pid() ) {
              ostringstream ost4;
              
              ost4 << msg4->pid();
              SV * sv4 = newSVpv(ost4.str().c_str(), ost4.str().length());
              hv_store(hv4, "pid", sizeof("pid") - 1, sv4, 0);
            }
            if ( msg4->file_size() > 0 ) {
              AV * av4 = newAV();
              SV * sv4 = newRV_noinc((SV *)av4);
              
              for ( int i4 = 0; i4 < msg4->file_size(); i4++ ) {
                ::HoneyClient::Message_File * msg6 = msg4->mutable_file(i4);
                HV * hv6 = newHV();
                SV * sv5 = newRV_noinc((SV *)hv6);
                
                if ( msg6->has_time_at() ) {
                  SV * sv6 = newSVpv(msg6->time_at().c_str(), msg6->time_at().length());
                  hv_store(hv6, "time_at", sizeof("time_at") - 1, sv6, 0);
                }
                if ( msg6->has_name() ) {
                  SV * sv6 = newSVpv(msg6->name().c_str(), msg6->name().length());
                  hv_store(hv6, "name", sizeof("name") - 1, sv6, 0);
                }
                if ( msg6->has_event() ) {
                  SV * sv6 = newSVpv(msg6->event().c_str(), msg6->event().length());
                  hv_store(hv6, "event", sizeof("event") - 1, sv6, 0);
                }
                if ( msg6->has_content() ) {
                  ::HoneyClient::Message_File_Content * msg8 = msg6->mutable_content();
                  HV * hv8 = newHV();
                  SV * sv7 = newRV_noinc((SV *)hv8);
                  
                  if ( msg8->has_size() ) {
                    ostringstream ost8;
                    
                    ost8 << msg8->size();
                    SV * sv8 = newSVpv(ost8.str().c_str(), ost8.str().length());
                    hv_store(hv8, "size", sizeof("size") - 1, sv8, 0);
                  }
                  if ( msg8->has_md5() ) {
                    SV * sv8 = newSVpv(msg8->md5().c_str(), msg8->md5().length());
                    hv_store(hv8, "md5", sizeof("md5") - 1, sv8, 0);
                  }
                  if ( msg8->has_sha1() ) {
                    SV * sv8 = newSVpv(msg8->sha1().c_str(), msg8->sha1().length());
                    hv_store(hv8, "sha1", sizeof("sha1") - 1, sv8, 0);
                  }
                  if ( msg8->has_mime_type() ) {
                    SV * sv8 = newSVpv(msg8->mime_type().c_str(), msg8->mime_type().length());
                    hv_store(hv8, "mime_type", sizeof("mime_type") - 1, sv8, 0);
                  }
                  hv_store(hv6, "content", sizeof("content") - 1, sv7, 0);
                }
                av_push(av4, sv5);
              }
              hv_store(hv4, "file", sizeof("file") - 1, sv4, 0);
            }
            if ( msg4->registry_size() > 0 ) {
              AV * av4 = newAV();
              SV * sv4 = newRV_noinc((SV *)av4);
              
              for ( int i4 = 0; i4 < msg4->registry_size(); i4++ ) {
                ::HoneyClient::Message_Registry * msg6 = msg4->mutable_registry(i4);
                HV * hv6 = newHV();
                SV * sv5 = newRV_noinc((SV *)hv6);
                
                if ( msg6->has_time_at() ) {
                  SV * sv6 = newSVpv(msg6->time_at().c_str(), msg6->time_at().length());
                  hv_store(hv6, "time_at", sizeof("time_at") - 1, sv6, 0);
                }
                if ( msg6->has_name() ) {
                  SV * sv6 = newSVpv(msg6->name().c_str(), msg6->name().length());
                  hv_store(hv6, "name", sizeof("name") - 1, sv6, 0);
                }
                if ( msg6->has_event() ) {
                  SV * sv6 = newSVpv(msg6->event().c_str(), msg6->event().length());
                  hv_store(hv6, "event", sizeof("event") - 1, sv6, 0);
                }
                if ( msg6->has_value() ) {
                  SV * sv6 = newSVpv(msg6->value().c_str(), msg6->value().length());
                  hv_store(hv6, "value", sizeof("value") - 1, sv6, 0);
                }
                if ( msg6->has_value_name() ) {
                  SV * sv6 = newSVpv(msg6->value_name().c_str(), msg6->value_name().length());
                  hv_store(hv6, "value_name", sizeof("value_name") - 1, sv6, 0);
                }
                if ( msg6->has_value_type() ) {
                  SV * sv6 = newSVpv(msg6->value_type().c_str(), msg6->value_type().length());
                  hv_store(hv6, "value_type", sizeof("value_type") - 1, sv6, 0);
                }
                av_push(av4, sv5);
              }
              hv_store(hv4, "registry", sizeof("registry") - 1, sv4, 0);
            }
            av_push(av2, sv3);
          }
          hv_store(hv2, "process", sizeof("process") - 1, sv2, 0);
        }
        hv_store(hv0, "fingerprint", sizeof("fingerprint") - 1, sv1, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
::HoneyClient::Message_Url::has_name()
  CODE:
    RETVAL = THIS->has_name();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Url::clear_name()
  CODE:
    THIS->clear_name();


void
::HoneyClient::Message_Url::name()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->name().c_str(),
                              THIS->name().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Url::set_name(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_name(sval);


I32
::HoneyClient::Message_Url::has_status()
  CODE:
    RETVAL = THIS->has_status();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Url::clear_status()
  CODE:
    THIS->clear_status();


void
::HoneyClient::Message_Url::status()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->status()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Url::set_status(val)
  IV val

  CODE:
    if ( ::HoneyClient::Message_Url_Status_IsValid(val) ) {
      THIS->set_status((::HoneyClient::Message_Url_Status)val);
    }


I32
::HoneyClient::Message_Url::has_client()
  CODE:
    RETVAL = THIS->has_client();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Url::clear_client()
  CODE:
    THIS->clear_client();


void
::HoneyClient::Message_Url::client()
  PREINIT:
    SV * sv;
    ::HoneyClient::Message_Client * val = NULL;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_Client;
      val->CopyFrom(THIS->client());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::Client", (void *)val);
      PUSHs(sv);
    }


void
::HoneyClient::Message_Url::set_client(val)
  ::HoneyClient::Message_Client * val

  PREINIT:
    ::HoneyClient::Message_Client * mval;

  CODE:
    if ( val != NULL ) {
      mval = THIS->mutable_client();
      mval->CopyFrom(*val);
    }


I32
::HoneyClient::Message_Url::has_fingerprint()
  CODE:
    RETVAL = THIS->has_fingerprint();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Url::clear_fingerprint()
  CODE:
    THIS->clear_fingerprint();


void
::HoneyClient::Message_Url::fingerprint()
  PREINIT:
    SV * sv;
    ::HoneyClient::Message_Fingerprint * val = NULL;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      val = new ::HoneyClient::Message_Fingerprint;
      val->CopyFrom(THIS->fingerprint());
      sv = sv_newmortal();
      sv_setref_pv(sv, "HoneyClient::Message::Fingerprint", (void *)val);
      PUSHs(sv);
    }


void
::HoneyClient::Message_Url::set_fingerprint(val)
  ::HoneyClient::Message_Fingerprint * val

  PREINIT:
    ::HoneyClient::Message_Fingerprint * mval;

  CODE:
    if ( val != NULL ) {
      mval = THIS->mutable_fingerprint();
      mval->CopyFrom(*val);
    }


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Job
PROTOTYPES: ENABLE


::HoneyClient::Message_Job *
::HoneyClient::Message_Job::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Job") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_Job_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_Job;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_Job;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Job::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_Job::copy_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Job::merge_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Job::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_Job::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_Job::error_string()
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
::HoneyClient::Message_Job::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_Job::debug_string()
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
::HoneyClient::Message_Job::short_debug_string()
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
::HoneyClient::Message_Job::unpack(arg)
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
::HoneyClient::Message_Job::pack()
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
::HoneyClient::Message_Job::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Job::fields()
  PPCODE:
    EXTEND(SP, 5);
    PUSHs(sv_2mortal(newSVpv("uuid",0)));
    PUSHs(sv_2mortal(newSVpv("created_at",0)));
    PUSHs(sv_2mortal(newSVpv("completed_at",0)));
    PUSHs(sv_2mortal(newSVpv("total_num_urls",0)));
    PUSHs(sv_2mortal(newSVpv("url",0)));


SV *
::HoneyClient::Message_Job::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Job * msg0 = THIS;

      if ( msg0->has_uuid() ) {
        SV * sv0 = newSVpv(msg0->uuid().c_str(), msg0->uuid().length());
        hv_store(hv0, "uuid", sizeof("uuid") - 1, sv0, 0);
      }
      if ( msg0->has_created_at() ) {
        SV * sv0 = newSVpv(msg0->created_at().c_str(), msg0->created_at().length());
        hv_store(hv0, "created_at", sizeof("created_at") - 1, sv0, 0);
      }
      if ( msg0->has_completed_at() ) {
        SV * sv0 = newSVpv(msg0->completed_at().c_str(), msg0->completed_at().length());
        hv_store(hv0, "completed_at", sizeof("completed_at") - 1, sv0, 0);
      }
      if ( msg0->has_total_num_urls() ) {
        ostringstream ost0;
        
        ost0 << msg0->total_num_urls();
        SV * sv0 = newSVpv(ost0.str().c_str(), ost0.str().length());
        hv_store(hv0, "total_num_urls", sizeof("total_num_urls") - 1, sv0, 0);
      }
      if ( msg0->url_size() > 0 ) {
        AV * av0 = newAV();
        SV * sv0 = newRV_noinc((SV *)av0);
        
        for ( int i0 = 0; i0 < msg0->url_size(); i0++ ) {
          ::HoneyClient::Message_Url * msg2 = msg0->mutable_url(i0);
          HV * hv2 = newHV();
          SV * sv1 = newRV_noinc((SV *)hv2);
          
          if ( msg2->has_name() ) {
            SV * sv2 = newSVpv(msg2->name().c_str(), msg2->name().length());
            hv_store(hv2, "name", sizeof("name") - 1, sv2, 0);
          }
          if ( msg2->has_status() ) {
            SV * sv2 = newSViv(msg2->status());
            hv_store(hv2, "status", sizeof("status") - 1, sv2, 0);
          }
          if ( msg2->has_client() ) {
            ::HoneyClient::Message_Client * msg4 = msg2->mutable_client();
            HV * hv4 = newHV();
            SV * sv3 = newRV_noinc((SV *)hv4);
            
            if ( msg4->has_vm_name() ) {
              SV * sv4 = newSVpv(msg4->vm_name().c_str(), msg4->vm_name().length());
              hv_store(hv4, "vm_name", sizeof("vm_name") - 1, sv4, 0);
            }
            if ( msg4->has_snapshot_name() ) {
              SV * sv4 = newSVpv(msg4->snapshot_name().c_str(), msg4->snapshot_name().length());
              hv_store(hv4, "snapshot_name", sizeof("snapshot_name") - 1, sv4, 0);
            }
            if ( msg4->has_status() ) {
              SV * sv4 = newSVpv(msg4->status().c_str(), msg4->status().length());
              hv_store(hv4, "status", sizeof("status") - 1, sv4, 0);
            }
            if ( msg4->has_start_at() ) {
              SV * sv4 = newSVpv(msg4->start_at().c_str(), msg4->start_at().length());
              hv_store(hv4, "start_at", sizeof("start_at") - 1, sv4, 0);
            }
            if ( msg4->has_compromise_at() ) {
              SV * sv4 = newSVpv(msg4->compromise_at().c_str(), msg4->compromise_at().length());
              hv_store(hv4, "compromise_at", sizeof("compromise_at") - 1, sv4, 0);
            }
            hv_store(hv2, "client", sizeof("client") - 1, sv3, 0);
          }
          if ( msg2->has_fingerprint() ) {
            ::HoneyClient::Message_Fingerprint * msg4 = msg2->mutable_fingerprint();
            HV * hv4 = newHV();
            SV * sv3 = newRV_noinc((SV *)hv4);
            
            if ( msg4->process_size() > 0 ) {
              AV * av4 = newAV();
              SV * sv4 = newRV_noinc((SV *)av4);
              
              for ( int i4 = 0; i4 < msg4->process_size(); i4++ ) {
                ::HoneyClient::Message_Process * msg6 = msg4->mutable_process(i4);
                HV * hv6 = newHV();
                SV * sv5 = newRV_noinc((SV *)hv6);
                
                if ( msg6->has_name() ) {
                  SV * sv6 = newSVpv(msg6->name().c_str(), msg6->name().length());
                  hv_store(hv6, "name", sizeof("name") - 1, sv6, 0);
                }
                if ( msg6->has_pid() ) {
                  ostringstream ost6;
                  
                  ost6 << msg6->pid();
                  SV * sv6 = newSVpv(ost6.str().c_str(), ost6.str().length());
                  hv_store(hv6, "pid", sizeof("pid") - 1, sv6, 0);
                }
                if ( msg6->file_size() > 0 ) {
                  AV * av6 = newAV();
                  SV * sv6 = newRV_noinc((SV *)av6);
                  
                  for ( int i6 = 0; i6 < msg6->file_size(); i6++ ) {
                    ::HoneyClient::Message_File * msg8 = msg6->mutable_file(i6);
                    HV * hv8 = newHV();
                    SV * sv7 = newRV_noinc((SV *)hv8);
                    
                    if ( msg8->has_time_at() ) {
                      SV * sv8 = newSVpv(msg8->time_at().c_str(), msg8->time_at().length());
                      hv_store(hv8, "time_at", sizeof("time_at") - 1, sv8, 0);
                    }
                    if ( msg8->has_name() ) {
                      SV * sv8 = newSVpv(msg8->name().c_str(), msg8->name().length());
                      hv_store(hv8, "name", sizeof("name") - 1, sv8, 0);
                    }
                    if ( msg8->has_event() ) {
                      SV * sv8 = newSVpv(msg8->event().c_str(), msg8->event().length());
                      hv_store(hv8, "event", sizeof("event") - 1, sv8, 0);
                    }
                    if ( msg8->has_content() ) {
                      ::HoneyClient::Message_File_Content * msg10 = msg8->mutable_content();
                      HV * hv10 = newHV();
                      SV * sv9 = newRV_noinc((SV *)hv10);
                      
                      if ( msg10->has_size() ) {
                        ostringstream ost10;
                        
                        ost10 << msg10->size();
                        SV * sv10 = newSVpv(ost10.str().c_str(), ost10.str().length());
                        hv_store(hv10, "size", sizeof("size") - 1, sv10, 0);
                      }
                      if ( msg10->has_md5() ) {
                        SV * sv10 = newSVpv(msg10->md5().c_str(), msg10->md5().length());
                        hv_store(hv10, "md5", sizeof("md5") - 1, sv10, 0);
                      }
                      if ( msg10->has_sha1() ) {
                        SV * sv10 = newSVpv(msg10->sha1().c_str(), msg10->sha1().length());
                        hv_store(hv10, "sha1", sizeof("sha1") - 1, sv10, 0);
                      }
                      if ( msg10->has_mime_type() ) {
                        SV * sv10 = newSVpv(msg10->mime_type().c_str(), msg10->mime_type().length());
                        hv_store(hv10, "mime_type", sizeof("mime_type") - 1, sv10, 0);
                      }
                      hv_store(hv8, "content", sizeof("content") - 1, sv9, 0);
                    }
                    av_push(av6, sv7);
                  }
                  hv_store(hv6, "file", sizeof("file") - 1, sv6, 0);
                }
                if ( msg6->registry_size() > 0 ) {
                  AV * av6 = newAV();
                  SV * sv6 = newRV_noinc((SV *)av6);
                  
                  for ( int i6 = 0; i6 < msg6->registry_size(); i6++ ) {
                    ::HoneyClient::Message_Registry * msg8 = msg6->mutable_registry(i6);
                    HV * hv8 = newHV();
                    SV * sv7 = newRV_noinc((SV *)hv8);
                    
                    if ( msg8->has_time_at() ) {
                      SV * sv8 = newSVpv(msg8->time_at().c_str(), msg8->time_at().length());
                      hv_store(hv8, "time_at", sizeof("time_at") - 1, sv8, 0);
                    }
                    if ( msg8->has_name() ) {
                      SV * sv8 = newSVpv(msg8->name().c_str(), msg8->name().length());
                      hv_store(hv8, "name", sizeof("name") - 1, sv8, 0);
                    }
                    if ( msg8->has_event() ) {
                      SV * sv8 = newSVpv(msg8->event().c_str(), msg8->event().length());
                      hv_store(hv8, "event", sizeof("event") - 1, sv8, 0);
                    }
                    if ( msg8->has_value() ) {
                      SV * sv8 = newSVpv(msg8->value().c_str(), msg8->value().length());
                      hv_store(hv8, "value", sizeof("value") - 1, sv8, 0);
                    }
                    if ( msg8->has_value_name() ) {
                      SV * sv8 = newSVpv(msg8->value_name().c_str(), msg8->value_name().length());
                      hv_store(hv8, "value_name", sizeof("value_name") - 1, sv8, 0);
                    }
                    if ( msg8->has_value_type() ) {
                      SV * sv8 = newSVpv(msg8->value_type().c_str(), msg8->value_type().length());
                      hv_store(hv8, "value_type", sizeof("value_type") - 1, sv8, 0);
                    }
                    av_push(av6, sv7);
                  }
                  hv_store(hv6, "registry", sizeof("registry") - 1, sv6, 0);
                }
                av_push(av4, sv5);
              }
              hv_store(hv4, "process", sizeof("process") - 1, sv4, 0);
            }
            hv_store(hv2, "fingerprint", sizeof("fingerprint") - 1, sv3, 0);
          }
          av_push(av0, sv1);
        }
        hv_store(hv0, "url", sizeof("url") - 1, sv0, 0);
      }
      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


I32
::HoneyClient::Message_Job::has_uuid()
  CODE:
    RETVAL = THIS->has_uuid();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Job::clear_uuid()
  CODE:
    THIS->clear_uuid();


void
::HoneyClient::Message_Job::uuid()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->uuid().c_str(),
                              THIS->uuid().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Job::set_uuid(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_uuid(sval);


I32
::HoneyClient::Message_Job::has_created_at()
  CODE:
    RETVAL = THIS->has_created_at();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Job::clear_created_at()
  CODE:
    THIS->clear_created_at();


void
::HoneyClient::Message_Job::created_at()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->created_at().c_str(),
                              THIS->created_at().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Job::set_created_at(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_created_at(sval);


I32
::HoneyClient::Message_Job::has_completed_at()
  CODE:
    RETVAL = THIS->has_completed_at();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Job::clear_completed_at()
  CODE:
    THIS->clear_completed_at();


void
::HoneyClient::Message_Job::completed_at()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSVpv(THIS->completed_at().c_str(),
                              THIS->completed_at().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Job::set_completed_at(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_completed_at(sval);


I32
::HoneyClient::Message_Job::has_total_num_urls()
  CODE:
    RETVAL = THIS->has_total_num_urls();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Job::clear_total_num_urls()
  CODE:
    THIS->clear_total_num_urls();


void
::HoneyClient::Message_Job::total_num_urls()
  PREINIT:
    SV * sv;
    ostringstream ost;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      ost.str("");
      ost << THIS->total_num_urls();
      sv = sv_2mortal(newSVpv(ost.str().c_str(),
                              ost.str().length()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Job::set_total_num_urls(val)
  char *val

  PREINIT:
    unsigned long long lval;

  CODE:
    lval = strtoull((val) ? val : "", NULL, 0);
    THIS->set_total_num_urls(lval);


I32
::HoneyClient::Message_Job::url_size()
  CODE:
    RETVAL = THIS->url_size();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Job::clear_url()
  CODE:
    THIS->clear_url();


void
::HoneyClient::Message_Job::url(...)
  PREINIT:
    SV * sv;
    int index = 0;
    ::HoneyClient::Message_Url * val = NULL;

  PPCODE:
    if ( items == 2 ) {
      index = SvIV(ST(1));
    } else if ( items > 2 ) {
      croak("Usage: HoneyClient::Message::Job::url(CLASS, [index])");
    }
    if ( THIS != NULL ) {
      if ( items == 1 ) {
        int count = THIS->url_size();

        EXTEND(SP, count);
        for ( int index = 0; index < count; index++ ) {
          val = new ::HoneyClient::Message_Url;
          val->CopyFrom(THIS->url(index));
          sv = sv_newmortal();
          sv_setref_pv(sv, "HoneyClient::Message::Url", (void *)val);
          PUSHs(sv);
        }
      } else if ( index >= 0 &&
                  index < THIS->url_size() ) {
        EXTEND(SP,1);
        val = new ::HoneyClient::Message_Url;
        val->CopyFrom(THIS->url(index));
        sv = sv_newmortal();
        sv_setref_pv(sv, "HoneyClient::Message::Url", (void *)val);
        PUSHs(sv);
      } else {
        EXTEND(SP,1);
        PUSHs(&PL_sv_undef);
      }
    }


void
::HoneyClient::Message_Job::add_url(val)
  ::HoneyClient::Message_Url * val

  PREINIT:
    ::HoneyClient::Message_Url * mval;

  CODE:
    if ( val != NULL ) {
      mval = THIS->add_url();
      mval->CopyFrom(*val);
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


::HoneyClient::Message_Firewall_Command *
::HoneyClient::Message_Firewall_Command::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Firewall::Command") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_Firewall_Command_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_Firewall_Command;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_Firewall_Command;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_Firewall_Command::copy_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Firewall_Command::merge_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Firewall_Command::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_Firewall_Command::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_Firewall_Command::error_string()
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
::HoneyClient::Message_Firewall_Command::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_Firewall_Command::debug_string()
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
::HoneyClient::Message_Firewall_Command::short_debug_string()
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
::HoneyClient::Message_Firewall_Command::unpack(arg)
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
::HoneyClient::Message_Firewall_Command::pack()
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
::HoneyClient::Message_Firewall_Command::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::fields()
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
::HoneyClient::Message_Firewall_Command::to_hashref()
  CODE:
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
::HoneyClient::Message_Firewall_Command::has_action()
  CODE:
    RETVAL = THIS->has_action();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::clear_action()
  CODE:
    THIS->clear_action();


void
::HoneyClient::Message_Firewall_Command::action()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->action()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Firewall_Command::set_action(val)
  IV val

  CODE:
    if ( ::HoneyClient::Message_Firewall_Command_ActionType_IsValid(val) ) {
      THIS->set_action((::HoneyClient::Message_Firewall_Command_ActionType)val);
    }


I32
::HoneyClient::Message_Firewall_Command::has_response()
  CODE:
    RETVAL = THIS->has_response();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::clear_response()
  CODE:
    THIS->clear_response();


void
::HoneyClient::Message_Firewall_Command::response()
  PREINIT:
    SV * sv;

  PPCODE:
    if ( THIS != NULL ) {
      EXTEND(SP,1);
      sv = sv_2mortal(newSViv(THIS->response()));
      PUSHs(sv);
    }


void
::HoneyClient::Message_Firewall_Command::set_response(val)
  IV val

  CODE:
    if ( ::HoneyClient::Message_Firewall_Command_ResponseType_IsValid(val) ) {
      THIS->set_response((::HoneyClient::Message_Firewall_Command_ResponseType)val);
    }


I32
::HoneyClient::Message_Firewall_Command::has_err_message()
  CODE:
    RETVAL = THIS->has_err_message();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::clear_err_message()
  CODE:
    THIS->clear_err_message();


void
::HoneyClient::Message_Firewall_Command::err_message()
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
::HoneyClient::Message_Firewall_Command::set_err_message(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_err_message(sval);


I32
::HoneyClient::Message_Firewall_Command::has_chain_name()
  CODE:
    RETVAL = THIS->has_chain_name();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::clear_chain_name()
  CODE:
    THIS->clear_chain_name();


void
::HoneyClient::Message_Firewall_Command::chain_name()
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
::HoneyClient::Message_Firewall_Command::set_chain_name(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_chain_name(sval);


I32
::HoneyClient::Message_Firewall_Command::has_mac_address()
  CODE:
    RETVAL = THIS->has_mac_address();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::clear_mac_address()
  CODE:
    THIS->clear_mac_address();


void
::HoneyClient::Message_Firewall_Command::mac_address()
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
::HoneyClient::Message_Firewall_Command::set_mac_address(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_mac_address(sval);


I32
::HoneyClient::Message_Firewall_Command::has_ip_address()
  CODE:
    RETVAL = THIS->has_ip_address();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::clear_ip_address()
  CODE:
    THIS->clear_ip_address();


void
::HoneyClient::Message_Firewall_Command::ip_address()
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
::HoneyClient::Message_Firewall_Command::set_ip_address(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_ip_address(sval);


I32
::HoneyClient::Message_Firewall_Command::has_protocol()
  CODE:
    RETVAL = THIS->has_protocol();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::clear_protocol()
  CODE:
    THIS->clear_protocol();


void
::HoneyClient::Message_Firewall_Command::protocol()
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
::HoneyClient::Message_Firewall_Command::set_protocol(val)
  char *val

  PREINIT:
    string sval = (val) ? val : "";

  CODE:
    THIS->set_protocol(sval);


I32
::HoneyClient::Message_Firewall_Command::port_size()
  CODE:
    RETVAL = THIS->port_size();

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall_Command::clear_port()
  CODE:
    THIS->clear_port();


void
::HoneyClient::Message_Firewall_Command::port(...)
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
::HoneyClient::Message_Firewall_Command::add_port(val)
  UV val

  CODE:
    THIS->add_port(val);


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message::Firewall
PROTOTYPES: ENABLE


::HoneyClient::Message_Firewall *
::HoneyClient::Message_Firewall::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message::Firewall") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_Firewall_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message_Firewall;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message_Firewall;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message_Firewall::copy_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Firewall::merge_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message_Firewall::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message_Firewall::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message_Firewall::error_string()
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
::HoneyClient::Message_Firewall::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message_Firewall::debug_string()
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
::HoneyClient::Message_Firewall::short_debug_string()
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
::HoneyClient::Message_Firewall::unpack(arg)
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
::HoneyClient::Message_Firewall::pack()
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
::HoneyClient::Message_Firewall::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message_Firewall::fields()
  PPCODE:
    EXTEND(SP, 0);


SV *
::HoneyClient::Message_Firewall::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message_Firewall * msg0 = THIS;

      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


MODULE = HoneyClient::Message PACKAGE = HoneyClient::Message
PROTOTYPES: ENABLE


::HoneyClient::Message *
::HoneyClient::Message::new (...)
  CODE:
    if ( strcmp(CLASS,"HoneyClient::Message") ) {
      croak("invalid class %s",CLASS);
    }
    if ( items == 2 ) {
      if ( SvROK(ST(1)) && SvTYPE(SvRV(ST(1))) == SVt_PVHV ) {
        RETVAL = __HoneyClient__Message_from_hashref(ST(1));
      } else {
        STRLEN len;
        char * str;

        RETVAL = new ::HoneyClient::Message;
        str = SvPV(ST(1), len);
        if ( str != NULL ) {
          RETVAL->ParseFromArray(str, len);
        }
      }
    } else {
      RETVAL = new ::HoneyClient::Message;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::DESTROY()
  CODE:
    if ( THIS != NULL ) {
      delete THIS;
    }


void
::HoneyClient::Message::copy_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message::merge_from(sv)
  SV * sv
  CODE:
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
::HoneyClient::Message::clear()
  CODE:
    if ( THIS != NULL ) {
      THIS->Clear();
    }


int
::HoneyClient::Message::is_initialized()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->IsInitialized();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


SV *
::HoneyClient::Message::error_string()
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
::HoneyClient::Message::discard_unkown_fields()
  CODE:
    if ( THIS != NULL ) {
      THIS->DiscardUnknownFields();
    }


SV *
::HoneyClient::Message::debug_string()
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
::HoneyClient::Message::short_debug_string()
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
::HoneyClient::Message::unpack(arg)
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
::HoneyClient::Message::pack()
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
::HoneyClient::Message::length()
  CODE:
    if ( THIS != NULL ) {
      RETVAL = THIS->ByteSize();
    } else {
      RETVAL = 0;
    }

  OUTPUT:
    RETVAL


void
::HoneyClient::Message::fields()
  PPCODE:
    EXTEND(SP, 0);


SV *
::HoneyClient::Message::to_hashref()
  CODE:
    if ( THIS != NULL ) {
      HV * hv0 = newHV();
      ::HoneyClient::Message * msg0 = THIS;

      RETVAL = newRV_noinc((SV *)hv0);
    } else {
      RETVAL = Nullsv;
    }

  OUTPUT:
    RETVAL


