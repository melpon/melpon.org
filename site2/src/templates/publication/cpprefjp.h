#ifndef PUBLICATION_CPPREFJP_H_INCLUDED
#define PUBLICATION_CPPREFJP_H_INCLUDED

#include <string>
#include <functional>
#include <tuple>
#include "googleio.h"

namespace content {
namespace publication {
    struct cpprefjp : public googleio {
        static index_t index1_json() {
            static const char* str = R"raw(
              { "title": "目次"
              , "contents":
                [ { "name": "overview"
                  , "title": "cpprefjpの概要"
                  }
                , { "name": "problem"
                  , "title": "Google Sitesの問題点"
                  }
                , { "name": "do"
                  , "title": "GitHubへの移行"
                  , "contents":
                    [ { "name": "1st"
                      , "title": "Google SitesからGitHubへ(@cpp_akira)"
                      }
                    , { "name": "2nd"
                      , "title": "GitHubからGoogle Sitesへ(@melponn)"
                      }
                    ]
                  }
                ]
              }
            )raw";
            std::stringstream ss(str);
            index_t json;
            json.load(ss, true, nullptr);
            return json;
        }
        std::string index1(index_func_t func, const char* str) {
            static index_t json = index1_json();
            return func(json, str);
        }

        static index_t index2_json() {
            static const char* str = R"raw(
              { "title": "目次"
              , "contents":
                [ { "name": "motivation"
                  , "title": "動機"
                  }
                , { "name": "create"
                  , "title": "作ったもの"
                  , "contents":
                    [ { "name": "md-to-html"
                      , "title": "変換サーバを支える技術"
                      , "contents":
                        [ { "name": "highlight"
                          , "title": "シンタックスハイライト"
                          }
                        , { "name": "github"
                          , "title": "GitHubの差分管理"
                          }
                        ]
                      }
                    , { "name": "html-to-google"
                      , "title": "アップロード用Google Apps Scriptを支える技術"
                      , "contents":
                        [ { "name": "script"
                          , "title": "スクリプトの制限"
                          }
                        , { "name": "error"
                          , "title": "エラー通知"
                          }
                        ]
                      }
                    ]
                  }
                ]
              }
            )raw";
            std::stringstream ss(str);
            index_t json;
            json.load(ss, true, nullptr);
            return json;
        }
        std::string index2(index_func_t func, const char* str) {
            static index_t json = index2_json();
            return func(json, str);
        }
    };
}}

#endif // PUBLICATION_CPPREFJP_H_INCLUDED
